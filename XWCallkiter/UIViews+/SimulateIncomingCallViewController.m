//
//  SimulateIncomingCallViewController.m
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/22.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "SimulateIncomingCallViewController.h"

static NSString * IncomingCallDelayInSecondsKey = @"IncomingCallDelayInSecondsKey";
static NSString * IncomingCallHandleKey = @"IncomingCallHandleKey";
static NSString * IncomingCallVideoCallKey = @"IncomingCallVideoCallKey";

@interface SimulateIncomingCallViewController ()
@property(nonatomic, copy) NSString * delayLabelTextFormat;
@end

@implementation SimulateIncomingCallViewController

@synthesize handle;
@synthesize video;
@synthesize delay;

@synthesize destinationTextField;
@synthesize doneButton;
@synthesize videoSwitch;
@synthesize videoSwitchLabel;
@synthesize delayStepper;
@synthesize delayStepperLabel;
@synthesize delayExplanationLabel;

@synthesize delayLabelTextFormat;

- (NSString *)handle{
    return destinationTextField.text;
}
- (NSTimeInterval)delay{
    return delayStepper.value;
}
- (BOOL) video {
    return videoSwitch.isOn;
}

#pragma mark --Actions
- (IBAction)cancel:(UIBarButtonItem *)cancel {
//    dismiss(animated: true, completion: nil)
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --Helpers
- (void)updateDialButton
{
    if (!self.handle) {
        doneButton.enabled = NO;
    }
    doneButton.enabled = !(nil == self.handle);
}

- (void)updateDelayStepperLabelText
{
    double delayInSeconds = delayStepper.value;
    NSString * delayLabelText = [NSString stringWithFormat: delayLabelTextFormat, delayInSeconds];
    delayStepperLabel.text = delayLabelText;
}

- (void)restoreValues{
    destinationTextField.text = [NSUserDefaults.standardUserDefaults valueForKey:IncomingCallHandleKey];
    videoSwitch.on =[NSUserDefaults.standardUserDefaults boolForKey:IncomingCallVideoCallKey];
    delayStepper.value = [NSUserDefaults.standardUserDefaults doubleForKey:IncomingCallDelayInSecondsKey];
    [self updateDialButton];
}

- (void)saveValues{
    [NSUserDefaults.standardUserDefaults setObject:destinationTextField.text forKey:IncomingCallHandleKey];
    [NSUserDefaults.standardUserDefaults setBool:videoSwitch.on forKey:IncomingCallVideoCallKey];
    [NSUserDefaults.standardUserDefaults setDouble:delayStepper.value forKey:IncomingCallDelayInSecondsKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)textFieldDidChange:(UITextField *)textField{
    [self updateDialButton];
}

- (IBAction)stepperValueChanged:(id)sender {
    [self updateDelayStepperLabelText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.prompt = NSLocalizedString(@"SIMULATE_INCOMING_CALL_NAVIGATION_PROMPT", comment: @"Navigation item prompt for Incoming call options UI");
    videoSwitchLabel.text = NSLocalizedString(@"CALL_VIDEO_SWITCH_LABEL", comment: @"Label for simulating incoming video call switch");
    delayExplanationLabel.text = NSLocalizedString(@"DELAY_EXPLANATION_LABEL", comment: @"Label for explaining delay stepper usage");
    [destinationTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // Do any additional setup after loading the view.
    delayLabelTextFormat = NSLocalizedString(@"CALL_DELAY_STEPPER_LABEL", comment: @"Label for simulating delayed incoming call switch");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [destinationTextField becomeFirstResponder];
    [self restoreValues];
    [self updateDelayStepperLabelText];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveValues];
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
