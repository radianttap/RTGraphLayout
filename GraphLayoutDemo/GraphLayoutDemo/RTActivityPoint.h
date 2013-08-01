//
//  RTActivityPoint.h
//  GraphLayoutDemo
//
//  Created by Aleksandar Vacić on 1.8.13..
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTActivityPoint : NSObject

@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSDate *timestamp;

- (instancetype)initWithValue:(NSInteger)value timestamp:(NSDate *)ts;

@end
