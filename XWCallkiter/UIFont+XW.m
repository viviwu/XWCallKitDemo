//
//  UIFont+XW.m
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/22.
//  Copyright © 2019 vivi wu. All rights reserved.
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
