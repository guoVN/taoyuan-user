//
//  HMQinmiTableViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/9/24.
//

#import <UIKit/UIKit.h>
#import "HMIntimacyListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMQinmiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *topBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *qinmiBtn;
@property (weak, nonatomic) IBOutlet UIView *onlineView;

@property (nonatomic, strong) NSArray * qinmiIMArr;
@property (nonatomic, strong) HMIntimacyListModel * qinModel;
@property (nonatomic, strong) NSDictionary * qinmiOnlineDic;

@end

NS_ASSUME_NONNULL_END
