//
//  PGVideoCallViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/18.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGAnchorPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGVideoCallViewController : PGBaseViewController

@property (nonatomic, copy) NSString * channelId;
///1-用户给主播接通,2-用户给主播打没接通,3-主播到用户回拨,接通和未接通都是
@property (nonatomic, assign) NSInteger callType;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, copy) NSString * anchorName;
@property (nonatomic, copy) NSString * anchorHeadStr;
@property (nonatomic, strong) UIImage * anchorHeadImg;
@property (nonatomic, assign) BOOL isVideoCard;
@property (nonatomic, strong) PGAnchorPriceModel * priceModel;

///通话时长
@property (nonatomic, copy) NSString * callDuration;

@end

NS_ASSUME_NONNULL_END
