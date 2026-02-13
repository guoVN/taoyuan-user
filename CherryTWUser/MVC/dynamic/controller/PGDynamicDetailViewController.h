//
//  PGDynamicDetailViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGDynamicDetailViewController : PGBaseViewController

@property (nonatomic, strong) PGAnchorDynamicModel * detailModel;
@property (nonatomic, strong) NSArray * noticeArray;

@end

NS_ASSUME_NONNULL_END
