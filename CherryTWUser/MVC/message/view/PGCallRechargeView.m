//
//  PGCallRechargeView.m
//  CherryTWUser
//
//  Created by guo on 2025/1/5.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGCallRechargeView.h"

@interface PGCallRechargeView ()<UIGestureRecognizerDelegate>

@end

@implementation PGCallRechargeView

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
    [self.backView addSubview:self.closeBtn];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.qmui_top = 200;
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
- (void)snapSubView
{
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.width.height.mas_equalTo(44);
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
    if (self.refreshCoinBlock) {
        self.refreshCoinBlock();
    }
    [self removeFromSuperview];
}
#pragma mark===懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-200)];
        _backView.backgroundColor = UUWhite;
        [_backView acs_radiusWithRadius:18 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
    }
    return _backView;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:MPImage(@"icon_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
