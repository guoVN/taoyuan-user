//
//  HMYuYueRecordTableViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/14.
//

#import <UIKit/UIKit.h>
#import "HMYuYueRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMYuYueRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *projectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectViewHC;

@property (nonatomic, strong) HMYuYueRecordListModel * listModel;

@end

NS_ASSUME_NONNULL_END
