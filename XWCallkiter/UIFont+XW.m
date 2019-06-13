//
//  UIFont+XW.m
//  XWCallKiter
//
//  Created by vivi wu on 2017/7/22.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "UIFont+XW.h"

@import CoreText;

@implementation UIFont (XWCallkiter)

- (UIFont *)addingMonospacedNumberAttributes
{
//    UIFontDescriptor * fontDescriptor = self.fontDescriptor;
    [self.fontDescriptor fontDescriptorByAddingAttributes: @{ UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),  UIFontFeatureTypeIdentifierKey: @(kMonospacedNumbersSelector)}];
    return [UIFont fontWithDescriptor:self.fontDescriptor size:self.pointSize];
}

@end
