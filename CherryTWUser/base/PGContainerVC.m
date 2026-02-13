//
//  PGContainerVC.m
//  CherryTWUser
//
//  Created by guo on 2025/10/22.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGContainerVC.h"
#import "PGHomeViewController.h"
#import "PGDynamicViewController.h"
#import "PGMessageViewController.h"
#import "PGMineViewController.h"
#import <SVGAParser.h>
#import <SVGAPlayer.h>

@interface PGContainerVC ()<SVGAPlayerDelegate>

@property (nonatomic, strong) SVGAPlayer * svgaPlayer;
@property (nonatomic, strong) SVGAParser * svgaParser;

@property (nonatomic, strong) UIView *containerView; // 页面容器视图
@property (nonatomic, strong) NSArray<PGBaseViewController *> *childVcs; // 所有子控制器
@property (nonatomic, strong) PGBaseViewController *currentVc; // 当前显示的子控制器

@end

@implementation PGContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
       
   // 1. 初始化子控制器（提前创建所有页面）
   [self setupChildViewControllers];
   
   // 2. 创建容器视图（用于显示子页面）
   [self setupContainerView];
   
   // 3. 初始化悬浮TabBar（承接上文代码，补充点击回调）
   [self setupFloatingTabBar];
   
   // 4. 默认显示第一个页面
   [self switchToChildVcAtIndex:0];
}
#pragma mark - 初始化子控制器
- (void)setupChildViewControllers {
    // 示例：创建4个页面（首页、发现、消息、我的）
    PGHomeViewController *homeVc = [[PGHomeViewController alloc] init];
   
    PGDynamicViewController *discoverVc = [[PGDynamicViewController alloc] init];
    
    PGMessageViewController *messageVc = [[PGMessageViewController alloc] init];
    
    PGMineViewController *mineVc = [[PGMineViewController alloc] init];

    // 存储到数组
    self.childVcs = @[homeVc, discoverVc, messageVc, mineVc];
    
    // 将子控制器添加到父控制器（确保生命周期被管理）
    for (UIViewController *vc in self.childVcs) {
        [self addChildViewController:vc];
    }
}

#pragma mark - 创建容器视图
- (void)setupContainerView {
    self.containerView = [[UIView alloc] init];
    // 布局：填满父视图，留出TabBar的位置
    self.containerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:self.containerView];
}

#pragma mark - 初始化悬浮TabBar（补充点击回调）
- (void)setupFloatingTabBar {
    // （承接上文图标初始化代码）
    // ... 图标准备代码 ...
    // 1. 准备图标（提前缓存，避免重复加载）
    UIImage *homeIcon = [UIImage imageNamed:@"home"];
    UIImage *planetIcon = [UIImage imageNamed:@"square"];
    UIImage *chatIcon = [UIImage imageNamed:@"message"];
    UIImage *meIcon = [UIImage imageNamed:@"mine"];
    
    UIImage *homeSelectIcon = [UIImage imageNamed:@"home_ed"];
    UIImage *planetSelectIcon = [UIImage imageNamed:@"square_ed"];
    UIImage *chatSelectIcon = [UIImage imageNamed:@"message_ed"];
    UIImage *meSelectIcon = [UIImage imageNamed:@"mine_ed"];
    
    // 初始化TabBar（位置在containerView下方）
    CGFloat tabBarH = 60;
    CGFloat tabBarY = ScreenHeight-20-60; // 与容器视图间距10pt
    self.floatingTabBar = [[PGFloatingTabBar alloc] initWithFrame:CGRectMake(20, tabBarY, self.view.bounds.size.width - 40, tabBarH)
                                                         icons:@[homeIcon, planetIcon, chatIcon, meIcon]
                                                     selectIcons:@[homeSelectIcon, planetSelectIcon, chatSelectIcon, meSelectIcon]];
    
    // 点击回调：切换页面
    __weak typeof(self) weakSelf = self;
    self.floatingTabBar.itemClickBlock = ^(NSInteger index) {
        [weakSelf switchToChildVcAtIndex:index];
    };
    
    [self.view addSubview:self.floatingTabBar];
}

#pragma mark - 核心：切换子控制器
- (void)switchToChildVcAtIndex:(NSInteger)index {
    // 1. 校验索引
    if (index < 0 || index >= self.childVcs.count) return;
    
    // 2. 获取目标子控制器
    PGBaseViewController *targetVc = self.childVcs[index];
    
    // 3. 若已是当前控制器，直接返回（避免重复操作）
    if (targetVc == self.currentVc) return;
    
    // 4. 移除当前子控制器的视图
    [self.currentVc.view removeFromSuperview];
    
    // 5. 添加目标子控制器的视图到容器
    targetVc.view.frame = self.containerView.bounds; // 充满容器
    [self.containerView addSubview:targetVc.view];
    
    // 6. 通知子控制器完成切换（生命周期管理）
    [targetVc didMoveToParentViewController:self];
    
    // 7. 更新当前控制器记录
    self.currentVc = targetVc;
}

#pragma mark - 适配屏幕旋转（可选）
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 旋转屏幕时更新容器和子视图的frame
    self.containerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.currentVc.view.frame = self.containerView.bounds;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
