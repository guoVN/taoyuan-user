//
//  PGInviteFriendCopyAlertView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGInviteFriendCopyAlertView.h"

@interface PGInviteFriendCopyAlertView()<UIGestureRecognizerDelegate>

@end

@implementation PGInviteFriendCopyAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXAlpha(#2A2A2A, 0.78f);
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.contentLabel];
    [self.backView addSubview:self.sureBtn];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
- (void)snapSubView
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(305, 178));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(36);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(23);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-18);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(95, 32));
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
        _backView.backgroundColor = UUWhite;
        [_backView acs_radiusWithRadius:10 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
    }
    return _backView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
        _titleLabel.textColor = HEX(#333333);
        _titleLabel.text = @"复制成功";
    }
    return _titleLabel;
}
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = MPBoldFont(15);
        _contentLabel.textColor = HEX(#707070);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"赶快发送好友下载，立即赚钱吧！！！";
    }
    return _contentLabel;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor = HEX(#FD87B2);
        [_sureBtn setTitle:@"好的" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UUWhite forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _sureBtn.layer.cornerRadius = 16;
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
