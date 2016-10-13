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

- (IBAction)makeCall:(id)sender {
    if (_NumberTF.text == nil ) {
        return;
    }
    if (!callCenter) {
        callCenter=[XWCallKitCenter sharedInstance];
    }
    
#if 01
    XWContact * contact = [[XWContact alloc]init];
    contact.phoneNumber= _NumberTF.text;
    contact.displayName=@"VIVI";
    contact.uniqueIdentifier=@"";
    
    UIBackgroundTaskIdentifier backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUUID * callUUID=[[XWCallKitCenter sharedInstance] reportIncomingCallWithContact:contact completion:^(NSError * _Nullable error)
                           {
                               if (error == nil) {
                                   
                               }else{
                                   NSLog(@"arror %@", error);
                               } 
                           }];
        NSLog(@"callUUID==%@", callUUID);
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
    });
#endif
    
}

- (IBAction)endCall:(id)sender {
    
    NSUUID * callUUID=callCenter.callUUID;
    CXEndCallAction* endCallAction=[[CXEndCallAction alloc]initWithCallUUID:callUUID];
    CXTransaction* transaction=[[CXTransaction alloc]init];
    [transaction addAction:endCallAction];
    
    [callCenter requestTransaction:transaction];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
