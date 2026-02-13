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

@property (nonatomic, copy) NSString * messageId;
@property (nonatomic, strong) NSDictionary * msdDic;

@end

NS_ASSUME_NONNULL_END
