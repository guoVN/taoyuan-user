//
//  HMBlackAlertView.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/27.
//

#import "HMBlackAlertView.h"

@implementation HMBlackAlertView

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
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20);
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
- (void)sureBtnAction
{
    if (self.sureBlock) {
        self.sureBlock();
    }
    [[PGManager shareModel].mainControlAlert closeView];
}
- (void)cancelBtnAction
{
    [[PGManager shareModel].mainControlAlert closeView];
}

#pragma mark===懒加载
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = MPLightFont(18);
        _contentLabel.textColor = HEX(#000000);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = Localized(@"拉黑后，您将不再接收此用户任何消息，确定拉黑他吗？");
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
        _sureBtn.titleLabel.font = MPMediumFont(16);
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
        _cancelBtn.titleLabel.font = MPFont(16);
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
