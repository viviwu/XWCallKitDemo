//
//  XWCallManager.m
//  XWCallKiter
//
//  Created by vivi wu on 2017/7/22.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "XWCallManager.h"

NSString * const kCallsChangedNotification = @"CallManagerkCallsChangedNotification";

@interface XWCallManager ()
 
@end

@implementation XWCallManager

@synthesize callController;

- (instancetype)init{
    self = [super init];
    if (self) {
        callController = [[CXCallController alloc]initWithQueue:dispatch_get_main_queue()];
        _calls = [NSMutableArray array];
    }
    return self;
}

- (void)startCallHandle:(NSString *)number video:(BOOL)video
{
    CXHandle * handle = [[CXHandle alloc]initWithType:CXHandleTypePhoneNumber value:number];
    CXStartCallAction * startCallAction = [[CXStartCallAction alloc]initWithCallUUID:NSUUID.UUID handle:handle];
    startCallAction.video = video;
    
    CXTransaction * transaction = CXTransaction.new;
    [transaction addAction:startCallAction];
    
    [self requestTransaction:transaction];
}

- (void)endCall:(XWCall *)call
{
    CXEndCallAction * endCallAction = [[CXEndCallAction alloc] initWithCallUUID: call.uuid];
    CXTransaction * transaction = [[CXTransaction alloc] initWithAction: endCallAction ];
    [self requestTransaction:transaction];
}

- (void)setHeldCall:(XWCall *)call onHold:(BOOL)onHold
{
    CXSetHeldCallAction * setHeldCallAction = [[CXSetHeldCallAction alloc] initWithCallUUID:call.uuid onHold:onHold];
    CXTransaction * transaction = CXTransaction.new;
    [transaction addAction:setHeldCallAction];
    
    [self requestTransaction:transaction];
}

//private:
- (void)requestTransaction:(CXTransaction *)transaction{
    if (!callController) {
        NSLog(@"callController : %@", callController);
    }
    [callController requestTransaction:transaction completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error requesting transaction: %@", error);
        }else{
            NSLog(@"Requested transaction successfully");
        }
    }];
}

- (XWCall *)callWithUUID:(NSUUID *)uuid
{
    XWCall * ret_call = nil;
    for (XWCall * call in _calls) {
        if ([call.uuid isEqual:uuid]) {
            ret_call = call;
        }
    }
    return ret_call;
}

- (void)addCall:(XWCall *)call
{
    [_calls addObject:call];
    __weak typeof(self) weakSelf= self;
    call.stateDidChange = ^{
        [weakSelf postkCallsChangedNotification];
    };
    [self postkCallsChangedNotification];
}

- (void)removeCall:(XWCall *)call
{ 
    [_calls removeObject:call];
    [self postkCallsChangedNotification];
}

- (void)removeAllCalls{
    [_calls removeAllObjects];
    [self postkCallsChangedNotification];
}

- (void)postkCallsChangedNotification
{
    [NSNotificationCenter.defaultCenter postNotificationName:kCallsChangedNotification object:self];
}

// MARK: XWCallDelegate
- (void)callDidChangeState:(XWCall *)call
{
    [self postkCallsChangedNotification];
}

@end
