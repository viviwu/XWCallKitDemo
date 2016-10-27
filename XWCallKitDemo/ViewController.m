//
//  ViewController.m
//  XWCallKitDemo
//
//  Created by viviwu on 16/10/6.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "ViewController.h"
#import "XWCallKitCenter.h"

@interface ViewController ()
{
    XWCallKitCenter * callCenter;
}
@property (strong, nonatomic) IBOutlet UITextField *NumberTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    callCenter=[XWCallKitCenter sharedInstance];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)SimulateIncomingCallWithCallKit:(id)sender {
    [self.view endEditing:YES];
    NSString * number = _NumberTF.text;
    if (_NumberTF.text == nil )  number = @"10086";
    if (!callCenter) {
        callCenter=[XWCallKitCenter sharedInstance];
    }
 
    XWContact * contact = [[XWContact alloc]init];
    contact.phoneNumber= number;
    contact.displayName=@"vivi wu";
    contact.uniqueIdentifier=@"";
    
    UIBackgroundTaskIdentifier backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSUUID * callUUID=[[XWCallKitCenter sharedInstance] reportIncomingCallWithContact:contact completion:^(NSError * _Nullable error)
        {
            if (error == nil) {
                NSLog(@"%s success", __func__);
//                XWCall *call = [[XWCall alloc] initWithUUID:uuid];
//                call.handle = handle;
//                //            [weakSelf.callManager addCall:call];
//                [[XWCallManager sharedManager] addCall:call];
            }else{
                NSLog(@"arror %@", error);
            }
        }];
        NSLog(@"callUUID==%@", callUUID);
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
    });
    
}

- (IBAction)endCall:(id)sender {
    [self.view endEditing:YES];
    NSUUID * callUUID=callCenter.currentCallUUID;
    
    [callCenter endCall:callUUID completion:^(NSError * _Nullable error){
        if (nil==error) {
            NSLog(@"%s success", __func__);
        }else{
            NSLog(@"arror %@", error);
        }
    }];
//    CXEndCallAction* endCallAction=[[CXEndCallAction alloc]initWithCallUUID:callUUID];
//    CXTransaction* transaction=[[CXTransaction alloc]init];
//    [transaction addAction:endCallAction];
//    [callCenter requestTransaction:transaction];
}

- (IBAction)makeOutgoingVoipCall:(id)sender {
    [self.view endEditing:YES];
    //想真正呼出外呼电话 工程需要工程支持VoIP功能咯
    //CallKit本身并不具备VoIP功能 明白了吗？
    
}


- (IBAction)endAllEditAction:(id)sender {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
