//
//  PGHomeViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import "PGHomeViewController.h"
#import "Reachability.h"
#import "PGCustomViewController.h"
#import "PGSearchViewController.h"
#import "PGWebViewController.h"
//model
#import "PGHomeListModel.h"
#import "PGMessageListModel.h"
#import "PGMessageChatModel.h"
#import "PGScreenSwitchModel.h"
//view
#import <GKCycleScrollView/GKCycleScrollView.h>
#import "PGPageControl.h"
#import "PGHomeListView.h"

@interface PGHomeViewController ()<GKCycleScrollViewDataSource,GKCycleScrollViewDelegate,JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic, strong) GKCycleScrollView *bannerScrollView;
@property (nonatomic, strong) PGPageControl * pageControl;
@property (nonatomic, strong) NSMutableArray * bannerImageArr;
@property (nonatomic, strong) JXCategoryTitleView * jxCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView * listContainerView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) NSMutableArray * segArray;

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign) BOOL isNotNetAgo;

@end

@implementation PGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self listenNetwork];
    [self loadUI];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadBanner];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [PGUtils getUserInfo];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadConfigData];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadScreenSwitch];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [PGUtils versionUpdate];
    });
}
- (void)loadUI
{
    self.naviView.alpha = 0;
    [self.view addSubview:self.bannerScrollView];
    [self.bannerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.searchView.mas_bottom).offset(15);
        make.height.mas_equalTo((ScreenWidth-30)*9/21.0);
    }];
    self.segArray = [@[Localized(@"推荐"),Localized(@"新人")] mutableCopy];
    [self.view addSubview:self.jxCategoryView];
    [self.view bringSubviewToFront:self.naviView];
    //关联到categoryView
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.jxCategoryView.listContainer = self.listContainerView;
    [self.jxCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.bannerScrollView.mas_bottom);
        make.height.mas_equalTo(64);
    }];
    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(self.jxCategoryView.mas_bottom);
    }];
    [self.jxCategoryView reloadData];
}
- (void)loadBanner
{
    WeakSelf(self)
    [PGAPIService homeBannerWithParameters:@{@"userId":[PGManager shareModel].userInfo.userid} Success:^(id  _Nonnull data) {
        NSArray * items = data[@"data"];
        if ([items isKindOfClass:[NSArray class]]) {
            [weakself initScrollHeadView:items];
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)initScrollHeadView:(NSArray*)bannerArr {
    
    self.bannerImageArr = [bannerArr mutableCopy];
    [self.bannerScrollView reloadData];
    self.pageControl.hidden = self.bannerImageArr.count < 2;
    self.pageControl.currentPage = self.bannerScrollView.currentSelectIndex;
    self.pageControl.numberOfPages = self.bannerImageArr.count;
    [self.pageControl setUpDots];
    self.pageControl.center = CGPointMake((ScreenWidth-30)/2, 135);
}
#pragma mark=== JXCategoryViewDelegate
//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    
}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index
{
    
}

//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio
{
    
}
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index
{
    return YES;
}
//返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.segArray.count;
}
//根据下标index返回对应遵从`JXCategoryListContentViewDelegate`协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    PGHomeListView * view = [[PGHomeListView alloc] init];
    view.index = index;
    return view;
}

- (void)loadConfigData
{
    [PGAPIService getUserDefaultHeadImgWithParameters:@{@"code":@"callStartDeductionTime",@"channel":Channel_Name} Success:^(id  _Nonnull data) {
        NSInteger time = [data[@"data"] integerValue];
        [PGManager shareModel].videoFirstRecharTime = time > 0 ? time : 10;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [PGManager shareModel].videoFirstRecharTime = 10;
    }];
}
- (void)loadScreenSwitch
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [PGAPIService getScreenRecordSwitchWithParameters:@{@"channel":Channel_Name,@"version":app_Version} Success:^(id  _Nonnull data) {
        NSArray * items = [PGScreenSwitchModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        for (PGScreenSwitchModel * model in items) {
            if ([model.channel isEqualToString:Channel_Name] && [model.keys isEqualToString:@"screenshot.show"]) {
                [PGManager shareModel].isRecordScreen = [model.values isEqualToString:@"on"] ? NO : YES;
            }
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}

- (IBAction)videoMatchAction:(id)sender {
    [QMUITips showWithText:@"功能建设中"];
}
- (IBAction)serviceAction:(id)sender {
    PGWebViewController * vc = [PGWebViewController controllerWithTitle:@"客服" url:[PGManager shareModel].searviceLinkStr];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.bannerImageArr.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        cell.tag = index;
    }
    cell.imageView.layer.cornerRadius = 20;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.bannerImageArr[index]] placeholderImage:MPImage(@"bannerBg")];
//    [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return CGSizeMake(ScreenWidth-30, 147);
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView scrollingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex ratio:(CGFloat)ratio {
    self.pageControl.currentPage = toIndex;
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index
{
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:self.bannerImageArr atIndex:index];
}

- (IBAction)searchAction:(id)sender {
    PGSearchViewController * vc = [[PGSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark===网络监听
-(void)listenNetwork{
  //注册网络状态通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
  //获取Reachability对象
  self.reachability = [Reachability reachabilityForInternetConnection];
  //开始监听网络变化
  [self.reachability startNotifier];
  // 立即进行一次初始的网络状态检测
  NetworkStatus networkStatus = [self.reachability currentReachabilityStatus];
  [self networkStatusChangedWithNetworkStatus:networkStatus];
}

- (void)networkStatusChanged:(NSNotification*)notification {
  Reachability*reachability = (Reachability*)notification.object;
  NetworkStatus networkStatus = [reachability currentReachabilityStatus];
  [self networkStatusChangedWithNetworkStatus:networkStatus];
}

- (void)networkStatusChangedWithNetworkStatus:(NetworkStatus)networkStatus {
  // 判断是否有网络连接
  if(networkStatus ==NotReachable) {
      self.isNotNetAgo = YES;
  }else{
      if (self.isNotNetAgo) {
          //重新网络请求
          [self.jxCategoryView reloadData];
          [self loadConfigData];
          [self loadScreenSwitch];
          [PGUtils versionUpdate];
          self.isNotNetAgo = NO;
      }
  }
}
- (void)dealloc{
  [self removeNetworkListener];
}

-(void)removeNetworkListener{
  [self.reachability stopNotifier];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
  self.reachability = nil;
}

- (GKCycleScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        _bannerScrollView = [[GKCycleScrollView alloc] init];
        _bannerScrollView.backgroundColor = [UIColor clearColor];
        _bannerScrollView.dataSource = self;
        _bannerScrollView.delegate = self;
        _bannerScrollView.leftRightMargin = 60.0f;
        _bannerScrollView.minimumCellAlpha = 0.0f;
        [_bannerScrollView addSubview:self.pageControl];
    }
    return _bannerScrollView;
}
- (PGPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl  = [[PGPageControl alloc] init];
        _pageControl.currenStyle = Special;
        _pageControl.pageSize = CGSizeMake(6, 6);
        _pageControl.currenPageSize = CGSizeMake(6, 6);
        _pageControl.currenColor = HEX(#352A21);
        _pageControl.defaultColor = UUWhite;
    }
    return _pageControl;
}
- (NSMutableArray *)bannerImageArr
{
    if (!_bannerImageArr) {
        _bannerImageArr = [NSMutableArray array];
    }
    return _bannerImageArr;
}
- (JXCategoryTitleView *)jxCategoryView
{
    if (!_jxCategoryView) {
        _jxCategoryView = [[JXCategoryTitleView alloc] init];
        _jxCategoryView.delegate = self;
        _jxCategoryView.titles = self.segArray;
        _jxCategoryView.defaultSelectedIndex = 0;
        _jxCategoryView.indicators = @[self.lineView];
        _jxCategoryView.titleFont = MPFont(18);
        _jxCategoryView.titleColor = HEX(#000000);
        _jxCategoryView.titleSelectedFont = MPSemiboldFont(20);
        _jxCategoryView.titleSelectedColor = HEX(#000000);
        _jxCategoryView.contentEdgeInsetLeft = 20;
        _jxCategoryView.averageCellSpacingEnabled = NO;
    }
    return _jxCategoryView;
}

- (JXCategoryIndicatorLineView *)lineView
{
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorColor = HEX(#FF6B97);
        _lineView.indicatorWidth = 6;
        _lineView.indicatorHeight = 6;
        _lineView.verticalMargin = 10;
    }
    return _lineView;
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
