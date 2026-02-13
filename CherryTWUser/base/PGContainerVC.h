//
//  PGContainerVC.h
//  CherryTWUser
//
//  Created by guo on 2025/10/22.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGFloatingTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGContainerVC : PGBaseViewController

@property (nonatomic, strong) PGFloatingTabBar *floatingTabBar;

- (void)showSvga:(NSString *)svgaUrl;

@end

NS_ASSUME_NONNULL_END
