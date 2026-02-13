//
//  PGDynamicHeaderView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGDynamicHeaderView.h"
#import "PGDynamicNoticeViewController.h"
#import "PGDynamicNoticeModel.h"

@implementation PGDynamicHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.headImg];
    [self.backView addSubview:self.titleLabel];
    [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkNoti)]];
}
- (void)snapSubView
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(30);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.mas_right).offset(10);
        make.right.mas_equalTo(-27);
        make.centerY.mas_equalTo(0);
    }];
}
- (void)setNoticeArray:(NSArray *)noticeArray
{
    _noticeArray = noticeArray;
    PGDynamicNoticeModel * model = noticeArray.firstObject;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:MPImage(@"netFaild")];
    self.titleLabel.text = [NSString stringWithFormat:@"%ld条消息",noticeArray.count];
}
- (void)checkNoti
{
    PGDynamicNoticeViewController * vc = [[PGDynamicNoticeViewController alloc] init];
    vc.dataArray = [self.noticeArray mutableCopy];
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark===懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEX(#5A5A5A);
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        _backView.userInteractionEnabled = YES;
    }
    return _backView;
}
- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.backgroundColor = THEAME_COLOR;
        _headImg.layer.cornerRadius = 10;
        _headImg.layer.masksToBounds = YES;
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        _headImg.clipsToBounds = YES;
    }
    return _headImg;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MPFont(11);
        _titleLabel.textColor = HEX(#FFFFFF);
        _titleLabel.text = @"1条消息";
    }
    return _titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
