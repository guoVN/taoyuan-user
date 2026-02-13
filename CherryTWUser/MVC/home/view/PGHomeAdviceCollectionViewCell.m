//
//  PGHomeAdviceCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGHomeAdviceCollectionViewCell.h"
#import "PGChatViewController.h"

@implementation PGHomeAdviceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(PGHomeListModel *)listModel
{
    _listModel = listModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:listModel.photoUrl] placeholderImage:MPImage(@"netFaild")];
    [self.headImg acs_radiusWithRadius:25 corner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    self.nameLabel.text = listModel.name;
    self.onlineLabel.text = listModel.onlineState;
    if ([listModel.onlineState isEqualToString:@"在线"]) {
        self.onlineView.backgroundColor = HEX(#5BF843);
        [self.onlineImg setImage:MPImage(@"onlineIcon")];
    }else if ([listModel.onlineState isEqualToString:@"离线"]){
        self.onlineView.backgroundColor = HEX(#F4F4F4);
        [self.onlineImg setImage:MPImage(@"")];
    }else if ([listModel.onlineState isEqualToString:@"忙碌"]){
        self.onlineView.backgroundColor = HEX(#FF0000);
        [self.onlineImg setImage:MPImage(@"busyIcon")];
    }
}
- (IBAction)chatAction:(id)sender {
    PGChatViewController * vc = [[PGChatViewController alloc] init];
    vc.channelId = [NSString stringWithFormat:@"%ld",self.listModel.userid];
    vc.friendHead = self.listModel.photoUrl;
    vc.friendName = self.listModel.name;
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
