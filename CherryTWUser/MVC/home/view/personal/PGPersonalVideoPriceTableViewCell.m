//
//  PGPersonalVideoPriceTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/11/16.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGPersonalVideoPriceTableViewCell.h"

@implementation PGPersonalVideoPriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupTopShadowWithCustomView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailModel:(PGAnchorModel *)detailModel
{
    _detailModel = detailModel;
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    UIImage * resultImg = MPImage(@"diamonds");
    attach.image = resultImg;
    attach.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSTextAttachment * chatAttach = [[NSTextAttachment alloc] init];
    UIImage * chatResultImg = MPImage(@"wordIcon");
    chatAttach.image = chatResultImg;
    chatAttach.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString * chatAttrStringWithImage = [NSAttributedString attributedStringWithAttachment:chatAttach];
    NSString * chatStr = [NSString stringWithFormat:@" %ld/条",[detailModel.textChatCoin integerValue]/10];
    NSMutableAttributedString * chatAtt = [[NSMutableAttributedString alloc] initWithString:chatStr];
    [chatAtt insertAttributedString:chatAttrStringWithImage atIndex:0];
    [chatAtt insertAttributedString:attrStringWithImage atIndex:chatStr.length-1];
    [self.videoPriceBtnOne setAttributedTitle:chatAtt forState:UIControlStateNormal];
    
    NSTextAttachment * voiceAttach = [[NSTextAttachment alloc] init];
    UIImage * voiceResultImg = MPImage(@"voice");
    voiceAttach.image = voiceResultImg;
    voiceAttach.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString * voiceAttrStringWithImage = [NSAttributedString attributedStringWithAttachment:voiceAttach];
    NSString * voiceStr = [NSString stringWithFormat:@" %ld/min",[detailModel.voiceCoin integerValue]/10];
    NSMutableAttributedString * voiceAtt = [[NSMutableAttributedString alloc] initWithString:voiceStr];
    [voiceAtt insertAttributedString:voiceAttrStringWithImage atIndex:0];
    [voiceAtt insertAttributedString:attrStringWithImage atIndex:voiceStr.length-3];
    [self.videoPriceBtnTwo setAttributedTitle:voiceAtt forState:UIControlStateNormal];
    
    NSTextAttachment * videoAttach = [[NSTextAttachment alloc] init];
    UIImage * videoResultImg = MPImage(@"videocall");
    videoAttach.image = videoResultImg;
    videoAttach.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString * videoAttrStringWithImage = [NSAttributedString attributedStringWithAttachment:videoAttach];
    NSString * videoStr = [NSString stringWithFormat:@" %ld/min",[detailModel.videoCoin integerValue]/10];
    NSMutableAttributedString * videoAtt = [[NSMutableAttributedString alloc] initWithString:videoStr];
    [videoAtt insertAttributedString:videoAttrStringWithImage atIndex:0];
    [videoAtt insertAttributedString:attrStringWithImage atIndex:videoStr.length-3];
    [self.videoPriceBtnThree setAttributedTitle:videoAtt forState:UIControlStateNormal];
}

@end
