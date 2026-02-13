//
//  HMPlayTypeChooseProjectCollectionViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/21.
//

#import <UIKit/UIKit.h>
#import "HMPlayTypeProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMPlayTypeChooseProjectCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;
@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;

@property (nonatomic, strong) HMPlayTypeProjectListModel * listModel;

@end

NS_ASSUME_NONNULL_END
