//
//  XWCallManager.h
//  XWCallKiter
//
//  Created by vivi wu on 2017/7/22.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CallKit;
@import UIKit;
#import "XWCall.h"

extern NSString * _Nullable const kCallsChangedNotification;
NS_ASSUME_NONNULL_BEGIN

@interface XWCallManager : NSObject

@property(nonatomic, strong) CXCallController * callController;
@property(nonatomic, strong) NSMutableArray<XWCall *>* calls;

- (void)startCallHandle:(NSString *)handle video:(BOOL)video;
- (void)endCall:(XWCall *)call;
- (void)setHeldCall:(XWCall *)call onHold:(BOOL)onHold;

- (XWCall *)callWithUUID:(NSUUID *)uuid;
- (void)addCall:(XWCall *)call;
- (void)removeCall:(XWCall *)call;
- (void)removeAllCalls;

@end

NS_ASSUME_NONNULL_END
