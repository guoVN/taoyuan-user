//
//  PGPersonalYuYueAlertTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/11/2.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGPersonalYuYueAlertTableViewCell.h"

@implementation PGPersonalYuYueAlertTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(HMPlayTypeProjectListModel *)listModel
{
    _listModel = listModel;
    self.projectLabel.text = listModel.configName;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",listModel.giftCoin/100];
}

@end
