//
//  PGAccountListTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGAccountListTableViewCell.h"
#import "PGDeleteAccountAlertView.h"

@implementation PGAccountListTableViewCell

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
    self.accountLabel.text = model.cardNo;
//    self.stateLabel.text = @"";
}

- (IBAction)deleteBtnAction:(id)sender {
    PGDeleteAccountAlertView * alertView = [[PGDeleteAccountAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alertView.cardNo = self.model.cardNo;
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}

@end
