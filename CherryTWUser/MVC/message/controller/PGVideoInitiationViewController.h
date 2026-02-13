//
//  PGVideoInitiationViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/31.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGAnchorPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGVideoInitiationViewController : PGBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *hangUpBtn1;
@property (weak, nonatomic) IBOutlet QMUIButton *hangBtn2;
@property (weak, nonatomic) IBOutlet QMUIButton *answerBtn;
@property (nonatomic, strong) UIView * priceView;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) PGAnchorPriceModel * priceModel;

@property (nonatomic, assign) BOOL isSelfClick;
@property (nonatomic, copy) NSString * channelId;
///1-用户给主播接通,2-用户给主播打没接通,3-主播到用户回拨,接通和未接通都是
@property (nonatomic, assign) NSInteger callType;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, copy) NSString * anchorName;
@property (nonatomic, strong) UIImage * anchorHeadImg;
@property (nonatomic, assign) BOOL isVideoCard;
///1.接通，2.挂断
@property (nonatomic, copy) void(^acceptVideoBlock)(NSInteger type);

- (void)timeInvalidate;
- (void)removeNoti;

@end

NS_ASSUME_NONNULL_END
