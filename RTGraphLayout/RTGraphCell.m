//
//  RTGraphCell.m
//  RTGraphLayout
//
//  Created by Aleksandar Vacić on 28.7.13..
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import "RTGraphCell.h"
#import <QuartzCore/QuartzCore.h>

@interface RTGraphCell ()

@end

@implementation RTGraphCell

- (instancetype)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self)
		[self commonInit];
	
	return self;
}

- (void)awakeFromNib {
	
	[self commonInit];
}

- (void)commonInit {
	
}

- (void)prepareForReuse {
	[super prepareForReuse];

	self.layer.sublayers = nil;
}

- (void)setPointValue:(CGFloat)pointValue {
	
	_pointValue = pointValue;
	
	CGFloat barPosition = (1.0f - pointValue) * self.bounds.size.height;
	CGFloat barHeight = pointValue * self.bounds.size.height;
	CALayer *sublayer = [CALayer layer];
	sublayer.frame = CGRectMake(0, barPosition, 1, barHeight);
	sublayer.backgroundColor = self.barColor.CGColor;
	[self.layer addSublayer:sublayer];
}

@end
