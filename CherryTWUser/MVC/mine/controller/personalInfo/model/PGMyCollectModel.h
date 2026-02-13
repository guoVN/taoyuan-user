//
//  PGMyCollectModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/17.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGMyCollectModel : NSObject

@property (nonatomic, copy) NSString * height;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger virtualAnchorMappingId;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString * lookTime;
@property (nonatomic, copy) NSString * photoUrl;
@property (nonatomic, assign) NSInteger isAttention;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * emotionState;

@end

NS_ASSUME_NONNULL_END
