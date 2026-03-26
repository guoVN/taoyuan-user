//
//  PGChatRightTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/12.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGChatRightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIView *contentShowView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *faildBtn;

@property (nonatomic, copy) NSString * messageId;
@property (nonatomic, strong) NSDictionary * msdDic;

@property (nonatomic, copy) void(^reSendMsgBlock)(void);

@end

NS_ASSUME_NONNULL_END
