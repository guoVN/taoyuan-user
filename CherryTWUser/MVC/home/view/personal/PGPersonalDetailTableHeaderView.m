//
//  PGPersonalDetailTableHeaderView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGPersonalDetailTableHeaderView.h"
#import "PGAnchorPriceModel.h"

@interface PGPersonalDetailTableHeaderView ()

@end

@implementation PGPersonalDetailTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.headImg];
    [self addSubview:self.onlineImg];
    [self addSubview:self.contentStackView];
    [self.contentStackView addArrangedSubview:self.nameLabel];
    [self addSubview:self.lineStackView];
    [self.lineStackView addArrangedSubview:self.grayView];
    [self.lineStackView addArrangedSubview:self.onlineLabel];
}
- (void)snapSubView
{
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.width.height.mas_equalTo(90);
    }];
    [self.onlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImg.mas_right).offset(-13);
        make.bottom.equalTo(self.headImg.mas_bottom).offset(0);
        make.width.height.mas_equalTo(12);
    }];
    [self.contentStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(43, 20));
    }];
    [self.lineStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentStackView.mas_bottom).offset(3);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(17);
    }];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(6);
    }];
}
- (void)setDetailModel:(PGAnchorModel *)detailModel
{
    _detailModel = detailModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:detailModel.photo] placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = detailModel.nickName;
    self.grayView.alpha = 0;
    if ([detailModel.onlineState isEqualToString:@"在线"]) {
        [self.onlineImg setImage:MPImage(@"onlineIcon")];
    }else if ([detailModel.onlineState isEqualToString:@"忙碌"]){
        [self.onlineImg setImage:MPImage(@"busyIcon")];
    }else{
        [self.onlineImg setImage:MPImage(@"")];
        self.grayView.alpha = 1;
        self.onlineLabel.text = detailModel.onlineState;
    }
}
- (void)setIsFollow:(NSInteger)isFollow
{
    _isFollow = isFollow;
    if (isFollow == 0) {
        [self.contentStackView addArrangedSubview:self.followBtn];
    }
}
- (void)followBtnAction
{
    self.followBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.followBtn.enabled = YES;
    });
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:@(self.detailModel.userid) forKey:@"friendid"];
    [PGAPIService collectAddWithParameters:dic Success:^(id  _Nonnull data) {
        [weakself.contentStackView removeArrangedSubview:weakself.followBtn];
        [weakself.followBtn removeFromSuperview];
        weakself.followBtn.alpha = 0;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showWithText:message];
    }];
}

- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        [_headImg setImage:MPImage(@"womanDefault")];
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        _headImg.clipsToBounds = YES;
        _headImg.layer.borderWidth = 3;
        _headImg.layer.borderColor = HEX(#FFFFFF).CGColor;
        _headImg.layer.cornerRadius = 45;
        _headImg.layer.masksToBounds = YES;
        _headImg.userInteractionEnabled = YES;
    }
    return _headImg;
}
- (UIImageView *)onlineImg
{
    if (!_onlineImg) {
        _onlineImg = [[UIImageView alloc] init];
        [_onlineImg setImage:MPImage(@"")];
    }
    return _onlineImg;
}
- (UIStackView *)contentStackView
{
    if (!_contentStackView) {
        _contentStackView = [[UIStackView alloc] init];
        _contentStackView.distribution = UIStackViewDistributionEqualSpacing;
        _contentStackView.alignment = UIStackViewAlignmentCenter;
        _contentStackView.axis = UILayoutConstraintAxisHorizontal;
        _contentStackView.spacing = 10;
    }
    return _contentStackView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = MPSemiboldFont(14);
        _nameLabel.textColor = HEX(#000000);
        _nameLabel.text = @"昵称";
    }
    return _nameLabel;
}
- (QMUIButton *)followBtn
{
    if (!_followBtn) {
        _followBtn = [[QMUIButton alloc] init];
        _followBtn.imagePosition = QMUIButtonImagePositionLeft;
        _followBtn.spacingBetweenImageAndTitle = 3;
        _followBtn.backgroundColor = HEX(#FF6B97);
        [_followBtn setImage:MPImage(@"") forState:UIControlStateNormal];
        [_followBtn setImage:MPImage(@"") forState:UIControlStateSelected];
        [_followBtn setTitle:Localized(@"+ 关注") forState:UIControlStateNormal];
        [_followBtn setTitle:Localized(@"已关注") forState:UIControlStateSelected];
        [_followBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _followBtn.titleLabel.font = MPSemiboldFont(10);
        _followBtn.layer.cornerRadius = 10;
        _followBtn.layer.masksToBounds = YES;
        [_followBtn addTarget:self action:@selector(followBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}
- (UIStackView *)lineStackView
{
    if (!_lineStackView) {
        _lineStackView = [[UIStackView alloc] init];
        _lineStackView.distribution = UIStackViewDistributionEqualSpacing;
        _lineStackView.alignment = UIStackViewAlignmentCenter;
        _lineStackView.axis = UILayoutConstraintAxisHorizontal;
        _lineStackView.spacing = 5;
    }
    return _lineStackView;
}
- (UIView *)grayView
{
    if (!_grayView) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = HEX(#999999);
        _grayView.layer.cornerRadius = 3;
        _grayView.layer.masksToBounds = YES;
    }
    return _grayView;
}
- (UILabel *)onlineLabel
{
    if (!_onlineLabel) {
        _onlineLabel = [[UILabel alloc] init];
        _onlineLabel.font = MPLightFont(12);
        _onlineLabel.textColor = HEX(#666666);
    }
    return _onlineLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
