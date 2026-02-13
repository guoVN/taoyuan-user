//
//  PGRechargeViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGRechargeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGRechargeViewController : PGBaseViewController

@property (nonatomic, strong) PGRechargeListCoinModel * coinModel;
@property (nonatomic, assign) BOOL isCallRecharge;

@end

NS_ASSUME_NONNULL_END
