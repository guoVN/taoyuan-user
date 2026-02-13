//
//  PGDeleteAccountAlertView.m
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGDeleteAccountAlertView.h"

@interface PGDeleteAccountAlertView ()<UIGestureRecognizerDelegate>

@end

@implementation PGDeleteAccountAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXAlpha(#000000, 0.5f);
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.sureBtn];
    [self.backView addSubview:self.cancelBtn];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
- (void)snapSubView
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(305, 186));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(50);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView.mas_centerX).offset(-10);
        make.bottom.mas_equalTo(-37);
        make.size.mas_equalTo(CGSizeMake(95, 28));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_centerX).offset(10);
        make.top.equalTo(self.sureBtn);
        make.size.mas_equalTo(CGSizeMake(95, 28));
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
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:@"1" forKey:@"type"];
    [dic setValue:self.cardNo forKey:@"cardNo"];
    [PGAPIService deleteWithdrawAccountWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAccount" object:nil userInfo:nil];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
    [self removeFromSuperview];
}

#pragma mark===懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 305, 186)];
        _backView.backgroundColor = UUWhite;
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
        _titleLabel.textColor = HEX(#000000);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"确定删除此支付宝吗？\n点击确认删除";
    }
    return _titleLabel;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX(#9797FF) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = MPFont(12);
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = HEX(#9797FF).CGColor;
        _cancelBtn.layer.cornerRadius = 6;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 95, 28)];
        [_sureBtn yd_setHorizentalGradualFromColor:HEX(#A0A0EB) toColor:HEX(#E6BEE2)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = MPFont(12);
        _sureBtn.layer.cornerRadius = 6;
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
