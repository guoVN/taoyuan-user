//
//  HMSureHangUpAlertView.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/15.
//

#import "HMSureHangUpAlertView.h"

@implementation HMSureHangUpAlertView

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.sureBtn];
    [self addSubview:self.cancelBtn];
}
- (void)snapSubView
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(21);
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
    if (type == 1) {
        self.titleLabel.text = @"";
        self.contentLabel.text = Localized(@"确定删除此支付宝/银行卡吗？\n点击确认删除");
        self.contentLabel.font = MPFont(18);
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(36);
            make.centerX.mas_equalTo(0);
        }];
        [self.sureBtn setTitle:Localized(@"确认") forState:UIControlStateNormal];
    }
}

- (void)sureBtnAction
{
    if (self.sureHangUpBlock) {
        self.sureHangUpBlock();
    }
    [[PGManager shareModel].mainControlAlert closeView];
}
- (void)cancelBtnAction
{
    [[PGManager shareModel].mainControlAlert closeView];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MPMediumFont(18);
        _titleLabel.textColor = HEX(#000000);
        _titleLabel.text = Localized(@"确认挂断吗？");
    }
    return _titleLabel;
}
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = MPFont(15);
        _contentLabel.textColor = HEX(#000000);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = Localized(@"挂断，或者直接强行退出app不退还费用，如对方有问题，请联系客服投诉");
    }
    return _contentLabel;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor = HEX(#FF6B97);
        [_sureBtn setTitle:Localized(@"确认挂断") forState:UIControlStateNormal];
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
