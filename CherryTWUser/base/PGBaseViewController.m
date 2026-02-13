//
//  PGBaseViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import "PGBaseViewController.h"

@interface PGBaseViewController ()

@property (nonatomic, strong) id oldNavGesDelegate;

@end

@implementation PGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self setCustom];
}
- (void)setCustom
{
    self.naviView = [[PGBaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, STATUS_H_F+44)];
    [self.view addSubview:self.naviView];
}
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.naviView.titleLabel.text = titleStr;
}
- (void)setTitleBtnStr:(NSString *)titleBtnStr
{
    _titleBtnStr = titleBtnStr;
    [self.naviView.titleBtn setTitle:titleBtnStr forState:UIControlStateNormal];
    [self.naviView.titleBtn setImage:MPImage(@"curved") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.oldNavGesDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self.oldNavGesDelegate;
}

- (void)pushViewController:(Class)controllerClass {
    [self.navigationController pushViewController:[[controllerClass alloc] init] animated:YES];
}

- (void)popToViewController:(Class)controllerClass {
    for (int i = 0; i < self.navigationController.childViewControllers.count; i++) {
        UIViewController *controller = self.navigationController.childViewControllers[i];
        if ([controller isKindOfClass:controllerClass]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

#pragma mark - 首次无数据且没有网络提示
- (void)setupEmptyView {
    self.emptyView.userInteractionEnabled = NO;
    self.emptyView.imageViewInsets = UIEdgeInsetsMake(0, 0, 16, 0);
    self.emptyView.loadingViewInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.emptyView.verticalOffset = -60;
    [self.emptyView setImage:[UIImage imageNamed:@"empty"]];
    [self.emptyView setTextLabelText:@"暂无数据"];
    [self.emptyView setLoadingViewHidden:YES];
    self.emptyView.textLabelFont = MPBoldFont(16);
    self.emptyView.textLabelTextColor = HEX(#999999);
    [self showEmptyView];
    self.emptyView.hidden = YES;
}

- (void)showEmptyView:(BOOL)show {
    if (show) {
        [self showEmptyView];
    } else {
        [self hideEmptyView];
    }
}

- (void)showEmptyView
{
    [self.view addSubview:self.emptyView];
}
- (void)hideEmptyView
{
    [self.emptyView removeFromSuperview];
}
- (void)showEmptyViewWithText:(nullable NSString *)text
                   detailText:(nullable NSString *)detailText
                  buttonTitle:(nullable NSString *)buttonTitle
                 buttonAction:(nullable SEL)action
{
    [self showEmptyViewWithLoading:NO image:nil text:text detailText:detailText buttonTitle:buttonTitle buttonAction:action];
}
- (void)showEmptyViewWithLoading:(BOOL)showLoading
                           image:(UIImage *)image
                            text:(NSString *)text
                      detailText:(NSString *)detailText
                     buttonTitle:(NSString *)buttonTitle
                    buttonAction:(SEL)action {
    [self showEmptyView];
    [self.emptyView setLoadingViewHidden:!showLoading];
    [self.emptyView setImage:image];
    [self.emptyView setTextLabelText:text];
    [self.emptyView setDetailTextLabelText:detailText];
    [self.emptyView setActionButtonTitle:buttonTitle];
    [self.emptyView.actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.emptyView.actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}
- (QMUIEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[QMUIEmptyView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height)];
    }
    return _emptyView;
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
