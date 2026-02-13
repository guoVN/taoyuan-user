//
//  PGBaseNavigationView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/2.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseNavigationView.h"

@implementation PGBaseNavigationView


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
    [self addSubview:self.backBtn];
    [self addSubview:self.navImg];
    [self addSubview:self.titleLabel];
    [self addSubview:self.titleBtn];
    [self addSubview:self.rightBtn];
    self.backBtn.alpha = [PGUtils getCurrentVC].navigationController.viewControllers.count > 1 ? 1 : 0;
}
- (void)snapSubView
{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    [self.navImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_H_F+10);
        make.centerX.mas_equalTo(0);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
}

- (void)backBtnAction:(QMUIButton *)sender
{
    [[PGUtils getCurrentVC].navigationController popViewControllerAnimated:YES];
}
- (void)setShowNavImg:(BOOL)showNavImg
{
    _showNavImg = showNavImg;
    if (showNavImg) {
        self.navImg.alpha = 1;
        self.titleLabel.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.navImg.alpha = 0;
        self.titleLabel.alpha = 1;
        self.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark===懒加载
- (QMUIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[QMUIButton alloc] init];
        [_backBtn setImage:MPImage(@"return") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MPMediumFont(16);
        _titleLabel.textColor = HEX(#222222);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (QMUIButton *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [[QMUIButton alloc] init];
        _titleBtn.imagePosition = QMUIButtonImagePositionBottom;
        _titleBtn.spacingBetweenImageAndTitle = 2;
        [_titleBtn setTitleColor:HEX(#333333) forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
    }
    return _titleBtn;
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
    }
    return _rightBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
