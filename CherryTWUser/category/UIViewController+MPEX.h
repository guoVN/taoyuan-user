//
//  UIViewController+MPEX.h
//  CherryTWUser
//
//  Created by guo on 2024/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MPEX)

+ (UIViewController *)rootViewController;
+ (UIViewController *)currentViewController;
/// 获取顶部视图控制器
- (UIViewController *)currentViewController;
+ (UIViewController *)currentViewControllerForWindow:(UIWindow*)window;
/// 获取当前导航栏
- (UINavigationController *)currentNavigationController;
/// 便捷push到指定控制器
- (void)quickPushViewController:(UIViewController *)viewController
                       animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
