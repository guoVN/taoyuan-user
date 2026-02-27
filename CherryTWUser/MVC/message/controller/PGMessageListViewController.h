//
//  PGMessageListViewController.h
//  CherryTWUser
//
//  Created by guo on 2026/2/27.
//  Copyright © 2026 guo. All rights reserved.
//

#import "PGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGMessageListViewController : PGBaseViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray * imResultArr;
@property (nonatomic, strong) NSMutableArray * intimacyResultArr;
@property (nonatomic, strong) NSMutableArray * qinmiDataArray;

@end

NS_ASSUME_NONNULL_END
