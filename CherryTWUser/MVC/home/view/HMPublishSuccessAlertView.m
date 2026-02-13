//
//  HMPublishSuccessAlertView.m
//  CherryTWanchor
//
//  Created by guo on 2025/9/1.
//

#import "HMPublishSuccessAlertView.h"

@implementation HMPublishSuccessAlertView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        [superView addSubview:self];
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}

- (void)initSubView
{
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    [self addSubview:self.messageLabel];
    [self addSubview:self.sureBtn];
}
- (void)snapSubView
{
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(40);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
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
#pragma mark===懒加载
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = MPMediumFont(18);
        _messageLabel.textColor = HEX(#000000);
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text = Localized(@"发布动态成功");
    }
    return _messageLabel;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 128, 46)];
        _sureBtn.backgroundColor = HEX(#FF6B97);
        [_sureBtn setTitle:Localized(@"确定") forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = MPMediumFont(16);
        _sureBtn.layer.cornerRadius = 23;
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
