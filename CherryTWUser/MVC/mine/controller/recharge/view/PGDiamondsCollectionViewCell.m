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
    self.numberLabel.text = [NSString stringWithFormat:@"%.0f + %.0f",coinModel.coin*0.1,coinModel.giveCoin*0.1];
    NSString * sendCoinStr = [NSString stringWithFormat:@"多送%.0f币",coinModel.giveCoin*0.1];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:sendCoinStr];
    NSRange range = [sendCoinStr rangeOfString:[NSString stringWithFormat:@"%.0f",coinModel.giveCoin*0.1]];
    [att addAttributes:@{NSForegroundColorAttributeName:THEAME_COLOR} range:range];
    self.sendLabel.attributedText = att;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %ld",coinModel.money];
}

@end
