//
//  UIViewController+MPEX.m
//  CherryTWUser
//
//  Created by guo on 2024/4/9.
//

#import "UIViewController+MPEX.h"

@implementation UIViewController (MPEX)

+ (UIViewController *)rootViewController
{
    
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return rootViewController;
}

+ (UIViewController *)currentViewController
{
    return [self currentViewControllerForWindow:[UIApplication sharedApplication].delegate.window];
}

+(UIViewController *)currentViewControllerForWindow:(UIWindow *)window {
    UIViewController *rootViewController = window.rootViewController;
    return [rootViewController currentViewController];
}


- (UIViewController *)currentViewController {
    UIViewController *topViewController = self;
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    if([topViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabVC = (UITabBarController*)topViewController;
        UIViewController* selectedVC = tabVC.selectedViewController;
        if([selectedVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navVC = (UINavigationController*)selectedVC;
            topViewController = [navVC.childViewControllers lastObject];
        }
        else {
            topViewController = selectedVC;
        }
    }
    else if([topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navVC = (UINavigationController*)topViewController;
        topViewController = [navVC.childViewControllers lastObject];
    }
    return topViewController;
}

- (UINavigationController *)currentNavigationController
{
    UINavigationController* navigationController = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        navigationController = (id)self;
    }
    else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            navigationController = ((UITabBarController*)self).selectedViewController.currentNavigationController;
        }
        else {
            navigationController = self.navigationController;
        }
    }
    return navigationController;
}

- (void)quickPushViewController:(UIViewController *)viewController
                       animated:(BOOL)animated
{
    if([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabVC = (UITabBarController*)self;
        UIViewController* selectedVC = tabVC.selectedViewController;
        [selectedVC quickPushViewController:viewController animated:animated];
    }
    else if([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navVC = (UINavigationController*)self;
        UIViewController* lastVC = [navVC.childViewControllers lastObject];
        [lastVC quickPushViewController:viewController animated:animated];
    }
    else {
        [self.view endEditing:YES];
        if(self.navigationController) {
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:animated];
        }
        else if(self.parentViewController) {
            [self.parentViewController quickPushViewController:viewController animated:animated];
        }
    }
}

@end
