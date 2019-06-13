//
//  NSURL+CallKit.m
//  XWCallKiter
//
//  Created by vivi wu on 2017/5/23.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "NSURL+CallKit.h"

@implementation NSURL (CallKit)
static NSString *const URLScheme = @"callkiter";

-(NSString*)startCallHandle{
    if ([self.scheme  isEqual: URLScheme]) {
        return self.host;
    }else
        return nil;
}

@end
