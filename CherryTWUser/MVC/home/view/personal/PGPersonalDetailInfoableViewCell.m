//
//  PGPersonalDetailInfoableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGPersonalDetailInfoableViewCell.h"

@implementation PGPersonalDetailInfoableViewCell

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
    self.IDLabel.text = [NSString stringWithFormat:@"%ld",detailModel.userid];
    self.tallLabel.text = [NSString stringWithFormat:@"%@cm %@-cup",detailModel.height,detailModel.cup];
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁",detailModel.age];
//    switch ([detailModel.appearance integerValue]) {
//        case 1:
//            self.looksLevelLabel.text = @"A级";
//            break;
//        case 2:
//            self.looksLevelLabel.text = @"S级";
//            break;
//        case 3:
//            self.looksLevelLabel.text = @"SS级";
//            break;
//        case 4:
//            self.looksLevelLabel.text = @"网红级";
//            break;
//        default:
//            break;
//    }
    self.looksLevelLabel.text = detailModel.job;
    self.purposeLabel.text = detailModel.personalSign;
}

@end
