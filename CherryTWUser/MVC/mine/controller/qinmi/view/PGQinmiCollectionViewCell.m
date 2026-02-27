//
//  PGQinmiCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2026/2/27.
//  Copyright © 2026 guo. All rights reserved.
//

#import "PGQinmiCollectionViewCell.h"

@implementation PGQinmiCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(HMIntimacyListModel *)listModel
{
    _listModel = listModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:listModel.photo] placeholderImage:MPImage(@"womanDefault")];
    self.nameLabel.text = listModel.nickName;
    [self.qinmiduBtn setTitle:[NSString stringWithFormat:@"%@℃",listModel.intimacy] forState:UIControlStateNormal];
}

@end
