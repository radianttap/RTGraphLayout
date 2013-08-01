//
//  RTGraphLayoutAxis.h
//  RTGraphLayout
//
//  Created by Aleksandar Vacić on 29.7.13..
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTGraphLayoutAxis : UICollectionReusableView

@property (strong, nonatomic) NSString *maxYValue;
@property (strong, nonatomic) NSString *avgYValue;
@property (strong, nonatomic) NSString *minYValue;

@property (strong, nonatomic) NSString *maxXValue;
@property (strong, nonatomic) NSString *avgXValue;
@property (strong, nonatomic) NSString *minXValue;

@property (nonatomic) CGFloat minGraphValue;
@property (nonatomic) CGFloat maxGraphValue;
@property (nonatomic) CGFloat avgGraphValue;
@property (nonatomic) CGFloat graphSpan;

@end
