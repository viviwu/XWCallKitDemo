//
//  AppDelegate.h
//  XWCallKiter
//
//  Created by vivi wu on 2017/7/22.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PushKit/PushKit.h>
#import "NSUserActivity+CallKit.h"
#import "NSURL+CallKit.h"
#import "ProviderDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PKPushRegistryDelegate>   //UNUserNotificationCenterDelegate

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) NSString* voipPushToken;
@property(nonatomic, strong) PKPushRegistry * pushRegistry;
@property(nonatomic, strong) XWCallManager *callManager;
@property(nonatomic, strong) ProviderDelegate * providerDelegate;

+ (instancetype)shared;

- (void)displayIncomingCall:(NSUUID *)uuid
                     handle:(NSString *)handle
                   hasVideo:(BOOL)hasVideo
                 completion:(ErrorHandler)completion;

@end

#define kUserDef [NSUserDefaults standardUserDefaults]
#define kUserDef_OBJ(s) [[NSUserDefaults standardUserDefaults] objectForKey:s]

#define kAppDel ((AppDelegate *)[UIApplication sharedApplication].delegate)

