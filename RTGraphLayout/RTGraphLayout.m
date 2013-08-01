//
//  RTGraphLayout.m
//  RTGraphLayout
//
//  Created by Aleksandar Vacić on 28.7.13..
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import "RTGraphLayout.h"

NSString *const RTGraphLayoutKindAxisGrid = @"RTGraphLayoutKindAxisGrid";

@implementation RTGraphLayout

- (instancetype)init {
	if (!(self = [super init])) return nil;
	
	[self commonInit];
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) return nil;
	
	[self commonInit];
	
	return self;
}

- (void)commonInit {
	
	//	reset values for the flow layout
	self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	self.headerReferenceSize = CGSizeZero;
	self.footerReferenceSize = CGSizeZero;
	self.itemSize = CGSizeMake(2, 2);
	self.minimumInteritemSpacing = 0;
	self.minimumLineSpacing = 0;
	self.sectionInset = UIEdgeInsetsZero;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	
	return YES;
}

- (void)prepareLayout {
	[super prepareLayout];
	
	CGSize s = self.itemSize;
	s.height = self.collectionView.bounds.size.height;
	self.itemSize = s;
}



#pragma mark Layout attributes

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	
	NSMutableArray *laArray = [NSMutableArray array];
	
	NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
	for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
			//	this is the place to apply your custom attributes
			//		[self applyLayoutAttributes:attributes];
			
			[laArray addObject:attributes];
	}

	//	add the grid for the very last cell to be shown
	NSIndexPath *lastIndexPath = [(UICollectionViewLayoutAttributes *)[attributesArray lastObject] indexPath];
	UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:RTGraphLayoutKindAxisGrid atIndexPath:lastIndexPath];
	[laArray addObject:layoutAttributes];

	return laArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    if ([kind isEqualToString:RTGraphLayoutKindAxisGrid]) {
		CGRect f = layoutAttributes.frame;
		f.origin = self.collectionView.contentOffset;
		f.size = self.collectionView.bounds.size;
        layoutAttributes.frame = f;
        // Place the grid view above all the cells
        layoutAttributes.zIndex = 1;
    }
    
    return layoutAttributes;
}

@end
