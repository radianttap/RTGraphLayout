//
//  TimeFormatter.m
//  RunMate
//
//  Created by Aleksandar Vacić on 1.3.09..
//  Copyright 2009 code·aplus. All rights reserved.
//

#import "TimeFormatter.h"


@implementation TimeFormatter

- (NSString *)stringForObjectValue:(id)anObject{
	if (! [anObject isKindOfClass: [NSNumber class]]) {
		return nil;
	}
	NSNumber *secondsNumber = (NSNumber*) anObject;
	int seconds = [secondsNumber intValue];
	int minutesPart = seconds / 60;
	int secondsPart = seconds % 60;
	NSString *minutesString = (minutesPart < 10) ? [NSString stringWithFormat:@"0%d", minutesPart] : [NSString stringWithFormat:@"%d", minutesPart];
	NSString *secondsString = (secondsPart < 10) ? [NSString stringWithFormat:@"0%d", secondsPart] : [NSString stringWithFormat:@"%d", secondsPart];
	return [NSString stringWithFormat:@"%@:%@", minutesString, secondsString];
}

@end
