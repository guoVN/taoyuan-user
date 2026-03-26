//
//  PGRightAudioTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/29.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kShouldStopVoiceMessageNotification = @"kShouldStopVoiceMessageNotification";

@interface PGRightAudioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *audioImg;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioViewWC;
@property (weak, nonatomic) IBOutlet UIButton *faildBtn;

@property (nonatomic, strong) NSDictionary * msdDic;

@property (nonatomic, copy) void(^reSendMsgBlock)(void);

@end

NS_ASSUME_NONNULL_END
