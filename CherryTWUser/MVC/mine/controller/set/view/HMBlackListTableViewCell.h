//
//  HMBlackListTableViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/8/30.
//

#import <UIKit/UIKit.h>
#import "HMBlackListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMBlackListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

@property (nonatomic, strong) HMBlackListModel * listModel;

@property (nonatomic, copy) void(^unBindBlock)(void);

@end

NS_ASSUME_NONNULL_END
