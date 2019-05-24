//
//  XWCallKiterCall.m
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/22.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "XWCall.h"


@implementation XWCall

@synthesize hasStartedConnecting = _hasStartedConnecting;
@synthesize hasConnected = _hasConnected;
@synthesize hasEnded = _hasEnded;
#pragma mark -- Initialization
- (instancetype)initWithUUID:(NSUUID*)uuid
                  isOutgoing:(BOOL)isOutgoing
{
    self = [super init];
    if (self) {
        _uuid = uuid;
        _isOutgoing = isOutgoing;
    }
    return self;
}

- (void)setConnectingDate:(NSDate *)connectingDate
{
    _connectingDate = connectingDate;
    self.stateDidChange();
    self.hasStartedConnectingDidChange();
}

- (void)setConnectDate:(NSDate *)connectDate
{
    _connectDate = connectDate;
    if(self.stateDidChange) self.stateDidChange();
    if(self.hasConnectedDidChange) self.hasConnectedDidChange();
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    if(self.stateDidChange) self.stateDidChange();
    if(self.hasEndedDidChange) self.hasEndedDidChange();
}

- (void)setIsOnHold:(BOOL)isOnHold
{
    _isOnHold = isOnHold;
    if(self.stateDidChange) self.stateDidChange();
}

- (BOOL)hasStartedConnecting{
    _hasStartedConnecting = self.connectingDate != nil;
    return _hasStartedConnecting;
}

- (void)setHasStartedConnecting:(BOOL)hasStartedConnecting
{
    _hasStartedConnecting = hasStartedConnecting;
    if (!self.connectDate) {
        self.connectingDate = NSDate.date;
    }
}

- (void)setHasConnected:(BOOL)hasConnected
{
    _hasConnected = hasConnected;
    if (hasConnected)   _connectDate = NSDate.date;
}

- (BOOL)getHasConnected
{
    return _hasConnected = self.connectDate != nil;
}

- (void)setHasEnded:(BOOL)hasEnded
{
    _hasEnded = hasEnded;
    if (hasEnded) _endDate = NSDate.date;
}
-(BOOL)hasEnded
{
    return _hasEnded = self.endDate != nil;
}

- (NSTimeInterval)duration
{
    if (self.connectDate) {
        _duration = [NSDate.date timeIntervalSinceDate:self.connectDate];
        return _duration;
    }else
        return 0;
}

#pragma mark -- Actions
- (void)startXWCall:(ActionHandler)completion{
    // Simulate the call starting successfully
    completion(YES);
    /*
     Simulate the "started connecting" and "connected" states using artificial delays, since
     the example app is not backed by a real network service
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hasStartedConnecting = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hasConnected = YES;
        });
    });
}

- (void)answerCall{
    /*
     Simulate the answer becoming connected immediately, since
     the example app is not backed by a real network service
     */
    self.hasConnected = YES;
}

- (void)endCall{
    /*
     Simulate the end taking effect immediately, since
     the example app is not backed by a real network service
     */
    self.hasEnded = YES;
}

@end
