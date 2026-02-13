//
//  PGGiftCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/28.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGGiftCollectionViewCell.h"
#import "PGRechargeListModel.h"

@implementation PGGiftCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setGiftArr:(NSArray *)giftArr
{
    _giftArr = giftArr;
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    for (NSInteger i=0; i<self.giftArr.count; i++) {
        PGGiftListModel * model = self.giftArr[i];
        UIButton * giftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(8+(i%4)*(ScreenWidth-16)*0.25, 19+i/4*(104+33), (ScreenWidth-16)*0.25, 104)];
        giftBackBtn.tag = model.ID;
        [giftBackBtn setBackgroundImage:MPImage(@"") forState:UIControlStateNormal];
        [giftBackBtn setBackgroundImage:MPImage(@"giftFrame") forState:UIControlStateSelected];
        [giftBackBtn addTarget:self action:@selector(chooseGiftAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:giftBackBtn];
        UIImageView * giftIcon = [[UIImageView alloc] init];
        [giftIcon sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:MPImage(@"netFaild")];
        [giftBackBtn addSubview:giftIcon];
        [giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(6);
            make.width.height.mas_equalTo(48);
        }];
        UILabel * nameLabel = [[UILabel alloc] init];
        nameLabel.font = MPBoldFont(12);
        nameLabel.textColor = HEX(#FFFFFF);
        nameLabel.text = model.name;
        [giftBackBtn addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(giftIcon.mas_bottom).offset(9);
            make.centerX.mas_equalTo(0);
        }];
        QMUIButton * diamondBtn = [[QMUIButton alloc] init];
        diamondBtn.imagePosition = QMUIButtonImagePositionLeft;
        diamondBtn.spacingBetweenImageAndTitle = 0;
        [diamondBtn setImage:MPImage(@"zuanshiLittle") forState:UIControlStateNormal];
        [diamondBtn setTitle:[NSString stringWithFormat:@"%.0f",model.coin*0.01] forState:UIControlStateNormal];
        [diamondBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        diamondBtn.titleLabel.font = MPBoldFont(10);
        [giftBackBtn addSubview:diamondBtn];
        [diamondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(2);
            make.centerX.mas_equalTo(0);
        }];
    }
}
- (void)setIndex:(NSInteger)index
{
    _index = index;
//    NSInteger i = 0;
//    for (UIButton * btn in self.contentView.subviews) {
//        btn.tag = index*100+i+10;
//        i++;
//    }
}

- (void)chooseGiftAction:(UIButton *)sender
{
    [PGManager shareModel].currentChooseGiftTag = sender.tag;
    for (PGGiftListModel * model in self.giftArr) {
        if (model.ID == sender.tag) {
            [PGManager shareModel].currentChooseGiftModel = model;
        }
    }
    [self refreshGiftChoose:sender.tag];
}
- (void)refreshGiftChoose:(NSInteger)tagIndex
{
    for (UIButton * btn in self.contentView.subviews) {
        if (btn.tag == tagIndex) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}

@end
