//
//  PGChatRightTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/12.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGChatRightTableViewCell.h"

@implementation PGChatRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentShowView acs_radiusWithRadius:10 corner:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMsdDic:(NSDictionary *)msdDic
{
    _msdDic = msdDic;
    NSString * contetStr = msdDic[@"content"];
//    NSArray * arr = [contetStr componentsSeparatedByString:@"!!@@##"];
    NSString * msgType = msdDic[@"type"];
    WeakSelf(self)
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[PGManager shareModel].userInfo.photo] placeholderImage:MPImage(@"womanDefault")];
    self.contentLabel.text = contetStr;
    if ([msgType isEqualToString:@"礼物"]) {
        for (PGGiftListModel * giftModel in [PGManager shareModel].giftArray) {
            if ([giftModel.name isEqualToString:contetStr]) {
                NSString * giftUrl = giftModel.pic;
                NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",Localized(@"您送出礼物")]];
                NSTextAttachment * attach = [[NSTextAttachment alloc] init];
                attach.image = [UIImage imageNamed:@""];
                attach.bounds = CGRectMake(0, -5, 22, 22);
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:giftUrl] options:SDWebImageRetryFailed  progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    attach.image = image;
                    weakself.contentLabel.attributedText = att;
                    weakself.contentLabel.backgroundColor = [UIColor clearColor];
                }];
                NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
                [att appendAttributedString:attrStringWithImage];
                NSMutableAttributedString * numStr = [[NSMutableAttributedString alloc] initWithString:@"X1"];
                [numStr addAttribute:NSForegroundColorAttributeName value:HEX(#F55569) range:NSMakeRange(0, numStr.length)];
                [att appendAttributedString:numStr];
                self.contentLabel.attributedText = att;
            }
        }
    }else if ([msgType isEqualToString:@"视频"] || [msgType isEqualToString:@"视频卡"] || [msgType isEqualToString:@"取消"] || [msgType isEqualToString:@"拒绝"] || [msgType isEqualToString:@"挂断"]){
        if ([msgType isEqualToString:@"取消"]) {
            contetStr = Localized(@"已取消");
        }else if ([msgType isEqualToString:@"拒绝"]){
            contetStr = Localized(@"已拒绝");
        }else if ([msgType isEqualToString:@"挂断"]){
            contetStr = [[NSUserDefaults standardUserDefaults] objectForKey:self.messageId];
        }
        contetStr = [contetStr stringByAppendingString:@" "];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:contetStr];
        NSTextAttachment * attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"cameraR"];
        attach.bounds = CGRectMake(0, -2.5, 23, 15);
        NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
        [att appendAttributedString:attrStringWithImage];
        self.contentLabel.attributedText = att;
    }
}

@end
