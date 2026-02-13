//
//  PGInviteFriendViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGInviteFriendViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXPagingView/JXPagerView.h>
#import "PGInviteFriendListViewController.h"
//model
#import "PGInviteModel.h"
//view
#import "PGInviteFriendPageHeaderView.h"

@interface PGInviteFriendViewController ()<JXPagerViewDelegate,JXCategoryViewDelegate,JXPagerMainTableViewGestureDelegate>

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) PGInviteFriendPageHeaderView * userHeaderView;
@property (nonatomic, strong) JXCategoryTitleView * jxCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView * listContainerView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) NSMutableArray * segArray;
@property (nonatomic, strong) PGInviteModel * inviteModel;

@end

@implementation PGInviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    [self loadData];
}
- (void)loadUI
{
//    [self setTitleStr:@"邀请好友"];
//    [self.naviView.backBtn setImage:MPImage(@"returnW") forState:UIControlStateNormal];
//    self.naviView.titleLabel.textColor = HEX(#FFFFFF);
//    self.view.backgroundColor = HEX(#EDEDED);
//    
//    self.segArray = [@[@"邀请收益",@"我的邀请"] mutableCopy];
//    [self setupPagerView];
}
- (void)setupPagerView
{
    _userHeaderView = [[PGInviteFriendPageHeaderView alloc] init];
    self.pagingView = [[JXPagerView alloc] initWithDelegate:self];
    self.pagingView.backgroundColor = [UIColor clearColor];
    self.pagingView.mainTableView.backgroundColor = [UIColor clearColor];
    self.pagingView.mainTableView.gestureDelegate = self;
//    self.pagerView.isListHorizontalScrollEnabled = NO;
    [self.view addSubview:self.pagingView];

    self.jxCategoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    self.pagingView.pinSectionHeaderVerticalOffset = 0;
    
    self.pagingView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInviteList" object:nil userInfo:nil];
    }];
    
    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
    [self.pagingView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.pagingView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.jxCategoryView.selectedIndex == 0);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagingView.frame = CGRectMake(10, STATUS_H_F+117, ScreenWidth-20, ScreenHeight-STATUS_H_F-117);
}

- (void)loadData
{
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [PGAPIService getInviteInfoWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        weakself.inviteModel = [PGInviteModel mj_objectWithKeyValues:data[@"data"]];
        [weakself dealInvieData];;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)dealInvieData
{
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"获%ld  奖励",self.inviteModel.coin/100]];
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"diamonds"];
    attach.bounds = CGRectMake(0, -3, 20, 20);
    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
    [att insertAttributedString:attrStringWithImage atIndex:3];
    self.coinLabel.attributedText = att;
    
    NSMutableAttributedString * codeAtt = [[NSMutableAttributedString alloc] initWithString:self.inviteModel.invitationCode];
    [codeAtt addAttribute:NSKernAttributeName
                               value:@(10.0) // 字符间距，数值越大间距越宽
                               range:NSMakeRange(0, self.inviteModel.invitationCode.length)];
    self.codeLabel.attributedText = codeAtt;
    self.linkLabel.text= self.inviteModel.invitationLandingPageLink;
}
#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 320;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 60;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.jxCategoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.segArray.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    PGInviteFriendListViewController * vc = [[PGInviteFriendListViewController alloc] init];
    vc.index = index;
    vc.superMainTableView = self.pagingView.mainTableView;
    return vc;
}
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return  YES;
}
#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (JXCategoryTitleView *)jxCategoryView
{
    if (!_jxCategoryView) {
        _jxCategoryView = [[JXCategoryTitleView alloc] init];
        _jxCategoryView.backgroundColor = HEX(#FFFFFF);
        [_jxCategoryView acs_radiusWithRadius:8 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
        _jxCategoryView.delegate = self;
        _jxCategoryView.titles = self.segArray;
        _jxCategoryView.defaultSelectedIndex = 0;
        _jxCategoryView.indicators = @[self.lineView];
        _jxCategoryView.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _jxCategoryView.titleColor = HEX(#666666);
        _jxCategoryView.titleSelectedFont = [UIFont systemFontOfSize:16 weight:UIFontWeightHeavy];
        _jxCategoryView.titleSelectedColor = HEX(#333333);
        _jxCategoryView.averageCellSpacingEnabled = NO;
        _jxCategoryView.cellSpacing = 24;
        _jxCategoryView.contentEdgeInsetLeft = 36;
    }
    return _jxCategoryView;
}

- (JXCategoryIndicatorLineView *)lineView
{
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorColor = HEX(#FF5E5E);
        _lineView.indicatorWidth = 15;
        _lineView.indicatorHeight = 5;
        _lineView.verticalMargin = 10;
    }
    return _lineView;
}
- (IBAction)copyCodeAction:(id)sender {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.codeLabel.text;
    [QMUITips showWithText:@"已复制"];
}
- (IBAction)copyLinkAction:(id)sender {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.linkLabel.text;
    [QMUITips showWithText:@"已复制"];
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
