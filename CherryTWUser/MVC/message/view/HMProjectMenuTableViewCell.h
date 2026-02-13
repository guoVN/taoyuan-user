//
//  HMProjectMenuTableViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMProjectMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftImg;

@end

NS_ASSUME_NONNULL_END
