//
//  CallDurationFormatter.m
//  XWCallKiter
//
//  Created by vivi wu on 2017/7/22.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "CallDurationFormatter.h"

@interface CallDurationFormatter ()
@property (nonatomic, strong) NSDateComponentsFormatter * dateFormatter;
@end

@implementation CallDurationFormatter
@synthesize dateFormatter;

- (instancetype)init{
    self = [super init];
    if (self) {
        dateFormatter = [NSDateComponentsFormatter new];
        dateFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
        dateFormatter.allowedUnits = NSCalendarUnitMinute|NSCalendarUnitSecond;
        dateFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    }
    return self;
}

- (NSString *)formatStringForDateComponents:(NSDateComponents *)dateComponents{
    return [dateFormatter stringFromDateComponents:dateComponents];
}

- (NSString *)formatStringForTimeInterval:(NSTimeInterval)timeInterval{
    return [dateFormatter stringFromTimeInterval:timeInterval];
}

@end
