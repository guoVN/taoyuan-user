//
//  PGDynamicListTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGDynamicListTableViewCell.h"
#import "PGChatViewController.h"
#import "PGPersonalDetailViewController.h"

@interface PGDynamicListTableViewCell ()

@property (nonatomic, strong) NSArray * preImgArray;

@end

@implementation PGDynamicListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)praiseBtnAction:(QMUIButton *)sender {
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:@(self.model.dynamicid) forKey:@"dynamicid"];
    [PGAPIService dynamicPraiseWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.model.isLike = @"Y";
        weakself.model.likeNum +=1;
        weakself.model = weakself.model;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showWithText:message];
    }];
}

- (void)setModel:(PGAnchorDynamicModel *)model
{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = model.nickName;
    self.contentLabel.text = model.content;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",model.likeNum] forState:UIControlStateNormal];
    self.praiseBtn.selected = [model.isLike isEqualToString:@"Y"] ? YES : NO;
    [self.viewBtn setTitle:[NSString stringWithFormat:@"%u",arc4random_uniform(100)+1] forState:UIControlStateNormal];
    [self.timeBtn setTitle:[PGUtils timeBeforeInfoWithString:[PGUtils ConvertsTimeStrToTimeStamp:model.createTime]] forState:UIControlStateNormal];
    self.imgShowViewHC.constant = model.photoUrl.length>0?80:0;
    for (UIView * view in self.imageShowView.subviews) {
        [view removeFromSuperview];
    }
    UIScrollView * scroll = [[UIScrollView alloc] init];
    scroll.userInteractionEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    [scroll addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCell:)]];
    [self.imageShowView addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    NSArray * imgArr = [model.photoUrl componentsSeparatedByString:@","];
    for (NSInteger i = 0; i <imgArr.count; i++) {
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(90*i, 0, 80, 80)];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        imgV.layer.cornerRadius = 10;
        imgV.layer.masksToBounds = YES;
        [imgV sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] placeholderImage:MPImage(@"netFaild")];
        imgV.userInteractionEnabled = YES;
        imgV.tag = i;
        [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClik:)]];
        [scroll addSubview:imgV];
    }
    scroll.contentSize = CGSizeMake(90*imgArr.count, 0);
    self.preImgArray = imgArr;
}
- (IBAction)priveChat:(id)sender {
    PGChatViewController * vc = [[PGChatViewController alloc] init];
    vc.channelId = [NSString stringWithFormat:@"%ld",self.model.userid];
    vc.friendHead = self.model.photo;
    vc.friendName = self.model.nickName;
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)clickHead:(UITapGestureRecognizer *)ges
{
    PGPersonalDetailViewController * vc = [[PGPersonalDetailViewController alloc] init];
    vc.anchorid = [NSString stringWithFormat:@"%ld",self.model.userid];
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)clickCell:(UITapGestureRecognizer *)ges
{
    
}
- (void)imgClik:(UITapGestureRecognizer *)ges
{
    UIImageView * imgV = (UIImageView *)ges.view;
    [HUPhotoBrowser showFromImageView:imgV withURLStrings:self.preImgArray atIndex:ges.view.tag];
}
- (NSArray *)preImgArray
{
    if (!_preImgArray) {
        _preImgArray = [NSArray array];
    }
    return _preImgArray;
}

@end
