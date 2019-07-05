//
//  CallsViewController.m
//  XWCallKiter
//
//  Created by vivi wu on 2017/5/23.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "CallsViewController.h"


@interface CallsViewController ()
@property(nonatomic, strong) XWCallManager * callManager;
@property(nonatomic, strong) NSTimer * callDurationTimer;
@property(nonatomic, strong) CallDurationFormatter * callDurationFormatter;
@end

@implementation CallsViewController

- (CallDurationFormatter * )callDurationFormatter
{
    if (!_callDurationFormatter) {
        _callDurationFormatter = [[CallDurationFormatter alloc]init];
    }
    return _callDurationFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _callManager = AppDelegate.shared.callManager;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleCallsChangedNotification:) name:kCallsChangedNotification object:nil];
    [self updateCallsDependentUI:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kCallsChangedNotification object:nil];
    if (_callDurationTimer) {
        [_callDurationTimer invalidate];
        _callDurationTimer = nil;
    }
}
#pragma makr -- CXCallObserverDelegate
- (void)handleCallsChangedNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
    [self updateCallsDependentUI:true];
}

- (IBAction)unwindForDialCallSegue:(UIStoryboardSegue *)segue {
    DialOptionsViewController * dialOptionsViewController = segue.sourceViewController;
    NSString * handle = dialOptionsViewController.handle;
    BOOL video = dialOptionsViewController.video;
    if (handle) {
        [_callManager startCallHandle:handle video:video];
    }
}

- (IBAction)unwindForSimulateIncomingCallSegue:(UIStoryboardSegue *)segue
{
    SimulateIncomingCallViewController * simulateIncomingCallViewController = segue.sourceViewController;
    NSString * handle = simulateIncomingCallViewController.handle;
    BOOL video = simulateIncomingCallViewController.video;
    NSTimeInterval delay = simulateIncomingCallViewController.delay;
    /*
     Since the app may be suspended while waiting for the delayed action to begin,
     start a background task.
     */
    UIBackgroundTaskIdentifier  backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"backgroundTask: %s", __func__);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [AppDelegate.shared displayIncomingCall: NSUUID.UUID handle:handle hasVideo:video completion:^(NSError * _Nullable error) {
            [[UIApplication sharedApplication] endBackgroundTask: backgroundTaskIdentifier];
        }];
    }); 
}

- (void)updateCallsDependentUI:(BOOL)animated
{
    [self updateCallDurationTimer];
}

- (XWCall *)callAt:(NSIndexPath *)indexPath
{
//    NSAssert(indexPath.row < _callManager.calls.count, @"错误提示");
    if (indexPath.row >= _callManager.calls.count) {
        return nil;
    }
    return _callManager.calls[indexPath.row];
}

#pragma mark - Call Duration Timer
- (void)updateCallDurationTimer
{
    NSUInteger callCount = _callManager.calls.count;
    if (callCount > 0 && _callDurationTimer == nil) {
        
        _callDurationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(callDurationTimerFired) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_callDurationTimer forMode:NSRunLoopCommonModes];
    }else if (callCount == 0 && _callDurationTimer != nil){
        [_callDurationTimer invalidate];
        _callDurationTimer = nil;
    }
}

- (void)callDurationTimerFired
{
    [self updateCallDurationForVisibleCells];
}

- (void)updateCallDurationForVisibleCells
{
    /*
     Modify all the visible cells directly, since -[UITableView reloadData] resets a lot
     of things on the table view like selection & editing states
     */
    NSArray <CallSummaryTableViewCell*>* visibleCells = self.tableView.visibleCells;
    NSArray<NSIndexPath *> *indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows;
    for (int index=0; index < visibleCells.count; index++)
    {
        CallSummaryTableViewCell * cell = visibleCells[index];
        NSIndexPath * indexPath = indexPathsForVisibleRows[index];
        
        XWCall * call = [self callAt:indexPath];
        cell.durationLabel.text = [self durationLabelTextForCall:call];
    }
    
}

- (NSString * )durationLabelTextForCall:(XWCall *)call
{ 
    return call.hasConnected?[self.callDurationFormatter formatStringForTimeInterval:call.duration]:nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return _callManager.calls.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CallSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CallSummary" forIndexPath:indexPath];
    
    // Configure the cell...
    XWCall * call = [self callAt:indexPath];
    cell.handleLabel.text = call.handle;
    UIColor * accessoryLabelsTextColor = call.isOnHold ? UIColor.grayColor : cell.tintColor;
    if (call.hasConnected) {
        cell.callStatusTextLabel.text = call.isOnHold? NSLocalizedString(@"CALL_STATUS_HELD", @"Call status label for on hold"): NSLocalizedString(@"CALL_STATUS_ACTIVE", @"Call status label for active");
    }else if (call.hasStartedConnecting){
        cell.callStatusTextLabel.text = NSLocalizedString(@"CALL_STATUS_CONNECTING", @"Call status label for on hold");
    }else{
        cell.callStatusTextLabel.text = call.isOutgoing?NSLocalizedString(@"CALL_STATUS_SENDING", @"Call status label for sending"):NSLocalizedString(@"CALL_STATUS_RINGING", @"Call status label for ringing");
    }
    cell.callStatusTextLabel.textColor = accessoryLabelsTextColor;
    cell.durationLabel.text = [self durationLabelTextForCall: call];
    cell.durationLabel.font = cell.durationLabel.font.addingMonospacedNumberAttributes;
    cell.durationLabel.textColor = accessoryLabelsTextColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XWCall * call = [self callAt:indexPath];
    if (call) {
        call.isOnHold = !call.isOnHold;
        [_callManager setHeldCall:call onHold:call.isOnHold];
    }
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return NSLocalizedString(@"TABLE_CELL_EDIT_ACTION_END", comment: @"End button in call summary table view cell");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        XWCall * call = [self callAt:indexPath];
        if (call) {
            NSLog(@"Requesting to end call: %@", call);
            [self.callManager endCall:call];
        }else{
            NSLog(@"No call found at indexPath: %@", indexPath);
        }
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
