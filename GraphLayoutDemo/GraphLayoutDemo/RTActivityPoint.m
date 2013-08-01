//
//  RTActivityPoint.m
//  GraphLayoutDemo
//
//  Created by Aleksandar Vacić on 1.8.13..
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import "RTActivityPoint.h"

@implementation RTActivityPoint

- (instancetype)initWithValue:(NSInteger)value timestamp:(NSDate *)ts {
	
	self = [super init];
	if (self) {
		_value = @(value);
		_timestamp = ts;
	}
	
	return self;
}

@end
