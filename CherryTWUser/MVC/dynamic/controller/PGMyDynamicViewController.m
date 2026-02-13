//
//  PGMyDynamicViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/17.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGMyDynamicViewController.h"
#import "PGPublishDynamicViewController.h"
#import "PGDynamicDetailViewController.h"
#import "PGDynamicNoticeViewController.h"
#import "PGDiamondsListViewController.h"
#import "PGNavigationViewController.h"
//model
#import "PGAnchorModel.h"
#import "PGDynamicNoticeModel.h"
//view
#import "PGMyDynamicListTableViewCell.h"

@interface PGMyDynamicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UIButton * publishBtn;
@property (nonatomic, strong) NSArray * noticeArray;

@end

@implementation PGMyDynamicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNotice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"refreshDynamic" object:nil];
}
- (void)loadUI
{
    self.titleBtnStr = @"我的动态";
    [self.naviView.rightBtn setImage:MPImage(@"noMsg") forState:UIControlStateNormal];
    [self.naviView.rightBtn setImage:MPImage(@"haveMsg") forState:UIControlStateSelected];
    [self.naviView.rightBtn addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+44+10);
        make.bottom.mas_equalTo(-10);
    }];
//    [self.view addSubview:self.publishBtn];
//    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-10);
//        make.bottom.mas_equalTo(-SafeBottom-10);
//        make.width.height.mas_equalTo(82);
//    }];
    [self setupEmptyView];
    [self.emptyView setTextLabelText:@"您还没有动态哦～"];
}
- (void)refreshList
{
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadData
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService myDynamicListWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [weakself.dataArray removeAllObjects];
        NSArray * item = [PGAnchorDynamicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [weakself.dataArray addObjectsFromArray:item];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        weakself.emptyView.hidden = weakself.dataArray.count>0?YES:NO;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)loadNotice
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [PGAPIService dynamicDetailAndNoticeWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.noticeArray = [PGDynamicNoticeModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        weakself.naviView.rightBtn.selected = weakself.noticeArray.count > 0 ? YES : NO;
        [weakself.tableView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGMyDynamicListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGMyDynamicListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.noticeArray = self.noticeArray;
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGDynamicDetailViewController * vc = [[PGDynamicDetailViewController alloc] init];
    vc.detailModel = self.dataArray[indexPath.row];
    vc.noticeArray = self.noticeArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark===消息
- (void)msgAction
{
    PGDynamicNoticeViewController * vc = [[PGDynamicNoticeViewController alloc] init];
    vc.dataArray = [self.noticeArray mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark===发布
- (void)publishAction
{
    PGPublishDynamicViewController * vc = [[PGPublishDynamicViewController alloc] init];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark-======创建表视图
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
#ifdef __IPHONE_11_0
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                _tableView.estimatedRowHeight = 0;
                _tableView.estimatedSectionFooterHeight = 0;
                _tableView.estimatedSectionHeaderHeight = 0;
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
        }
#endif
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"PGMyDynamicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGMyDynamicListTableViewCell"];
        WeakSelf(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself loadData];
        }];
    }
    return _tableView;
}
- (UIButton *)publishBtn
{
    if (!_publishBtn) {
        _publishBtn = [[UIButton alloc] init];
        [_publishBtn setImage:MPImage(@"publish") forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSArray *)noticeArray
{
    if (!_noticeArray) {
        _noticeArray = [NSArray array];
    }
    return _noticeArray;
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
