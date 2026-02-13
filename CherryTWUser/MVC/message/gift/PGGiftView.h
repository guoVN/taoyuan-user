//
//  PGGiftView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/27.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "PGPageControl.h"
#import "PGRechargeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PGGiftView : UIView

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * topInsideView;
@property (nonatomic, strong) UIImageView * iconImg;
@property (nonatomic, strong) UILabel * diamondLabel;
@property (nonatomic, strong) UIButton * sendBtn;
@property (nonatomic, strong) TYCyclePagerView * pagerView;
@property (nonatomic, strong) PGPageControl * pageControl;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, copy) NSString * channelId;
@property (nonatomic, copy) void(^sendGiftBlock)(NSString * giftName);

@end

NS_ASSUME_NONNULL_END
