//
//  HMYuYueListCollectionViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/13.
//

#import <UIKit/UIKit.h>
#import "PGYuYueModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMYuYueListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *redView;

@property (nonatomic, strong) PGYuYueDataModelTimeModel * timeModel;

@end

NS_ASSUME_NONNULL_END
