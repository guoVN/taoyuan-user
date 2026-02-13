//
//  PGNavigationViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import "PGNavigationViewController.h"

@interface PGNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation PGNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置右滑返回手势的代理为自身
    self.delegate = self;
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakself;
    }

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.viewControllers.count>0){
        // 返回箭头
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[MPImage(@"return") yd_originalRenderImage] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
        [viewController.navigationItem setLeftBarButtonItem:closeButton];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backAction:(id)sender {
    [self popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        NSString * className = NSStringFromClass([navigationController.viewControllers.lastObject class]);
        if (navigationController.viewControllers.count == 1)
        {
            //根视图控制器关闭手势返回
            navigationController.interactivePopGestureRecognizer.enabled = NO;
            navigationController.interactivePopGestureRecognizer.delegate = nil;
        }else
        {
            //其他的页面默认开启手势返回
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
//        NSLog(@"**************************************1,%@",className);
    }
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        //屏蔽调用rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    //这里就是非右滑手势调用的方法啦，统一允许激活
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
