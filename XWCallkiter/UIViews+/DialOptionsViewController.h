//
//  DialOptionsViewController.h
//  XWCallKiter
//
//  Created by vivi wu on 2017/7/22.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialOptionsViewController : UIViewController

@property(nonatomic, copy) NSString * handle;
@property(nonatomic, assign) BOOL video;

@property(nonatomic, weak) IBOutlet UITextField * destinationTextField;
@property(nonatomic, weak) IBOutlet UIBarButtonItem * dialButton;
@property(nonatomic, weak) IBOutlet UISwitch * videoSwitch;
@property(nonatomic, weak) IBOutlet UILabel * videoSwitchLabel;

@end

NS_ASSUME_NONNULL_END
