//
//  PGChatNavigationView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/12.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGChatNavigationView.h"

@implementation PGChatNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXAlpha(#5B5B5B, 0.52f);
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.backBtn];
    [self addSubview:self.navImg];
    [self addSubview:self.headImg];
    [self addSubview:self.titleLabel];
    [self addSubview:self.sexImg];
    [self addSubview:self.rightBtn];
    [self addSubview:self.priceView];
    [self.priceView addSubview:self.priceLabel];
}
- (void)snapSubView
{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
//        make.bottom.mas_equalTo(-24);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_greaterThanOrEqualTo(44);
    }];
    [self.navImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.backBtn.mas_right).offset(10);
        make.right.equalTo(self.titleLabel.mas_left).offset(-11);
        make.width.height.mas_equalTo(32);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_H_F+10);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(self.rightBtn.mas_left).offset(-10);
        make.left.equalTo(self.titleLabel.mas_right).offset(13);
        make.width.height.mas_equalTo(13);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
//        make.bottom.mas_equalTo(-24);
        make.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(82);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(3);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-4);
    }];
}

- (void)backBtnAction:(QMUIButton *)sender
{
//    [[PGUtils getCurrentVC].navigationController popViewControllerAnimated:YES];
}

- (void)setShowNavImg:(BOOL)showNavImg
{
    _showNavImg = showNavImg;
    if (showNavImg) {
        self.navImg.alpha = 1;
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.navImg.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
    }
}
- (void)updateCallPriceWith:(PGAnchorPriceModel *)model
{
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:@"/min)"];
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"zuanshiLittle"];
    attach.bounds = CGRectMake(0, -4, 18, 16);
    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
    [att insertAttributedString:attrStringWithImage atIndex:0];
    NSAttributedString * pp = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%ld",model.video/10]];
    [att insertAttributedString:pp atIndex:0];
    self.priceLabel.attributedText = att;
}
#pragma mark===懒加载
- (QMUIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[QMUIButton alloc] init];
        _backBtn.imagePosition = QMUIButtonImagePositionLeft;
        _backBtn.spacingBetweenImageAndTitle = 11;
        [_backBtn setImage:MPImage(@"returnW") forState:UIControlStateNormal];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:UUWhite forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        _headImg.clipsToBounds = YES;
        _headImg.layer.cornerRadius = 16;
        _headImg.layer.masksToBounds = YES;
    }
    return _headImg;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _titleLabel.textColor = UUWhite;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)sexImg
{
    if (!_sexImg) {
        _sexImg = [[UIImageView alloc] init];
        [_sexImg setImage:MPImage(@"chat_woman")];
    }
    return _sexImg;
}
- (UIImageView *)navImg
{
    if (!_navImg) {
        _navImg = [[UIImageView alloc] init];
        [_navImg setImage:MPImage(@"logo")];
        _navImg.contentMode = UIViewContentModeScaleAspectFit;
        _navImg.alpha = 0;
    }
    return _navImg;
}
- (QMUIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[QMUIButton alloc] init];
        [_rightBtn setImage:MPImage(@"moreW") forState:UIControlStateNormal];
    }
    return _rightBtn;
}
- (UIView *)priceView
{
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
        _priceView.backgroundColor = HEXAlpha(#F5F5F5, 0.53f);
        [_priceView acs_radiusWithRadius:10 corner:UIRectCornerAllCorners];
        _priceView.alpha = 0;
    }
    return _priceView;
}
- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = MPBoldFont(12);
        _priceLabel.textColor = HEX(#FFFFFF);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
