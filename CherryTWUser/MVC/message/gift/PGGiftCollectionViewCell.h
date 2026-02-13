//
//  PGGiftCollectionViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/28.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGGiftCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSArray * giftArr;
@property (nonatomic, assign) NSInteger index;

- (void)refreshGiftChoose:(NSInteger)tagIndex;

@end

NS_ASSUME_NONNULL_END
