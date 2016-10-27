//
//  NSURL+XWStartCallConvertible.m
//  XWPhone
//
//  Created by viviwu on 16/9/22.
//  Copyright © 2014年 viviwu. All rights reserved.
//

#import "NSURL+XWStartCallConvertible.h"


@implementation NSURL (XWStartCallConvertible)

-(NSString*)startCallHandle
{
    NSString * callHandle=URLScheme;
    if (nil==callHandle) {
        callHandle=self.host;
    }
    return callHandle;
}
@end
