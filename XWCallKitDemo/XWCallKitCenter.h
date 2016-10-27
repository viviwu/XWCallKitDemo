//
//  XWCallKitCenter.h
//  XWCallKitDemo
//
//  Created by viviwu on 16/10/6.
//  Copyright © 2016年 viviwu. All rights reserved.
//  contact：286218985@qq.com；weibo：_viviwu_

#import <Foundation/Foundation.h>
#import <CallKit/CallKit.h>
 

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XWCallActionType) {
    XWCallActionTypeStart,
    XWCallActionTypeEnd,
    XWCallActionTypeAnswer,
    XWCallActionTypeMute,
    XWCallActionTypeHeld
};

typedef NS_ENUM(NSInteger, XWCallState) {
    XWCallStatePending,
    XWCallStateConnecting,
    XWCallStateConnected,
    XWCallStateEnded,
    XWCallStateEndedWithFailure,
    XWCallStateEndedUnanswered
};

typedef void(^XWCallKitCenterCompletion)(NSError * _Nullable error);
typedef void(^XWCallKitActionNotificationBlock)(CXCallAction * action, XWCallActionType actionType);

//=========================================

@interface XWContact : NSObject

@property(nonatomic, copy) NSString * uniqueIdentifier;
@property(nonatomic, copy) NSString * displayName;
@property(nonatomic, copy) NSString * phoneNumber;

@end

//=========================================


@interface XWCallKitCenter : NSObject

@property (nonatomic, strong) CXProvider *provider;
@property (nonatomic, strong) dispatch_queue_t completionQueue; // Default to mainQueue
@property (nonatomic, copy) NSUUID * currentCallUUID;

+ (XWCallKitCenter *)sharedInstance;

- (void)configurationCallProvider;

- (NSUUID *)reportIncomingCallWithContact:(XWContact *)contact completion:(XWCallKitCenterCompletion)completion;

//无论何种操作都需要 话务控制器 去 提交请求 给系统
-(void)requestTransaction:(CXTransaction *)transaction;

//- (NSUUID *)reportOutgoingCallWithContact:(XWContact *)contact completion:(XWCallKitCenterCompletion)completion;

- (void)updateCall:(NSUUID *)callUUID state:(XWCallState)state;

- (void)mute:(BOOL)mute callUUID:(NSUUID *)callUUID completion:(XWCallKitCenterCompletion)completion;
- (void)hold:(BOOL)hold callUUID:(NSUUID *)callUUID completion:(XWCallKitCenterCompletion)completion;
- (void)endCall:(NSUUID *)callUUID completion:(XWCallKitCenterCompletion)completion;

@end
NS_ASSUME_NONNULL_END
