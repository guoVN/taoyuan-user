//
//  PGMessageSystemTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/16.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGMessageSystemTableViewCell.h"

@implementation PGMessageSystemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PGMessageChatModel *)model
{
    _model = model;
    self.contentLabel.text = model.contenStr;
}

@end
