//
//  PGSearchResultTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGSearchResultTableViewCell.h"
#import "PGChatViewController.h"

@implementation PGSearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PGHomeListModel *)model
{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = model.name;
    self.IDLabel.text = [NSString stringWithFormat:@"%ld",model.userid];
    if ([model.onlineState isEqualToString:@"在线"]) {
        self.onlineView.backgroundColor = HEX(#5BF843);
        [self.onlineImg setImage:MPImage(@"onlineIcon")];
    }else if ([model.onlineState isEqualToString:@"离线"]){
        self.onlineView.backgroundColor = HEX(#F4F4F4);
        [self.onlineImg setImage:MPImage(@"")];
    }else if ([model.onlineState isEqualToString:@"忙碌"]){
        self.onlineView.backgroundColor = HEX(#FF0000);
        [self.onlineImg setImage:MPImage(@"busyIcon")];
    }
}
- (IBAction)chatAction:(id)sender {
    PGChatViewController * vc = [[PGChatViewController alloc] init];
    vc.channelId = [NSString stringWithFormat:@"%ld",self.model.userid];
    vc.friendHead = self.model.photoUrl;
    vc.friendName = self.model.name;
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
