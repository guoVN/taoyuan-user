//
//  HMGiftView.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMGiftView : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * totalDiamondLabel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic, copy) NSString * channelId;
@property (nonatomic, copy) void(^sendGiftBlock)(NSString * giftName);

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
