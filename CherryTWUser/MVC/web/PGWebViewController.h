//
//  PGWebViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/11.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGWebViewController : PGBaseViewController

@property (nonatomic, copy) NSString * webTitleSrr;
@property (nonatomic, copy) NSString * htmlStr;
@property (nonatomic, assign) BOOL isRecharge;
@property (nonatomic, assign) BOOL isCallRecharge;

+(instancetype)controllerWithTitle:(NSString *)title url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
