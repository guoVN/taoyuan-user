//
//  PGAccountListTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGWithdrawalAccountListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGAccountListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (nonatomic, strong) PGWithdrawalAccountListModel * model;

@end

NS_ASSUME_NONNULL_END
