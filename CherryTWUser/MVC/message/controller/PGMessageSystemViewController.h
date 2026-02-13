//
//  PGMessageSystemViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/16.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGMessageListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGMessageSystemViewController : PGBaseViewController

@property (nonatomic, strong) PGMessageListModel * listModel;

@end

NS_ASSUME_NONNULL_END
