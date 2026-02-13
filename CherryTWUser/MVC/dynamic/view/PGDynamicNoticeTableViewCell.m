//
//  PGDynamicNoticeTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGDynamicNoticeTableViewCell.h"

@implementation PGDynamicNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PGDynamicNoticeModel *)model
{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = model.nickName;
    [self.timeBtn setTitle:model.createTime forState:UIControlStateNormal];
    [self.contentImg sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:MPImage(@"netFaild")];
}

@end
