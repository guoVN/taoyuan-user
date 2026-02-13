//
//  PGInviteFriendPosterCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGInviteFriendPosterCollectionViewCell.h"

@implementation PGInviteFriendPosterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.codeImg addSubview:self.ColorImageView];
    [self.codeImg sendSubviewToBack:self.ColorImageView];
}
- (void)setLinkUrl:(NSString *)linkUrl
{
    _linkUrl = linkUrl;
    NSString * codeStr = linkUrl;
    UIImage * oimg = [PGQRCodeTool createQRForString:codeStr andSize:62];
    self.ColorImageView.colors = @[(__bridge id)HEX(#333333).CGColor,(__bridge id)HEX(#333333).CGColor];
    [self.ColorImageView  syncFrame];
    [self.ColorImageView setQRCodeImage:oimg];
}
- (void)setCodeStr:(NSString *)codeStr
{
    _codeStr = codeStr;
    self.inviteCodeLabel.text = [NSString stringWithFormat:@"邀请码：%@",codeStr];
}
- (PGColorfulQRCodeView *)ColorImageView
{
    if (!_ColorImageView) {
        _ColorImageView = [[PGColorfulQRCodeView alloc] initWithFrame:CGRectMake(0, 0, 62, 62)];
        _ColorImageView.layer.cornerRadius = 8;
        _ColorImageView.layer.masksToBounds = YES;
    }
    return _ColorImageView;
}

@end
