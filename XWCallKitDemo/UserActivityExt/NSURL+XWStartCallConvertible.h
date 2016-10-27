//
//  NSURL+XWStartCallConvertible.h
//  XWPhone
//
//  Created by viviwu on 16/9/22.
//  Copyright © 2014年 viviwu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URLScheme @"XWPhone"
@interface NSURL (XWStartCallConvertible)

//@property(nonatomic, copy, readonly)NSString * startCallHandle;
-(NSString*)startCallHandle;

@end
