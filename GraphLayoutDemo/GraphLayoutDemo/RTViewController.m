//
//  RTViewController.m
//  GraphLayoutDemo
//
//  Created by Aleksandar Vacić on 1.8.13..
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import "RTViewController.h"
#import "RTGraphLayout.h"
#import "RTGraphCell.h"
#import "RTGraphLayoutAxis.h"
#import "TimeFormatter.h"
#import "RTActivityPoint.h"

@interface RTViewController ()

@property (nonatomic) CGFloat minGraphValue;
@property (nonatomic) CGFloat maxGraphValue;
@property (nonatomic) CGFloat graphSpan;

@property (nonatomic) NSInteger minValue;
@property (nonatomic) NSInteger maxValue;
@property (nonatomic) NSInteger avgValue;

@property (nonatomic, weak) RTGraphLayoutAxis *axisGridView;

@property (nonatomic) CGFloat maxZoom;
@property (nonatomic) CGFloat currentZoom;
@property (nonatomic) CGFloat reqDotWidth;

@property (nonatomic, strong) TimeFormatter *timeFormatter;

@end

static NSString *RTDETAILSGRAPHCELL = @"RTDETAILSGRAPHCELL";
static NSString *RTDETAILSGRAPHGRID = @"RTDETAILSGRAPHGRID";

@implementation RTViewController

- (instancetype)initWithCollectionViewLayout:(RTGraphLayout *)layout {
	
	self = [super initWithCollectionViewLayout:layout];
	if (self) {
		
		self.points = nil;
		self.timeFormatter = [[TimeFormatter alloc] init];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor blackColor];

	RTGraphLayout *l = (RTGraphLayout *)self.collectionView.collectionViewLayout;
	l.itemSize = CGSizeMake(2, self.view.bounds.size.height);

	self.reqDotWidth = 2.0;
	
	//	setup pinch gesture
	UIPinchGestureRecognizer *gr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	[self.collectionView addGestureRecognizer:gr];
	
	[self.collectionView registerClass:[RTGraphCell class] forCellWithReuseIdentifier:RTDETAILSGRAPHCELL];
	[self.collectionView registerNib:[UINib nibWithNibName:@"RTGraphLayoutAxis" bundle:nil] forSupplementaryViewOfKind:RTGraphLayoutKindAxisGrid withReuseIdentifier:RTDETAILSGRAPHGRID];
}

- (void)setPoints:(NSArray *)points {
	
	if (points == nil || [points count] == 0) {
		//	write a helpful note here, before bailing out
		return;
	}
	
	_points = points;
	
	self.minValue = [[points valueForKeyPath:@"@min.value"] integerValue];
	self.maxValue = [[points valueForKeyPath:@"@max.value"] integerValue];
	self.avgValue = [[points valueForKeyPath:@"@avg.value"] integerValue];
	
	//	add 10% down and up, for better looking graphs
	double diff = (double)self.maxValue - (double)self.minValue;
	
	self.minGraphValue = [@(self.minValue) doubleValue] - .1*diff;
	self.maxGraphValue = [@(self.maxValue) doubleValue] + .1*diff;
	self.graphSpan = self.maxGraphValue - self.minGraphValue;
	
	//	how many points can actually be shown depends on size of the collection view and the minimal size of plot dot
	//	example:
	//	320 cv.width, 1214 points, 2.0f dot.width => 320 / 2 = 160 points that can be shown
	//	meaning, that 1214 / 160 = 7,587 => every 7th points can be shown in the graph
	CGFloat graphPoints = self.collectionView.bounds.size.width / self.reqDotWidth;
	//	thus when "entire" set is shown, we are actually max-zoomed out
	self.maxZoom = (CGFloat)[points count] / graphPoints;
	self.currentZoom = self.maxZoom;
	//	as pinching/spreading happens, we will
	//	- adjust the zoom factor
	//	- always show 160 points
	//	- pinched cell will always be centered unless it's on the edges
	//	- once we get down to showing subsequent points, then it's max-zoomed in
	
	//	collectionViewContentSize = maxZoom / currentZoom * dot.width
	
	[self.collectionView.collectionViewLayout invalidateLayout];
	
	//	draw the graph
	[self.collectionView reloadData];
}



#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	NSInteger secnum = 1;
	return secnum;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger ret = ([self.points count]/self.currentZoom);
	if (ret < 0) ret = 0;
	return ret;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	
	if ([kind isEqualToString:RTGraphLayoutKindAxisGrid]) {
		//	indexPath will be the indexPath of the last visible cell
		RTGraphLayoutAxis *v = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:RTDETAILSGRAPHGRID forIndexPath:indexPath];
		self.axisGridView = v;
		[self configureAxisGridView];
		
		return v;
	}
	
	return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	RTGraphCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RTDETAILSGRAPHCELL forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}


#pragma mark CV helpers

- (void)configureCell:(RTGraphCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger pointIndex = (indexPath.item * self.currentZoom);
	if (pointIndex >= [self.points count]) {
		cell = nil;
		return;
	}
	
	RTActivityPoint *point = [self.points objectAtIndex:pointIndex];
	cell.barColor = [UIColor redColor];
	cell.pointValue = ([point.value floatValue] - self.minGraphValue) / self.graphSpan;
}

- (void)configureAxisGridView {
	
	RTGraphLayoutAxis *v = self.axisGridView;
	
	v.minGraphValue = self.minGraphValue;
	v.maxGraphValue = self.maxGraphValue;
	v.graphSpan = self.graphSpan;
	
	v.maxYValue = [@(self.maxValue) stringValue];
	v.avgYValue = [@(self.avgValue) stringValue];
	v.minYValue = [@(self.minValue) stringValue];
	
	v.avgGraphValue = (CGFloat)self.avgValue;
	
	[self updateAxisGrid];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	[self updateAxisGrid];
}

- (void)updateAxisGrid {
	
	RTGraphLayoutAxis *v = self.axisGridView;
	if (!v) return;
	//	ok, now get the visible cells and pick up actual times
	NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
	if ([visibleItems count] == 0) return;
	NSArray *indexPathsOfVisibleCells = [visibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		NSIndexPath *path1 = (NSIndexPath *)obj1;
		NSIndexPath *path2 = (NSIndexPath *)obj2;
		return [path1 compare:path2];
	}];
	NSIndexPath *minIndexPath = [indexPathsOfVisibleCells objectAtIndex:0];
	v.minXValue = [self secondsSpanForIndexPath:minIndexPath];
	NSIndexPath *midIndexPath = [indexPathsOfVisibleCells objectAtIndex:[indexPathsOfVisibleCells count] / 2];
	v.avgXValue = [self secondsSpanForIndexPath:midIndexPath];
	NSIndexPath *maxIndexPath = [indexPathsOfVisibleCells objectAtIndex:[indexPathsOfVisibleCells count]-1];
	v.maxXValue = [self secondsSpanForIndexPath:maxIndexPath];
}

- (RTActivityPoint *)activityPointForIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger pointIndex = (indexPath.item * self.currentZoom);
	if (pointIndex >= [self.points count]) {
		pointIndex = [self.points count]-1;
	}
	return [self.points objectAtIndex:pointIndex];
}

- (NSString *)secondsSpanForIndexPath:(NSIndexPath *)indexPath {
	
	RTActivityPoint *activityPoint = [self activityPointForIndexPath:indexPath];
	RTActivityPoint *startingPoint = [self.points objectAtIndex:0];
	NSTimeInterval ts = [activityPoint.timestamp timeIntervalSinceDate:startingPoint.timestamp];
	
	return [self.timeFormatter stringForObjectValue:@(ts)];
}

#pragma mark - Gesture

- (void)handlePinch:(UIPinchGestureRecognizer *)gr {
	
	//	.scale < 1 == pinch-in
	//	.scale > 1 == spread-out
	
	if (gr.state == UIGestureRecognizerStateBegan ) {
		//	pinch started, remember over which cell, that's what should be centered, as possible
//		CGPoint initialPinchPoint = [gr locationInView:self.collectionView];
//		NSIndexPath *pinchedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
		
	} else if (gr.state == UIGestureRecognizerStateChanged ) {
		
		CGFloat ZOOM_FACTOR = .3;
		
		if (gr.scale < 1) {
			CGFloat newZoom = self.currentZoom + fabsf(gr.scale * gr.velocity * ZOOM_FACTOR);
			if (newZoom > self.maxZoom) newZoom = self.maxZoom;
			//			NSLog(@"IN:		scale = %@, velocity = %@, zoom: %@ => %@", @(gr.scale), @(gr.velocity), @(self.currentZoom), @(newZoom));
			self.currentZoom = newZoom;
			
		} else if (gr.scale > 1) {
			CGFloat newZoom = self.currentZoom - ((gr.scale-1) * gr.velocity * ZOOM_FACTOR);
			if (newZoom < 1) newZoom = 1;
			//			NSLog(@"OUT:	scale = %@, velocity = %@, zoom: %@ => %@", @(gr.scale), @(gr.velocity), @(self.currentZoom), @(newZoom));
			self.currentZoom = newZoom;
		}
		
		[self.collectionView reloadData];
		
	} else if (gr.state == UIGestureRecognizerStateEnded ) {
		
	}
	
}

@end
