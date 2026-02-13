//
//  HMPersonalInfoEditInfoTableViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMPersonalInfoEditInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImgLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descRC;
@property (weak, nonatomic) IBOutlet UIView *biaoqianView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) NSIndexPath * indexPath;

@end

NS_ASSUME_NONNULL_END
