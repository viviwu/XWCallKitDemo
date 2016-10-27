//
//  AppDelegate.m
//  XWCallKitDemo
//
//  Created by viviwu on 16/10/6.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "AppDelegate.h"
#import "XWCallKitCenter.h"
#import <CallKit/CallKit.h>
#import "NSUserActivity+XWExt.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[XWCallKitCenter sharedInstance] configurationCallProvider];
    
    
    return YES;
}

- (void)openURL:(NSURL*)url options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion NS_AVAILABLE_IOS(10_0)
{
    
}

#pragma mark -- 系统电话回调到APP 发起语音请求
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler NS_AVAILABLE_IOS(8_0)
{
    NSLog(@"userActivity:%@", userActivity.description);
    //应该在这里发起实际VoIP呼叫
    
    NSString * handle =userActivity.startCallHandle;
    BOOL video = userActivity.video;
    XWContact * contact = [[XWContact alloc]init];
    contact.phoneNumber= handle;
    contact.displayName=@"vivi wu";
    contact.uniqueIdentifier=@"";
    
    if(nil == handle || NO == video){
        NSLog(@"Could not determine start call handle from user activity:%@", userActivity);
        return NO;
    }else{
        [[XWCallKitCenter sharedInstance]reportIncomingCallWithContact:contact completion:^(NSError * _Nullable error)
         {
             if (error == nil) {
                 NSLog(@"%s success", __func__);
             }else{
                 NSLog(@"arror %@", error);
             }
         }];
        return YES;
    }
    return NO;
}


//接收通过某种Activity调回来的操作：
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity{
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


#pragma mark--applicationDidEnterBackground
UIBackgroundTaskIdentifier backgroundTaskID;
- (void)applicationDidEnterBackground:(UIApplication *)application {
   /**
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        [self backgroundhandler];
    }];
    if (backgroundAccepted)
    {
        NSLog(@"backgrounding accepted");
    }
    */
    if (NO == [[UIDevice currentDevice] isMultitaskingSupported]){
        return;
    }
    [self backgroundhandler];
    //开启一个后台任务
    backgroundTaskID = [application beginBackgroundTaskWithExpirationHandler:^{
        
        if (backgroundTaskID != UIBackgroundTaskInvalid) {
            [application endBackgroundTask:backgroundTaskID];
            backgroundTaskID = UIBackgroundTaskInvalid;
        }
    }];
    
     
    
}

static BOOL inBackground=NO;
static NSInteger count=0;
-(void) backgroundhandler{
    NSLog(@"### -->backgroundinghandler");
    UIApplication*  app = [UIApplication sharedApplication];
    backgroundTaskID = [app beginBackgroundTaskWithExpirationHandler:^{
        if (backgroundTaskID != UIBackgroundTaskInvalid) {
            [app endBackgroundTask: backgroundTaskID];
            backgroundTaskID = UIBackgroundTaskInvalid;
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (inBackground) {
            NSLog(@"backgroundTimeRemain counter:%ld", (long)count++);
            NSLog(@"timer:%f", [app backgroundTimeRemaining]);
            sleep(1);
        }
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if (backgroundTaskID != UIBackgroundTaskInvalid){
        [application endBackgroundTask:backgroundTaskID];
        backgroundTaskID = UIBackgroundTaskInvalid;
    }
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

 

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
