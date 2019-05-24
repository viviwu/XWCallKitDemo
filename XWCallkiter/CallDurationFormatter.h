//
//  CallDurationFormatter.h
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/22.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CallDurationFormatter : NSObject

- (instancetype)init;

- (NSString *)formatStringForDateComponents:(NSDateComponents *)dateComponents;
- (NSString *)formatStringForTimeInterval:(NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END
