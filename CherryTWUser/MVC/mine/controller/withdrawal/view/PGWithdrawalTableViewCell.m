//
//  PGWithdrawalTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGWithdrawalTableViewCell.h"

@implementation PGWithdrawalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PGWithdrawalAccountListModel *)model
{
    _model = model;
    self.cardNoLabel.text = model.cardNo;
}

@end
