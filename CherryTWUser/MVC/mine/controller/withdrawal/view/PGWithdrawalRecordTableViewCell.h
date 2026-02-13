//
//  PGWithdrawalRecordTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGWithdrawalRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PGWithdrawalRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;

@property (nonatomic, strong) PGWithdrawalRecordModel * listModel;

@end

NS_ASSUME_NONNULL_END
