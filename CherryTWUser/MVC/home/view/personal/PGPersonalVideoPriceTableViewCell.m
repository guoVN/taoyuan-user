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
    NSString * videoStr = [NSString stringWithFormat:@"视频%ld/min",[detailModel.videoCoin integerValue]/10];
    NSMutableAttributedString * vodeoAtt = [[NSMutableAttributedString alloc] initWithString:videoStr];
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    UIImage * resultImg = MPImage(@"diamonds");
    attach.image = resultImg;
    attach.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
    [vodeoAtt insertAttributedString:attrStringWithImage atIndex:videoStr.length-4];
    [self.videoPriceBtnOne setAttributedTitle:vodeoAtt forState:UIControlStateNormal];
    
    NSString * voiceStr = [NSString stringWithFormat:@"语音%ld/min",[detailModel.voiceCoin integerValue]/10];
    NSMutableAttributedString * voiceAtt = [[NSMutableAttributedString alloc] initWithString:voiceStr];
    [voiceAtt insertAttributedString:attrStringWithImage atIndex:voiceStr.length-4];
    [self.videoPriceBtnTwo setAttributedTitle:voiceAtt forState:UIControlStateNormal];
}

@end
