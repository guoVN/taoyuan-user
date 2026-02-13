//
//  PGDynamicNoticeModel.h
//  CherryTWUser
//
//  Created by guo on 2025/1/1.
//  Copyright © 2025 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGDynamicNoticeModel : NSObject

@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, assign) NSInteger isShow;
@property (nonatomic, assign) NSInteger dynamicid;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * fileType;
@property (nonatomic, copy) NSString * photoUrl;
@property (nonatomic, copy) NSString * videoUrl;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * nickName;

@end

NS_ASSUME_NONNULL_END
