//
//  PGPersonalYuYueAlertCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/11/2.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGPersonalYuYueAlertCollectionViewCell.h"

@implementation PGPersonalYuYueAlertCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.diamondBtn.imagePosition = QMUIButtonImagePositionRight;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
}
- (void)setDetailModel:(PGAnchorModel *)detailModel
{
    _detailModel = detailModel;
    switch (self.index) {
        case 0:
            [self.diamondBtn setTitle:[NSString stringWithFormat:@"%ld",[detailModel.textChatCoin integerValue]/100] forState:UIControlStateNormal];
            self.timeLabel.text = @"10分钟";
            break;
        case 1:
            [self.diamondBtn setTitle:[NSString stringWithFormat:@"%ld",[detailModel.voiceCoin integerValue]/100] forState:UIControlStateNormal];
            self.timeLabel.text = @"20分钟";
            break;
        case 2:
            [self.diamondBtn setTitle:[NSString stringWithFormat:@"%ld",[detailModel.videoCoin integerValue]/100] forState:UIControlStateNormal];
            self.timeLabel.text = @"30分钟";
            break;
        default:
            break;
    }
}

@end
