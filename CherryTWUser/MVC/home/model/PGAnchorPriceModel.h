//
//  PGAnchorPriceModel.h
//  CherryTWUser
//
//  Created by guo on 2025/2/6.
//  Copyright © 2025 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGAnchorPriceModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger voice;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger video;
@property (nonatomic, assign) NSInteger text;

@end

NS_ASSUME_NONNULL_END
