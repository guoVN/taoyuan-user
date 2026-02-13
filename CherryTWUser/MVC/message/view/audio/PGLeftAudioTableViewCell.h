//
//  PGLeftAudioTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/29.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGLeftAudioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *audioImg;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioViewWC;

@property (nonatomic, copy) NSString * channelId;
@property (nonatomic, copy) NSString * friendHead;
@property (nonatomic, strong) NSDictionary * msdDic;

@end

NS_ASSUME_NONNULL_END
