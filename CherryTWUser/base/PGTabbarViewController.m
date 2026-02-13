//
//  PGTabbarViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import "PGTabbarViewController.h"
#import "PGNavigationViewController.h"
#import "PGHomeViewController.h"
#import "PGDynamicViewController.h"
#import "PGMessageViewController.h"
#import "PGMineViewController.h"
#import <SVGAParser.h>
#import <SVGAPlayer.h>
//model
#import "PGMessageListModel.h"

#define kCustomBadgeTagBase 1000

@interface PGTabbarViewController ()<SVGAPlayerDelegate>

@property (nonatomic, strong) SVGAPlayer * svgaPlayer;
@property (nonatomic, strong) SVGAParser * svgaParser;
@property (nonatomic, strong) UIView * boScreenView;
@property (nonatomic, strong) UILabel * tipsLabel;

@end

@implementation PGTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UUWhite;
    self.tabBar.backgroundImage = [UIImage yd_imageWithColor:UUWhite];
    self.tabBar.shadowImage = [UIImage yd_imageWithColor:UUWhite];
    [self setupUI];
    // 监听录屏状态变化
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(screenCaptureChanged)
                                                     name:UIScreenCapturedDidChangeNotification
                                                   object:nil];
        
        // 监听截屏通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidTakeScreenshot)
                                                     name:UIApplicationUserDidTakeScreenshotNotification
                                                   object:nil];
}

- (void)screenCaptureChanged {
    if ([UIScreen mainScreen].isCaptured) {
        if (![PGManager shareModel].isRecordScreen) {
            NSLog(@"录屏被禁止！");
            // 执行相关操作，例如隐藏敏感内容或提示用户
            self.tipsLabel.text = @"由于该应用限制，涉及隐私/版权的界面不允许录屏";
            [[UIApplication sharedApplication].delegate.window addSubview:self.boScreenView];
        }
    }else{
        [self.boScreenView removeFromSuperview];
    }
}
- (void)userDidTakeScreenshot {
    if (![PGManager shareModel].isRecordScreen) {
        NSLog(@"截屏被禁止！");
        // 执行相关操作，例如提示用户或隐藏敏感内容
        [[UIApplication sharedApplication].delegate.window addSubview:self.boScreenView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.boScreenView removeFromSuperview];
        });
    }
}

- (void)setupUI {
    PGHomeViewController * vc1 = [[PGHomeViewController alloc] init];
    PGNavigationViewController * nav1 = [[PGNavigationViewController alloc] initWithRootViewController:vc1];
    nav1.tabBarItem.title = @"首页";
    nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_ed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    PGDynamicViewController * vc2 = [[PGDynamicViewController alloc] init];
    PGNavigationViewController * nav2 = [[PGNavigationViewController alloc] initWithRootViewController:vc2];
    nav2.tabBarItem.title = @"动态";
    nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"dynamic_ed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.image = [[UIImage imageNamed:@"dynamic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    PGMessageViewController * vc3 = [[PGMessageViewController alloc] init];
    PGNavigationViewController * nav3 = [[PGNavigationViewController alloc] initWithRootViewController:vc3];
    nav3.tabBarItem.title = @"消息";
    nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"message_ed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.image = [[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.badgeColor = HEX(#FF5050);
    
    PGMineViewController * vc4 = [[PGMineViewController alloc] init];
    PGNavigationViewController * nav4 = [[PGNavigationViewController alloc] initWithRootViewController:vc4];
    nav4.tabBarItem.title = @"我的";
    nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"mine_ed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.image = [[UIImage imageNamed:@"mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    NSArray *controllerArray = @[nav1,nav2,nav3,nav4];
    self.viewControllers = controllerArray;

    UITabBar *tabBar = [UITabBar appearance];
    [tabBar setBarTintColor:HEX(#505050)];
    tabBar.translucent = YES;

    [[UITabBar appearance] setBackgroundColor:HEX(#FFFFFF)];
    [[UITabBar appearance] setUnselectedItemTintColor:HEX(#505050)];
    [[UITabBar appearance] setTintColor:THEAME_COLOR];
    //设置不被选中时的文字颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]} forState:UIControlStateNormal];
    //设置被选中时的文字颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    self.selectedIndex = 0;

}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
    
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.18;
//    pulse.repeatCount= 1;//动画重复次数
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.918];
    pulse.toValue= [NSNumber numberWithFloat:1];
    UIView * currentTabbarButton = tabbarbuttonArray[index];
    [[currentTabbarButton layer]
     addAnimation:pulse forKey:nil];
}

#pragma mark - 自定义角标管理
- (void)setCustomBadgeValue:(NSString *)value atIndex:(NSInteger)index {
    if (index >= self.tabBar.items.count) return;
    if (value == nil) {
        [self removeCustomBadgeAtIndex:index];
        return;
    }
    // 先移除现有的自定义角标
    [self removeCustomBadgeAtIndex:index];
    
    // 隐藏系统角标
    UITabBarItem *item = self.tabBar.items[index];
    item.badgeValue = nil;
    
    // 获取对应的tab bar button
    UIView *tabBarButton = [self getTabBarButtonAtIndex:index];
    if (!tabBarButton) return;
    
    // 创建自定义角标
    UILabel *customBadge = [[UILabel alloc] init];
    customBadge.text = value;
    customBadge.textColor = [UIColor clearColor];
    customBadge.backgroundColor = [UIColor redColor];
    customBadge.textAlignment = NSTextAlignmentCenter;
    customBadge.font = [UIFont boldSystemFontOfSize:10];
    
    // 根据内容调整尺寸
    CGSize badgeSize = [self calculateBadgeSizeForValue:value];
    customBadge.frame = CGRectMake(
        tabBarButton.frame.size.width/2.0 + 10,
        3,
        badgeSize.width,
        badgeSize.height
    );
    
    // 圆角样式
    customBadge.layer.cornerRadius = badgeSize.height / 2;
    customBadge.clipsToBounds = YES;
    
    // 添加阴影效果（可选）
    customBadge.layer.shadowColor = [UIColor blackColor].CGColor;
    customBadge.layer.shadowOffset = CGSizeMake(0, 1);
    customBadge.layer.shadowOpacity = 0.3;
    customBadge.layer.shadowRadius = 1;
    
    // 添加tag以便后续查找
    customBadge.tag = kCustomBadgeTagBase + index;
    
    [tabBarButton addSubview:customBadge];
    
    // 添加动画效果
    [self addBadgeAnimation:customBadge];
}

- (void)removeCustomBadgeAtIndex:(NSInteger)index {
    UIView *tabBarButton = [self getTabBarButtonAtIndex:index];
    UIView *customBadge = [tabBarButton viewWithTag:kCustomBadgeTagBase + index];
    
    if (customBadge) {
        [UIView animateWithDuration:0.2 animations:^{
            customBadge.alpha = 0;
            customBadge.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [customBadge removeFromSuperview];
        }];
    }
}

- (void)updateCustomBadgeValue:(NSString *)value atIndex:(NSInteger)index {
    UIView *tabBarButton = [self getTabBarButtonAtIndex:index];
    UILabel *existingBadge = (UILabel *)[tabBarButton viewWithTag:kCustomBadgeTagBase + index];
    
    if (existingBadge) {
        // 更新现有角标
        [UIView animateWithDuration:0.1 animations:^{
            existingBadge.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            existingBadge.text = value;
            CGSize newSize = [self calculateBadgeSizeForValue:value];
            
            CGRect newFrame = existingBadge.frame;
            newFrame.size = newSize;
            newFrame.origin.x = tabBarButton.frame.size.width - newSize.width/2 - 3;
            existingBadge.frame = newFrame;
            
            existingBadge.layer.cornerRadius = newSize.height / 2;
            
            [UIView animateWithDuration:0.1 animations:^{
                existingBadge.transform = CGAffineTransformIdentity;
            }];
        }];
    } else {
        // 创建新角标
        [self setCustomBadgeValue:value atIndex:index];
    }
}
- (UIView *)getTabBarButtonAtIndex:(NSInteger)index {
    // 获取tab bar的所有子视图，找到对应的tab bar button
    NSArray<UIView *> *tabBarSubviews = self.tabBar.subviews;
    NSMutableArray<UIView *> *tabBarButtons = [NSMutableArray array];
    
    for (UIView *view in tabBarSubviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtons addObject:view];
        }
    }
    
    // 按x坐标排序，确保顺序正确
    [tabBarButtons sortUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        return view1.frame.origin.x > view2.frame.origin.x ? NSOrderedDescending : NSOrderedAscending;
    }];
    
    if (index < tabBarButtons.count) {
        return tabBarButtons[index];
    }
    
    return nil;
}

- (CGSize)calculateBadgeSizeForValue:(NSString *)value {
    // 根据文本内容计算合适的尺寸
    CGSize textSize = [value sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:10]}];
    
    CGFloat minWidth = 10;  // 最小宽度
    CGFloat height = 10;    // 固定高度
    
    CGFloat width = MAX(textSize.width + 8, minWidth);
    
    // 如果是单个数字，保持圆形
    if (value.length == 1 && [self isNumeric:value]) {
        width = height;
    }
    
    return CGSizeMake(width, height);
}
- (BOOL)isNumeric:(NSString *)text {
    NSCharacterSet *nonNumericSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [text rangeOfCharacterFromSet:nonNumericSet].location == NSNotFound;
}
- (void)addBadgeAnimation:(UIView *)badge {
    badge.transform = CGAffineTransformMakeScale(0.1, 0.1);
    badge.alpha = 0;
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        badge.transform = CGAffineTransformIdentity;
        badge.alpha = 1;
    } completion:nil];
}


- (void)showSvga:(NSString *)svgaUrl
{
    WeakSelf(self)
    [self.svgaParser parseWithURL:[NSURL URLWithString:svgaUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        weakself.svgaPlayer.videoItem = videoItem;
        [weakself.svgaPlayer startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
    [[PGUtils getCurrentVC].view addSubview:self.svgaPlayer];
    [self.svgaPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight));
    }];
}
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player
{
    [self.svgaPlayer removeFromSuperview];
}

- (SVGAPlayer *)svgaPlayer
{
    if (!_svgaPlayer)
    {
        _svgaPlayer = [[SVGAPlayer alloc] init];
        _svgaPlayer.frame = CGRectMake(0, 0, ScreenWidth, 200);
        _svgaPlayer.fillMode = @"Forward";
        _svgaPlayer.loops = 1;
        _svgaPlayer.clearsAfterStop = YES;
        _svgaPlayer.delegate = self;
    }
    
    return _svgaPlayer;
}

- (SVGAParser *)svgaParser
{
    if (!_svgaParser){
        _svgaParser = [[SVGAParser alloc] init];
    }
    return _svgaParser;
}
- (UIView *)boScreenView
{
    if (!_boScreenView) {
        _boScreenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _boScreenView.backgroundColor = UUWhite;
        [_boScreenView addSubview:self.tipsLabel];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _boScreenView;
}
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = MPBoldFont(20);
        _tipsLabel.textColor = HEX(#000000);
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"由于该应用限制，涉及隐私/版权的界面不允许截屏";
    }
    return _tipsLabel;
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
