//
//  PGInviteFriendListTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGInviteFriendListTableViewCell.h"

@implementation PGInviteFriendListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIncomeListRecordModel:(PGInviteInComeModelListRecordsModel *)incomeListRecordModel
{
    _incomeListRecordModel = incomeListRecordModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:incomeListRecordModel.photo] placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = incomeListRecordModel.nickName;
    self.IDLabel.text = [NSString stringWithFormat:@"id:%ld",incomeListRecordModel.userid];
    self.diamondsNumlabel.text = [NSString stringWithFormat:@"%.0f",incomeListRecordModel.integral*0.1];
}

- (void)setFriendListRecordModel:(PGInviteInFriendModelListRecordsModel *)friendListRecordModel
{
    _friendListRecordModel = friendListRecordModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:friendListRecordModel.photo] placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = friendListRecordModel.nickName;
    self.IDLabel.text = [NSString stringWithFormat:@"id:%ld",friendListRecordModel.userid];
    self.timeLabel.text = friendListRecordModel.createTime;
}

@end
