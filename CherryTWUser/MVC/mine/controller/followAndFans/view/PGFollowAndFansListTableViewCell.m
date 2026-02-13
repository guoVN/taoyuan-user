//
//  PGFollowAndFansListTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/10/24.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGFollowAndFansListTableViewCell.h"
#import "PGChatViewController.h"
#import "PGPersonalDetailViewController.h"

@implementation PGFollowAndFansListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    WeakSelf(self)
    [self.headImg jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakself checkInfo];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setVcIndex:(NSInteger)vcIndex
{
    _vcIndex = vcIndex;
}
- (void)setListModel:(HMFansAndFollowListModel *)listModel
{
    _listModel = listModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:listModel.photoUrl] placeholderImage:MPImage(@"womanDefault")];
    self.nameLabel.text = listModel.name;
    if (self.vcIndex == 0) {
        self.listModel.isAttention = @"Y";
    }
}
- (IBAction)statusChangeAction:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    WeakSelf(self)
    if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:@(self.listModel.uid) forKey:@"friendid"];
        [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
        [PGAPIService cancelAttentionWithParameters:dic Success:^(id  _Nonnull data) {
            if (weakself.cancelFollowBlock) {
                weakself.cancelFollowBlock();
            }
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips showWithText:message];
        }];
    }
}
- (IBAction)chatBtnAction:(id)sender {
    PGChatViewController * vc = [[PGChatViewController alloc] init];
    vc.friendHead = self.listModel.photoUrl;
    vc.friendName = self.listModel.name;
    vc.channelId = [NSString stringWithFormat:@"%ld",self.listModel.uid];
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)checkInfo
{
    PGPersonalDetailViewController * vc = [[PGPersonalDetailViewController alloc] init];
    vc.anchorid = [NSString stringWithFormat:@"%ld",self.listModel.uid];
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
