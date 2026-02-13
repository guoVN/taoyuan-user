//
//  PGFollowAndFansViewController.m
//  CherryTWUser
//
//  Created by guo on 2025/10/24.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGFollowAndFansViewController.h"
#import "PGFollowAndFansListView.h"

@interface PGFollowAndFansViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView * jxCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView * listContainerView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) NSMutableArray * segArray;

@end

@implementation PGFollowAndFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.segArray = [@[Localized(@"关注"),Localized(@"粉丝")] mutableCopy];
    [self.view addSubview:self.jxCategoryView];
    [self.view bringSubviewToFront:self.naviView];
    //关联到categoryView
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.jxCategoryView.listContainer = self.listContainerView;
    [self.jxCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-80);
        make.top.mas_equalTo(STATUS_H_F);
        make.height.mas_equalTo(44);
    }];
    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(self.jxCategoryView.mas_bottom).offset(10);
    }];
    [self.jxCategoryView reloadData];
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
    PGFollowAndFansListView * view = [[PGFollowAndFansListView alloc] init];
    view.index = index;
    return view;
}

- (JXCategoryTitleView *)jxCategoryView
{
    if (!_jxCategoryView) {
        _jxCategoryView = [[JXCategoryTitleView alloc] init];
        _jxCategoryView.backgroundColor = HEX(#FFFFFF);
        _jxCategoryView.delegate = self;
        _jxCategoryView.titles = self.segArray;
        _jxCategoryView.defaultSelectedIndex = self.type;
        _jxCategoryView.indicators = @[self.lineView];
        _jxCategoryView.titleFont = MPFont(16);
        _jxCategoryView.titleColor = HEX(#666666);
        _jxCategoryView.titleSelectedFont = MPMediumFont(16);
        _jxCategoryView.titleSelectedColor = HEX(#222222);
    }
    return _jxCategoryView;
}

- (JXCategoryIndicatorLineView *)lineView
{
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorColor = HEX(#FF6B97);
        _lineView.indicatorWidth = 15;
        _lineView.indicatorHeight = 3;
        _lineView.verticalMargin = 0;
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
