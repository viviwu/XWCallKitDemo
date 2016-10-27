//
//  XWCallKitCenter.m
//  XWCallKitDemo
//
//  Created by viviwu on 16/10/6.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "XWCallKitCenter.h"
#import <Intents/Intents.h>
#import <UIKit/UIKit.h>
#import "CallAudio.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CXTransaction (XWExt)

+ (CXTransaction *)transactionWithActions:(NSArray <CXAction *> *)actions {
    CXTransaction *transcation = [[CXTransaction alloc] init];
    for (CXAction *action in actions) {
        [transcation addAction:action];
    }
    return transcation;
}

@end

//=========================================
@implementation XWContact
 
@end
//=========================================

@interface XWCallKitCenter() <CXProviderDelegate>

@property (nonatomic, strong) CXCallController *callController;
@property (nonatomic, copy) XWCallKitActionNotificationBlock actionNotificationBlock;
@end

@implementation XWCallKitCenter

//static const NSInteger XWDefaultMaximumCallsPerCallGroup = 1;
//static const NSInteger XWDefaultMaximumCallGroups = 1;

+ (XWCallKitCenter *)sharedInstance {
    static XWCallKitCenter *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[super allocWithZone:nil] init];
    });
    return instance;
}

#pragma mark--providerConfiguration

- (void)configurationCallProvider{
    
    NSString *localizedName = @"XWCall";    //本地显示的应用名字
    CXProviderConfiguration *configuration = [[CXProviderConfiguration alloc] initWithLocalizedName:localizedName];
    configuration.supportsVideo = NO;
    configuration.maximumCallsPerCallGroup = 1;
    configuration.supportedHandleTypes = [NSSet setWithObjects:[NSNumber numberWithInteger:CXHandleTypePhoneNumber], nil];
    configuration.iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:@"logo.png"]);
//    configuration.ringtoneSound = @"hold.wav";//如果没有音频文件 就用系统的
    self.provider = [[CXProvider alloc] initWithConfiguration:configuration];
    [self.provider setDelegate:self queue:self.completionQueue ? self.completionQueue : dispatch_get_main_queue()];
#if 0
    if (CXProvider.authorizationStatus == CXAuthorizationStatusNotDetermined) {
        [self.provider requestAuthorization];
    }
#endif
    self.callController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
}

- (void)setCompletionQueue:(dispatch_queue_t)completionQueue {
    _completionQueue = completionQueue;
    if (self.provider) {
        [self.provider setDelegate:self queue:_completionQueue];
    }
}

//让系统来接管播报一个新的来电,CallKit
- (NSUUID *)reportIncomingCallWithContact:(XWContact *)contact completion:(XWCallKitCenterCompletion)completion
{
    NSString * number = contact.phoneNumber;
    CXHandle* handle=[[CXHandle alloc]initWithType:CXHandleTypePhoneNumber value:number];
    NSUUID *callUUID = [NSUUID UUID];
    _currentCallUUID=callUUID;
    
    CXCallUpdate *callUpdate = [[CXCallUpdate alloc] init];
    callUpdate.remoteHandle = handle;
    callUpdate.localizedCallerName = contact.displayName;
    [self.provider reportNewIncomingCallWithUUID:callUUID update:callUpdate completion:completion];
    
    [self.provider reportCallWithUUID:_currentCallUUID updated:callUpdate];
    
    return callUUID;
}


- (NSUUID *)reportOutgoingCall:(NSUUID *)callUUID startedConnectingAtDate:(NSDate*)startDate
{
    _currentCallUUID=callUUID;
    [self.provider reportOutgoingCallWithUUID:callUUID startedConnectingAtDate:startDate];
    return callUUID;
}

//-(void)performStartCallAction
- (void)mute:(BOOL)mute callUUID:(NSUUID *)callUUID completion:(XWCallKitCenterCompletion)completion
{
    CXSetMutedCallAction *action = [[CXSetMutedCallAction alloc] initWithCallUUID:callUUID muted:mute];
    //    action.muted = mute;
    
    [self.callController requestTransaction:[CXTransaction transactionWithActions:@[action]] completion:completion];
}

- (void)hold:(BOOL)hold callUUID:(NSUUID *)callUUID completion:(XWCallKitCenterCompletion)completion
{
    CXSetHeldCallAction *action = [[CXSetHeldCallAction alloc] initWithCallUUID: callUUID onHold: hold];
    //    action.onHold = hold;
    [self.callController requestTransaction:[CXTransaction transactionWithActions:@[action]] completion:completion];
}

- (void)endCall:(NSUUID *)callUUID completion:(XWCallKitCenterCompletion)completion {
    CXEndCallAction *action = [[CXEndCallAction alloc] initWithCallUUID:callUUID];
    
    [self.callController requestTransaction:[CXTransaction transactionWithActions:@[action]] completion:completion];
}
//DTMF
- (void)provider:(CXProvider *)provider performPlayDTMFCallAction:(CXPlayDTMFCallAction *)action{
    NSLog(@"%s", __func__);
    
    //    if (call == nil) {
    //        [action fail];
    //    }else{
    //        if (action.digits) {
    //            NSLog(@"action.digits : %@", action.digits);
    //            [call digitsForDTMF:action.digits];
    //        }
    //        [action fulfill];
    //    }
}

//timeout to end
- (void)provider:(CXProvider *)provider timedOutPerformingAction:(CXAction *)action{
    NSLog(@"%s", __func__);
    /// Called when an action was not performed in time and has been inherently failed. Depending on the action, this timeout may also force the call to end. An action that has already timed out should not be fulfilled or failed by the provider delegate
}
//group
- (void)provider:(CXProvider *)provider performSetGroupCallAction:(CXSetGroupCallAction *)action{
    NSLog(@"%s", __func__);
}

//无论何种操作都需要 话务控制器 去 提交请求 给系统
-(void)requestTransaction:(CXTransaction *)transaction
{
    //    [_callController requestTransaction:transaction completion:completion];
    [_callController requestTransaction:transaction completion:^( NSError *_Nullable error){
        if (error !=nil) {
            NSLog(@"Error requesting transaction: %@", error);
        }else{
            NSLog(@"Requested transaction successfully");
        }
    }];
}


//- (NSUUID *)reportOutgoingCallWithContact:(XWContact *)contact completion:(XWCallKitCenterCompletion)completion
//{
//    CXHandle* handle=[[CXHandle alloc]initWithType:CXHandleTypePhoneNumber value:contact.phoneNumber];
//    _callUUID = [NSUUID UUID];
//    CXStartCallAction *action = [[CXStartCallAction alloc] initWithCallUUID:_callUUID handle: handle];
//    action.contactIdentifier = [contact uniqueIdentifier];
//    
//    CXTransaction * transaction = [CXTransaction transactionWithActions:@[action]];
//    
//    [self requestTransaction:transaction];
//    return _callUUID;
//}

- (void)updateCall:(NSUUID *)callUUID state:(XWCallState)state
{
    switch (state) {
        case XWCallStateConnecting:
            [self.provider reportOutgoingCallWithUUID:callUUID startedConnectingAtDate:nil];
            break;
        case XWCallStateConnected:
            [self.provider reportOutgoingCallWithUUID:callUUID connectedAtDate:nil];
            break;
        case XWCallStateEnded:
            [self.provider reportCallWithUUID:callUUID endedAtDate:nil reason:CXCallEndedReasonRemoteEnded];
            break;
        case XWCallStateEndedWithFailure:
            [self.provider reportCallWithUUID:callUUID endedAtDate:nil reason:CXCallEndedReasonFailed];
            break;
        case XWCallStateEndedUnanswered:
            [self.provider reportCallWithUUID:callUUID endedAtDate:nil reason:CXCallEndedReasonUnanswered];
            break;
        default:
            break;
    }
}

/*
- (NSUUID *)reportOutgoingCallWithContact:(XWContact *)contact completion:(XWCallKitCenterCompletion)completion
{
    NSString * number = contact.phoneNumber;
    CXHandle* handle=[[CXHandle alloc]initWithType:CXHandleTypePhoneNumber value:number];
    NSUUID *callUUID = [NSUUID UUID];
    CXStartCallAction *action = [[CXStartCallAction alloc] initWithCallUUID:callUUID handle: handle];
    action.contactIdentifier = contact.uniqueIdentifier;
    
    
    [self.callController requestTransaction:[CXTransaction transactionWithActions:@[action]] completion:completion];
    return callUUID;
}
*/

#pragma mark - CXProviderDelegate
- (void)providerDidReset:(CXProvider *)provider{
    NSLog(@"%s", __func__);
    CallAudio *audio = [CallAudio sharedCallAudio];
    [audio stopAudio];
}

- (void)provider:(CXProvider *)provider performAnswerCallAction:(nonnull CXAnswerCallAction *)action {
    NSLog(@"%s", __func__);
    if (self.actionNotificationBlock) {
        self.actionNotificationBlock(action, XWCallActionTypeAnswer);
    }
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performEndCallAction:(nonnull CXEndCallAction *)action {
    NSLog(@"%s", __func__);
    if (self.actionNotificationBlock) {
        self.actionNotificationBlock(action, XWCallActionTypeEnd);
    }
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performStartCallAction:(nonnull CXStartCallAction *)action {
    NSLog(@"%s", __func__);
    if (self.actionNotificationBlock) {
        self.actionNotificationBlock(action, XWCallActionTypeStart);
    } //destination
    if (action.handle.value) {
        [action fulfill];
    } else {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider performSetMutedCallAction:(nonnull CXSetMutedCallAction *)action {
    NSLog(@"%s", __func__);
    if (self.actionNotificationBlock) {
        self.actionNotificationBlock(action, XWCallActionTypeMute);
    }
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performSetHeldCallAction:(nonnull CXSetHeldCallAction *)action {
    NSLog(@"%s", __func__);
    if (self.actionNotificationBlock) {
        self.actionNotificationBlock(action, XWCallActionTypeHeld);
    }
    [action fulfill];
}
@end

NS_ASSUME_NONNULL_END
