//
//  HMYuYueProjectCollectionViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/21.
//

#import "HMYuYueProjectCollectionViewCell.h"

@implementation HMYuYueProjectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HMYuYuefemaleAdditionalModel *)model
{
    _model = model;
    self.titleLabel.text = model.configName;
}

@end
