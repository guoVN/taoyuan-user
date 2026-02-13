//
//  PGUnlockChatAlertView.m
//  CherryTWUser
//
//  Created by guo on 2025/10/26.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGUnlockChatAlertView.h"

@implementation PGUnlockChatAlertView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        [superView addSubview:self];
        self.backgroundColor = HEX(#FFFFFF);
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    [self addSubview:self.contentLabel];
    [self addSubview:self.sureBtn];
    [self addSubview:self.cancelBtn];
}
- (void)snapSubView
{
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(44);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(128, 46));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(128, 46));
    }];
}
- (void)setType:(NSInteger)type
{
    _type = type;
    if (type == 2) {
        self.contentLabel.text = @"与当前用户存在未使用订单，是否现在使用？";
        [self.sureBtn setTitle:Localized(@"现在使用") forState:UIControlStateNormal];
        [self.cancelBtn setTitle:Localized(@"新下订单") forState:UIControlStateNormal];
    }else if (type == 3){
        self.contentLabel.text = [NSString stringWithFormat:@"是否消耗%ld币，视频1分钟，验证对方颜值",[[PGManager shareModel].chatUnlockCoin integerValue]/100];
        [self.sureBtn setTitle:Localized(@"发送验证") forState:UIControlStateNormal];
    }
}
- (void)sureBtnAction
{
    if (self.sureBlock) {
        self.sureBlock();
    }
    [[PGManager shareModel].mainControlAlert closeView];
}
- (void)cancelBtnAction
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [[PGManager shareModel].mainControlAlert closeView];
}

#pragma mark===懒加载
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = MPFont(15);
        _contentLabel.textColor = HEX(#000000);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = Localized(@"确认解锁与Ta私信功能吗？");
    }
    return _contentLabel;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor = HEX(#FF6B97);
        [_sureBtn setTitle:Localized(@"确认") forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = MPLightFont(16);
        _sureBtn.layer.cornerRadius = 23;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:Localized(@"再想想") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX(#000000) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = MPLightFont(16);
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = HEX(#000000).CGColor;
        _cancelBtn.layer.cornerRadius = 23;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
