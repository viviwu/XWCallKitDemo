//
//  CallAudio.m
//  XWPhone
//
//  Created by viviwu on 16/9/27.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "CallAudio.h"

@interface CallAudio ()
@property(nonatomic, strong)AudioController * audioController;
@end

static CallAudio *_audio = nil;
@implementation CallAudio

+ (instancetype)sharedCallAudio{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _audio = [[CallAudio alloc] init];
    });
    return _audio;
}

- (void)configureAudioSession{
    NSLog(@"Configuring audio session");
    if (_audioController == nil) {
        _audioController = [[AudioController alloc] init];
    }
}

- (void)startAudio{
    NSLog(@"Starting audio");
    
    if ([_audioController startIOUnit] == kAudioServicesNoError) {
        [_audioController setMuteAudio:NO];
    } else {
        // handle error
    }
}

- (void)stopAudio{
    NSLog(@"Stopping audio");
    
    if ([_audioController stopIOUnit] == kAudioServicesNoError) {
        // handle error
    }
}


@end
