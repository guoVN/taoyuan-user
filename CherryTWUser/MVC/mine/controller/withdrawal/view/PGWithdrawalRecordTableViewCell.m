//
//  PGWithdrawalRecordTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGWithdrawalRecordTableViewCell.h"

@implementation PGWithdrawalRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(PGWithdrawalRecordModel *)listModel
{
    _listModel = listModel;
    self.nameLabel.text = [NSString stringWithFormat:@"提现%@元",listModel.withdrawalMoneyAmount];
    switch (listModel.withdrawalStatus) {
        case 0:
            self.statusLabel.text = @"提现中";
            break;
        case 1:
            self.statusLabel.text = @"提现成功";
            break;
        case 2:
            self.statusLabel.text = @"提现失败，已退回积分";
            break;
        case 3:
            self.statusLabel.text = @"提现失败，未退回积分";
            break;
        case 4:
            self.statusLabel.text = @"提现失败，退回积分失败";
            break;
        case 5:
            self.statusLabel.text = @"提现到账，重新扣掉退回的积分失败！";
            break;
        case 6:
            self.statusLabel.text = @"审核中";
            break;
        case 7:
            self.statusLabel.text = @"审核不通过";
            break;
        default:
            break;
    }
    self.timeLabel.text = listModel.createTime;
    self.jifenLabel.text = [NSString stringWithFormat:@"-%ld积分",listModel.withdrawalIntegral];
}

@end
