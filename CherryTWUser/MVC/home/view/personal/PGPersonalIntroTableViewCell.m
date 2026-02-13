//
//  PGPersonalIntroTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/11/16.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGPersonalIntroTableViewCell.h"

@implementation PGPersonalIntroTableViewCell

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
    self.introLabel.text = detailModel.personalSign;
}

@end
