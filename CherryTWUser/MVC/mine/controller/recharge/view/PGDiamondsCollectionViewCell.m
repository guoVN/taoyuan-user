//
//  PGDiamondsCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGDiamondsCollectionViewCell.h"

@implementation PGDiamondsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCoinModel:(PGRechargeListCoinModel *)coinModel
{
    _coinModel = coinModel;
    self.numberLabel.text = [NSString stringWithFormat:@"%.0f",coinModel.coin*0.01];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %ld",coinModel.money];
}

@end
