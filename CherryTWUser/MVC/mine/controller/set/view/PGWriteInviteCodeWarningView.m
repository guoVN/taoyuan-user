//
//  PGWriteInviteCodeWarningView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/18.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGWriteInviteCodeWarningView.h"

@interface PGWriteInviteCodeWarningView()<UIGestureRecognizerDelegate>

@end

@implementation PGWriteInviteCodeWarningView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXAlpha(#2A2A2A, 0.62f);
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.tipsImg];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.sureBtn];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
- (void)snapSubView
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(315, 270));
    }];
    [self.tipsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(141);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-28);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(52);
    }];
}

#pragma mark===UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.backView]) {
        return NO;
    }
    return YES;
}

- (void)closeWindow
{
    [self removeFromSuperview];
}
- (void)sureBtnAction
{
   
    [self removeFromSuperview];
}
#pragma mark===懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}
- (UIImageView *)tipsImg
{
    if (!_tipsImg) {
        _tipsImg = [[UIImageView alloc] init];
        [_tipsImg setImage:MPImage(@"warning")];
    }
    return _tipsImg;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        _titleLabel.textColor = HEX(#333333);
        _titleLabel.text = @"邀请码出错，请仔细检查";
    }
    return _titleLabel;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 259, 52)];
        [_sureBtn yd_setHorizentalGradualFromColor:HEX(#FF9CBB) toColor:HEX(#BA7DF0)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _sureBtn.layer.cornerRadius = 26;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
