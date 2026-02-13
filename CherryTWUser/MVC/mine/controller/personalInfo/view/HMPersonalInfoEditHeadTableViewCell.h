//
//  HMPersonalInfoEditHeadTableViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMPersonalInfoEditHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)headImgClick;

@end

NS_ASSUME_NONNULL_END
