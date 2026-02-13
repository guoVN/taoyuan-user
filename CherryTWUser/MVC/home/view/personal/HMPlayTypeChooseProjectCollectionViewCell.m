//
//  HMPlayTypeChooseProjectCollectionViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/21.
//

#import "HMPlayTypeChooseProjectCollectionViewCell.h"

@implementation HMPlayTypeChooseProjectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(HMPlayTypeProjectListModel *)listModel
{
    _listModel = listModel;
    self.titleLabel.text = listModel.configName;
    self.diamondLabel.text = [PGUtils formatNumber:listModel.giftCoin/100];
}

@end
