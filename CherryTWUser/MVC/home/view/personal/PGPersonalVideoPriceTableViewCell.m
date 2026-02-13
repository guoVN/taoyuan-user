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
    [self.videoPriceBtnOne setTitle:[NSString stringWithFormat:@"%ld/10分钟",[detailModel.textChatCoin integerValue]/100] forState:UIControlStateNormal];
    [self.videoPriceBtnTwo setTitle:[NSString stringWithFormat:@"%ld/20分钟",[detailModel.voiceCoin integerValue]/100] forState:UIControlStateNormal];
    [self.videoPriceBtnThree setTitle:[NSString stringWithFormat:@"%ld/30分钟",[detailModel.videoCoin integerValue]/100] forState:UIControlStateNormal];
}

@end
