//
//  HMYuYueProjectCollectionViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/21.
//

#import <UIKit/UIKit.h>
#import "HMYuYueRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMYuYueProjectCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) HMYuYuefemaleAdditionalModel * model;

@end

NS_ASSUME_NONNULL_END
