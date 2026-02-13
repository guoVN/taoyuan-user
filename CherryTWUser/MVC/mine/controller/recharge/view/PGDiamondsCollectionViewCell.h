//
//  PGDiamondsCollectionViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGRechargeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGDiamondsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) PGRechargeListCoinModel * coinModel;

@end

NS_ASSUME_NONNULL_END
