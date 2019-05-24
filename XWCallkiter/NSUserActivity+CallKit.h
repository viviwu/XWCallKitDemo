//
//  NSUserActivity+CallKit.h
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/23.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserActivity (CallKit)
//@property(nonatomic, copy) NSString* startCallHandle;
//@property(nonatomic, assign) BOOL video;

-(NSString*)startCallHandle;
-(BOOL)video;

@end

NS_ASSUME_NONNULL_END
