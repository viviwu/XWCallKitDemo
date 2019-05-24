//
//  SimulateIncomingCallViewController.h
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/22.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimulateIncomingCallViewController : UIViewController

@property(nonatomic, copy) NSString * handle;
@property(nonatomic, assign) BOOL video;
@property(nonatomic, assign) NSTimeInterval delay;

@property(nonatomic, weak) IBOutlet UITextField * destinationTextField;
@property(nonatomic, weak) IBOutlet UIBarButtonItem * doneButton;
@property(nonatomic, weak) IBOutlet UISwitch * videoSwitch;
@property(nonatomic, weak) IBOutlet UILabel * videoSwitchLabel;
@property(nonatomic, weak) IBOutlet UIStepper * delayStepper;
@property(nonatomic, weak) IBOutlet UILabel * delayStepperLabel;
@property(nonatomic, weak) IBOutlet UILabel * delayExplanationLabel;

@end

NS_ASSUME_NONNULL_END
