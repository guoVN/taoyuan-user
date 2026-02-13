//
//  PGInviteFriendPosterCollectionViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGColorfulQRCodeView.h"
#import "PGQRCodeTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGInviteFriendPosterCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLabel;
@property (nonatomic, strong) PGColorfulQRCodeView * ColorImageView;

@property (nonatomic, copy) NSString * codeStr;
@property (nonatomic, copy) NSString * linkUrl;

@end

NS_ASSUME_NONNULL_END
