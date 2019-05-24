//
//  XWCallKiterCall.h
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/22.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Callback)(void);
typedef void(^ActionHandler)(BOOL);

NS_ASSUME_NONNULL_BEGIN

@interface XWCall : NSObject

// MARK: Metadata Properties
@property (nonatomic, copy) NSUUID *  uuid;
@property (nonatomic, assign) BOOL    isOutgoing;
@property (nonatomic, copy) NSString *handle;

 // MARK: Call State Properties
@property (nonatomic, copy) NSDate *  connectingDate;
@property (nonatomic, copy) NSDate *  connectDate;
@property (nonatomic, copy) NSDate *  endDate;

@property (nonatomic, assign) BOOL    isOnHold;

// MARK: State change callback blocks
@property (nonatomic, copy) Callback stateDidChange;
@property (nonatomic, copy) Callback hasStartedConnectingDidChange;
@property (nonatomic, copy) Callback hasConnectedDidChange;
@property (nonatomic, copy) Callback hasEndedDidChange;

// MARK: Derived Properties
@property (nonatomic, assign) BOOL     hasStartedConnecting;
@property (nonatomic, assign) BOOL     hasConnected;
@property (nonatomic, assign) BOOL     hasEnded;
@property (nonatomic, assign) NSTimeInterval duration;

// MARK: Initialization
- (instancetype)initWithUUID:(NSUUID*)uuid isOutgoing:(BOOL)isOutgoing;

// MARK: Actions
- (void)startXWCall:(ActionHandler)completion;
- (void)answerCall;
- (void)endCall;

@end

NS_ASSUME_NONNULL_END
