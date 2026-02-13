//
//  PGPersonalProjectCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/10/23.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGPersonalProjectCollectionViewCell.h"

@implementation PGPersonalProjectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMenuModel:(PGYuYuefemaleAdditionalModel *)menuModel
{
    _menuModel = menuModel;
    self.titleLabel.text = menuModel.configName;
    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString:menuModel.pic]];
    self.giftNameLabel.text = [NSString stringWithFormat:@"%@x1",menuModel.name];
}

@end
