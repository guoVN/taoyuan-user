//
//  HMPlayTypeUpdatePriceCollectionViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/21.
//

#import "HMPlayTypeUpdatePriceCollectionViewCell.h"

@implementation HMPlayTypeUpdatePriceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.chooseBtn acs_radiusWithRadius:5 corner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
}

- (void)setGiftModel:(PGGiftListModel *)giftModel
{
    _giftModel = giftModel;
    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString:giftModel.pic] placeholderImage:MPImage(@"netFaild")];
    [self.chooseGiftIcon sd_setImageWithURL:[NSURL URLWithString:giftModel.pic] placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = giftModel.name;
    
    NSString * str = [NSString stringWithFormat:@"%.0f ",giftModel.coin*0.01];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:str];
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"diamonds"];
    attach.bounds = CGRectMake(0, -1, 12, 12);
    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
    [att appendAttributedString:attrStringWithImage];
    self.coinLabel.attributedText = att;
    self.chooseCoinLabel.attributedText = att;
}
- (IBAction)chooseBtnAction:(id)sender {
    if (self.chooseBlock) {
        self.chooseBlock(self.giftModel);
    }
}

@end
