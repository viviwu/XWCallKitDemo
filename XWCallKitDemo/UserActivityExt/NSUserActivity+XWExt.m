//
//  NSUserActivity+XWExt.m
//  XWPhone
//
//  Created by viviwu on 16/9/21.
//  Copyright © 2014年 viviwu. All rights reserved.
//

#import "NSUserActivity+XWExt.h"
#import <Intents/Intents.h>
#import <objc/runtime.h>

@implementation NSUserActivity (XWExt)

static const void * startCallHandleKey = &startCallHandleKey;
static const void * videoKey = &videoKey;
-(void)setVideo:(BOOL)video
{
    //    video=video;
    objc_setAssociatedObject(self, videoKey, [NSNumber numberWithBool:video], OBJC_ASSOCIATION_COPY);
}

-(void)setStartCallHandle:(NSString *)startCallHandle
{
    //    startCallHandle = startCallHandle;
    objc_setAssociatedObject(self, startCallHandleKey, startCallHandle, OBJC_ASSOCIATION_COPY);
}

-(NSString*)startCallHandle
{
    INInteraction  *interaction = self.interaction;
    if (!interaction)  return nil;
    INIntent * startCallIntent = interaction.intent;
    if (!startCallIntent) return nil;
    INPerson* contact = nil;
    if ([startCallIntent isKindOfClass:[INStartAudioCallIntent class]]) {
        contact = ((INStartAudioCallIntent*)startCallIntent).contacts.firstObject;
    }else if([startCallIntent isKindOfClass:[INStartVideoCallIntent class]]){
        contact = ((INStartVideoCallIntent*)startCallIntent).contacts.firstObject;
    }else if([startCallIntent isKindOfClass:[INSendMessageIntent class]]){
        contact = ((INSendMessageIntent*)startCallIntent).recipients.firstObject;
    }else{ }
    
    if (contact) {
        return contact.personHandle.value;
    }else
        return nil;
    return objc_getAssociatedObject(self, startCallHandleKey);
}

-(BOOL)video
{
    INInteraction * interaction=self.interaction;
    INIntent * startCallIntent = interaction.intent;
    if (interaction && startCallIntent) {
        return [startCallIntent isKindOfClass: [INStartVideoCallIntent class]];
    }else
        return nil;
    return [objc_getAssociatedObject(self, videoKey) boolValue];
}




@end
