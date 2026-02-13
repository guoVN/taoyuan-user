//
//  PGTabbarViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGTabbarViewController : UITabBarController

- (void)showSvga:(NSString *)svgaUrl;
- (void)setCustomBadgeValue:(NSString *)value atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
