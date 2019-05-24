//
//  ProviderDelegate.h
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/22.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWCallManager.h"

@import CallKit;
@import PushKit;

typedef void(^ErrorHandler)(NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface ProviderDelegate : NSObject<CXProviderDelegate>

@property (strong, nonatomic) XWCallManager * callManager;

- (instancetype)initWithCallManager:(XWCallManager *)callManager;

- (void)reportIncomingCall:(NSUUID *)uuid
                    handle:(NSString *)handle
                  hasVideo:(BOOL)hasVideo
                completion:(ErrorHandler)completion;

@end

NS_ASSUME_NONNULL_END
