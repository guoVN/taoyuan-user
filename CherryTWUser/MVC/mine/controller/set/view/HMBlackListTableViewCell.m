//
//  HMBlackListTableViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/8/30.
//

#import "HMBlackListTableViewCell.h"
#import "PGPersonalDetailViewController.h"

@implementation HMBlackListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    WeakSelf(self)
    [self.headImg jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakself checkAnchor];
    }];
    [self.nickNameLabel jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakself checkAnchor];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(HMBlackListModel *)listModel
{
    _listModel = listModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:listModel.photo] placeholderImage:MPImage(@"manDefault")];
    self.nickNameLabel.text = listModel.anchorName;
}

- (IBAction)removeBtnAction:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:@(self.listModel.targetid) forKey:@"targetid"];
    [PGAPIService cancelBlackActionWithParameters:dic Success:^(id  _Nonnull data) {
        if (weakself.unBindBlock) {
            weakself.unBindBlock();
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)checkAnchor
{
    PGPersonalDetailViewController * vc = [[PGPersonalDetailViewController alloc] init];
    vc.anchorid = [NSString stringWithFormat:@"%ld",self.listModel.anchorid];
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
