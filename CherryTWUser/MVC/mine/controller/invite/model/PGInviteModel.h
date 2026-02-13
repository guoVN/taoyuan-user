//
//  PGInviteModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/26.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PGInviteChinnelBindModel;
@interface PGInviteModel : NSObject

@property (nonatomic, strong) NSArray<PGInviteChinnelBindModel *> * womanChannelBindDTOS;
@property (nonatomic, copy) NSString * invitationCode;
@property (nonatomic, copy) NSString * inviteUserPercent;
@property (nonatomic, copy) NSString * invitationLandingPageLink;
@property (nonatomic, assign) NSInteger coin;

@end

@interface PGInviteChinnelBindModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger allowEachGift;
@property (nonatomic, assign) NSInteger bindGiftBatch;
@property (nonatomic, copy) NSString * invitationDownloadAppLink;
@property (nonatomic, copy) NSString * invitationDownloadAppLinkWomen;
@property (nonatomic, copy) NSString * invitationLandingPageLink;

@end

NS_ASSUME_NONNULL_END
