//
//  PGWithdrawalTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGWithdrawalAccountListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGWithdrawalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (nonatomic, strong) PGWithdrawalAccountListModel * model;

@end

NS_ASSUME_NONNULL_END
