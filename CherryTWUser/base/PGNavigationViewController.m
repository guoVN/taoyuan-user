//
//  PGNavigationViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import "PGNavigationViewController.h"

@interface PGNavigationViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@end

@implementation PGNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakself;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[MPImage(@"return") yd_originalRenderImage] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
        [viewController.navigationItem setLeftBarButtonItem:closeButton];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backAction:(id)sender {
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (navigationController.viewControllers.count == 1) {
            // 根视图：禁用手势并清空代理
            navigationController.interactivePopGestureRecognizer.enabled = NO;
            navigationController.interactivePopGestureRecognizer.delegate = nil;
        } else {
            // 非根视图：启用手势并恢复代理
            navigationController.interactivePopGestureRecognizer.enabled = YES;
            navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 当即将显示的控制器不是当前控制器时（即正在执行pop），强制关闭键盘
    if (navigationController.viewControllers.count < self.viewControllers.count) {
        [self.view endEditing:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 遍历触摸点的视图及其父视图，判断是否属于键盘相关视图
    UIView *touchView = touch.view;
    while (touchView) {
        NSString *className = NSStringFromClass([touchView class]);
        // 匹配常见的键盘视图类名
        if ([className containsString:@"UIInput"] ||
            [className containsString:@"Keyboard"] ||
            [className containsString:@"UIPeripheralHostView"]) {
            return NO;
        }
        touchView = touchView.superview;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 根视图不允许右滑
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
        // 允许手势前强制关闭键盘，避免动画冲突
        [self.view endEditing:YES];
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
