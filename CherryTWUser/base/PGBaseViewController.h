//
//  PGBaseViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import <UIKit/UIKit.h>
#import "PGBaseNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGBaseViewController : UIViewController

@property (nonatomic, strong) PGBaseNavigationView * naviView;
@property (nonatomic, copy) NSString * titleBtnStr;
@property (nonatomic, copy) NSString * titleStr;
@property (nonatomic, strong) QMUIEmptyView * emptyView;

//通过控制器类,初始化控制器,并push
- (void)pushViewController:(Class)controllerClass;

//pop到指定的控制器
- (void)popToViewController:(Class)controllerClass;

// 暂无数据空白页
- (void)setupEmptyView;
- (void)showEmptyView:(BOOL)show;
- (void)showEmptyView;
- (void)hideEmptyView;
- (void)showEmptyViewWithText:(nullable NSString *)text
                   detailText:(nullable NSString *)detailText
                  buttonTitle:(nullable NSString *)buttonTitle
                 buttonAction:(nullable SEL)action;

@end

NS_ASSUME_NONNULL_END
