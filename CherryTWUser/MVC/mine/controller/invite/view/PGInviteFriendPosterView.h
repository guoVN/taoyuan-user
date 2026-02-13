//
//  PGInviteFriendPosterView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "PGPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGInviteFriendPosterView : UIView

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) TYCyclePagerView * pagerView;
@property (nonatomic, strong) PGPageControl * pageControl;
@property (nonatomic, strong) QMUIButton * saveBtn;
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, copy) NSString * inviteCode;
@property (nonatomic, copy) NSString * linkUrl;

@end

NS_ASSUME_NONNULL_END
