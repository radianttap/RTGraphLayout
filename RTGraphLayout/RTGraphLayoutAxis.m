//
//  RTGraphLayoutAxis.m
//  RTGraphLayout
//
//  Created by Aleksandar Vacić on 29.7.13..
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import "RTGraphLayoutAxis.h"

@interface RTGraphLayoutAxis ()

@property (weak, nonatomic) IBOutlet UILabel *maxYLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgYLabel;
@property (weak, nonatomic) IBOutlet UILabel *minYLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxXLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgXLabel;
@property (weak, nonatomic) IBOutlet UILabel *minXLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avgBottomConstraint;


@end

@implementation RTGraphLayoutAxis

- (void)prepareForReuse {
	[super prepareForReuse];
	
	self.maxXLabel.text = nil;
	self.avgXLabel.text = nil;
	self.minXLabel.text = nil;
	
//	self.maxYLabel.text = nil;
//	self.avgYLabel.text = nil;
//	self.minYLabel.text = nil;
}


#pragma mark - Setters

- (void)setAvgGraphValue:(CGFloat)avgGraphValue {
	
	_avgGraphValue = avgGraphValue;
	self.avgBottomConstraint.constant = ((avgGraphValue - self.minGraphValue) / self.graphSpan) * self.bounds.size.height;
}

- (void)setMaxXValue:(NSString *)maxXValue {
	
	_maxXValue = maxXValue;
	self.maxXLabel.text = maxXValue;
}

- (void)setAvgXValue:(NSString *)avgXValue {
	
	_avgXValue = avgXValue;
	self.avgXLabel.text = avgXValue;
}

- (void)setMinXValue:(NSString *)minXValue {
	
	_minXValue = minXValue;
	self.minXLabel.text = minXValue;
}

- (void)setMaxYValue:(NSString *)maxYValue {
	
	_maxYValue = maxYValue;
	self.maxYLabel.text = maxYValue;
}

- (void)setAvgYValue:(NSString *)avgYValue {
	
	_avgYValue = avgYValue;
	self.avgYLabel.text = avgYValue;
}

- (void)setMinYValue:(NSString *)minYValue {
	
	_minYValue = minYValue;
	self.minYLabel.text = minYValue;
}


@end
