//
//  HMPlayTypeUpdatePriceCollectionViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMPlayTypeUpdatePriceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *giftIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseGiftIcon;
@property (weak, nonatomic) IBOutlet UILabel *chooseCoinLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


@property (nonatomic, strong) PGGiftListModel * giftModel;
@property (nonatomic, copy) void(^chooseBlock)(PGGiftListModel * chooseModel);

@end

NS_ASSUME_NONNULL_END
