//
//  PGInviteBindTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2026/3/23.
//  Copyright © 2026 guo. All rights reserved.
//

#import "PGInviteBindTableViewCell.h"
#import "PGCustomAlertView.h"

@implementation PGInviteBindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(PGAnchorModel *)model
{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:MPImage(@"womanDefault")];
    self.nameLabel.text = model.nickName;
    self.IDLabel.text = [NSString stringWithFormat:@"%ld",model.userid];
}
- (IBAction)bindBtnAction:(id)sender {
    WeakSelf(self)
    PGCustomAlertView * alertView = [[PGCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alertView.type = 8;
    [alertView.tipsImg setImage:MPImage(@"yiwen")];
    alertView.titleLabel.text = @"温馨提示";
    alertView.contentLabel.text = @"绑定后不可解除\n确认绑定吗？";
    alertView.sureBlock = ^{
        [weakself doBindAction];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}
- (void)doBindAction
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:@(self.model.userid) forKey:@"anchorUserId"];
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    [PGAPIService inviteBindAnchorWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:@"绑定成功"];
        if (weakself.refreshStatusBlock) {
            weakself.refreshStatusBlock();
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}

@end
