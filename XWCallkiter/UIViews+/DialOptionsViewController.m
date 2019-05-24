//
//  DialOptionsViewController.m
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/22.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "DialOptionsViewController.h"

static NSString * OutgoingCallHandleKey = @"OutgoingCallHandleKey";
static NSString * OutgoingCallVideoCallKey = @"OutgoingCallVideoCallKey";

@interface DialOptionsViewController ()<UITextFieldDelegate>

@end

@implementation DialOptionsViewController

- (NSString *)handle
{
    return _destinationTextField.text;
}

- (BOOL)video
{
    return _videoSwitch.isOn;
}

#pragma mark - Actions
- (IBAction)cancel:(UIBarButtonItem *)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark --Helpers
- (void)updateDialButton{
    if (!self.handle) {
        _dialButton.enabled = false;
    }
    _dialButton.enabled = !(nil == self.handle);
}

- (void)restoreValues{
    _destinationTextField.text = [NSUserDefaults.standardUserDefaults valueForKey:OutgoingCallHandleKey];
    _videoSwitch.on =[NSUserDefaults.standardUserDefaults boolForKey:OutgoingCallVideoCallKey];
    [self updateDialButton];
}

- (void)saveValues{
    [NSUserDefaults.standardUserDefaults setObject:_destinationTextField.text forKey:OutgoingCallHandleKey];
    [NSUserDefaults.standardUserDefaults setBool:_videoSwitch.on forKey:OutgoingCallVideoCallKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.prompt = NSLocalizedString(@"DIAL_OPTIONS_NAVIGATION_PROMPT", comment: @"Navigation item prompt for Dial options UI");
    _videoSwitchLabel.text = NSLocalizedString(@"CALL_VIDEO_SWITCH_LABEL", comment: @"Label for simulating outgoing video call switch");
    [self updateDialButton];
    [_destinationTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_destinationTextField becomeFirstResponder];
    [self restoreValues];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveValues];
}

- (void)textFieldDidChange:(UITextField *)textField{
    [self updateDialButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
