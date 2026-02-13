//
//  PGCustomAlertView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/5.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGCustomAlertView.h"
#import "PGDiamondsListViewController.h"

@interface PGCustomAlertView()<UIGestureRecognizerDelegate>

@end

@implementation PGCustomAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXAlpha(#000000, 0.6f);
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
    [self.backView addSubview:self.contentLabel];
    [self.backView addSubview:self.cancelBtn];
    [self.backView addSubview:self.sureBtn];
    [self.backView addSubview:self.hengView];
    [self.backView addSubview:self.shuView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
- (void)snapSubView
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(295, 342));
    }];
    [self.tipsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(35);
        make.width.height.mas_equalTo(96);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.tipsImg.mas_bottom).offset(18);
        make.height.mas_equalTo(33);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(295*0.5);
        make.height.mas_equalTo(72);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.width.equalTo(self.cancelBtn.mas_width);
        make.height.mas_equalTo(72);
    }];
    [self.hengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-72);
        make.height.mas_equalTo(1);
    }];
    [self.shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.top.equalTo(self.hengView.mas_bottom);
    }];
}
- (void)setType:(NSInteger)type
{
    _type = type;
    if (type == 4) {
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(295, 382));
        }];
    }else if (type == 6){
        [self.tipsImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(203);
            make.height.mas_equalTo(113);
        }];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
    }
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
    if (self.type == 5) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelRecharge" object:nil userInfo:nil];
    }
    [self removeFromSuperview];
}
- (void)sureBtnAction
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    if (self.type == 1) {
        [[PGUtils getCurrentVC].navigationController popViewControllerAnimated:YES];
    }else if (self.type == 2) {
        [dic setValue:self.dynamicId forKey:@"dynamicId"];
        [PGAPIService deleteDynamicWithParameters:dic Success:^(id  _Nonnull data) {
            [QMUITips showWithText:@"删除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDynamic" object:nil userInfo:nil];
            [[PGUtils getCurrentVC].navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips showWithText:message];
        }];
    }else if (self.type == 3) {
        [PGAPIService logOutWithParameters:dic Success:^(id  _Nonnull data) {
            [PGUtils loginOut];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips showWithText:message];
        }];
    }else if (self.type == 4){
        [PGAPIService logOffWithParameters:dic Success:^(id  _Nonnull data) {
            [PGUtils loginOut];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips showWithText:message];
        }];
    }else if (self.type == 5){
        PGDiamondsListViewController * vc = [[PGDiamondsListViewController alloc] init];
        [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if (self.type == 6){
        if (self.sureBlock) {
            self.sureBlock();
        }
    }else if (self.type == 7){
        if (self.sureBlock) {
            self.sureBlock();
        }
    }
    [self removeFromSuperview];
}
#pragma mark===懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 295, 342)];
        _backView.backgroundColor = UUWhite;
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        [_backView yd_setVeticalGradualFromColor:HEXAlpha(#FFC5D7, 0.15) toColor:HEXAlpha(#FFFFFF, 1.0)];
    }
    return _backView;
}
- (UIImageView *)tipsImg
{
    if (!_tipsImg) {
        _tipsImg = [[UIImageView alloc] init];
        [_tipsImg setImage:MPImage(@"chenggong")];
    }
    return _tipsImg;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        _titleLabel.textColor = HEX(#000000);
        _titleLabel.text = @"举报成功";
    }
    return _titleLabel;
}
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = MPFont(18);
        _contentLabel.textColor = HEX(#000000);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"已经发送举报通知";
    }
    return _contentLabel;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX(#000000) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
        [_cancelBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(#000000) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIView *)hengView
{
    if (!_hengView) {
        _hengView = [[UIView alloc] init];
        _hengView.backgroundColor = HEX(#EEEEEE);
    }
    return _hengView;
}
- (UIView *)shuView
{
    if (!_shuView) {
        _shuView = [[UIView alloc] init];
        _shuView.backgroundColor = HEX(#EEEEEE);
    }
    return _shuView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
