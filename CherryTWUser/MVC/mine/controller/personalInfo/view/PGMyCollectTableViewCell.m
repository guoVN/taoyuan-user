//
//  PGMyCollectTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/17.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGMyCollectTableViewCell.h"
#import "PGChatViewController.h"

@implementation PGMyCollectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PGMyCollectModel *)model
{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = model.name;
}
- (IBAction)chatAction:(id)sender {
    PGChatViewController * vc = [[PGChatViewController alloc] init];
    vc.channelId = [NSString stringWithFormat:@"%ld",self.model.uid];
    vc.friendHead = self.model.photoUrl;
    vc.friendName = self.model.name;
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
