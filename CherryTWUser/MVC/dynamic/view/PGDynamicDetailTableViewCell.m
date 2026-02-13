//
//  PGDynamicDetailTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGDynamicDetailTableViewCell.h"
#import "PGCustomAlertView.h"

@interface PGDynamicDetailTableViewCell ()

@property (nonatomic, strong) NSArray * preImgArray;

@end

@implementation PGDynamicDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.authBtn yd_setHorizentalGradualFromColor:HEX(#FBCC9C) toColor:HEX(#FF75A0)];
    [self.authBtn bringSubviewToFront:self.authBtn.imageView];
    [self.praiseTotalView yd_setHorizentalGradualFromColor:HEX(#FBAE9C) toColor:HEX(#FF6796)];
    [self.stripView yd_setHorizentalGradualFromColor:HEX(#FBAE9C) toColor:HEX(#FF6796)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleteAction:(id)sender {
    PGCustomAlertView * alertView = [[PGCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alertView.dynamicId = [NSString stringWithFormat:@"%ld",self.model.dynamicid];
    alertView.type = 2;
    [alertView.tipsImg setImage:MPImage(@"yiwen")];
    alertView.titleLabel.text = @"温馨提示";
    alertView.contentLabel.text = @"是否删除该动态？";
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}

- (void)setModel:(PGAnchorDynamicModel *)model
{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:MPImage(@"netFaild")];
    self.authBtn.alpha = [model.auditUser isEqualToString:@"Y"] ? 1 : 0;
    self.nameLabel.text = model.nickName;
    self.ageAndStarLabel.text = [NSString stringWithFormat:@"%@｜%@",model.age>0?[NSString stringWithFormat:@"%ld岁",model.age]:@"",model.constellation.length>0?model.constellation:@""];
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
//    [self.contentView addGestureRecognizer:scroll.panGestureRecognizer];
    scroll.showsHorizontalScrollIndicator = NO;
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
    self.praiseTotalLabel.text = [NSString stringWithFormat:@"赞%ld",model.likeNum];
    CGFloat width = getBoldSize(self.praiseTotalLabel.text, 34, 16).width+1+40;
    self.praiseTotalView.frame = CGRectMake(0, 0, width, 34);
    [self.praiseTotalView yd_setHorizentalGradualFromColor:HEX(#FBAE9C) toColor:HEX(#FF6796)];
}

- (void)imgClik:(UITapGestureRecognizer *)ges
{
    UIImageView * imgV = (UIImageView *)ges.view;
    [HUPhotoBrowser showFromImageView:imgV withURLStrings:self.preImgArray atIndex:ges.view.tag];
}
- (IBAction)praiseAction:(QMUIButton *)sender {
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

- (NSArray *)preImgArray
{
    if (!_preImgArray) {
        _preImgArray = [NSArray array];
    }
    return _preImgArray;
}

@end
