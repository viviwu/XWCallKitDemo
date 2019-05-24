//
//  CallSummaryTableViewCell.h
//  XWCallKiter
//
//  Created by vivi wu on 2019/5/22.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CallSummaryTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel * handleLabel;
@property(nonatomic, weak) IBOutlet UILabel * callStatusTextLabel;
@property(nonatomic, weak) IBOutlet UILabel * durationLabel;

@end

NS_ASSUME_NONNULL_END
