//
//  PGChatTableHeaderView.m
//  CherryTWUser
//
//  Created by guo on 2025/2/14.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGChatTableHeaderView.h"

@implementation PGChatTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.tipsLabel];
}
- (void)snapSubView
{
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-28);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
}
- (void)setAnchorDetailModel:(PGAnchorModel *)anchorDetailModel
{
    _anchorDetailModel = anchorDetailModel;
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:@"/条消息"];
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"zuanshiLittle"];
    attach.bounds = CGRectMake(0, -5, 18, 16);
    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
    [att insertAttributedString:attrStringWithImage atIndex:0];
    NSAttributedString * pp = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"文字聊天%ld",[anchorDetailModel.textChatCoin integerValue]/10]];
    [att insertAttributedString:pp atIndex:0];
    self.tipsLabel.attributedText = att;
}
#pragma mark===懒加载
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.backgroundColor = HEXAlpha(#000000, 0.3f);
        _tipsLabel.font = MPFont(10);
        _tipsLabel.textColor = HEX(#FFFFFF);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.layer.cornerRadius = 8;
        _tipsLabel.layer.masksToBounds = YES;
    }
    return _tipsLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
