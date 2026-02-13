//
//  HMMsgTableViewCell.h
//  CherryTWanchor
//
//  Created by guo on 2025/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *onlineView;

@property (nonatomic, strong) AgoraChatConversation * model;
@property (nonatomic, strong) NSDictionary * imOnlineDic;

@end

NS_ASSUME_NONNULL_END
