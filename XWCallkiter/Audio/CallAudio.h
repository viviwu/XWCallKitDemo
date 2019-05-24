//
//  CallAudio.h
//  XWPhone
//
//  Created by viviwu on 16/9/27.
//  Copyright © 2016年 viviwu. All rights reserved.
//
//Abstract:
//High-level call audio management functions

#import <Foundation/Foundation.h>
#import "AudioController.h"

@interface CallAudio : NSObject

+ (instancetype)sharedCallAudio;
- (void)configureAudioSession;
- (void)startAudio;
- (void)stopAudio;

@end
