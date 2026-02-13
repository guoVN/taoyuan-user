//
//  PGInviteFriendListViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGInviteFriendListViewController.h"
//model
#import "PGInviteInComeModel.h"
#import "PGInviteInFriendModel.h"
//view
#import "PGInviteFriendListTableViewCell.h"
#import "PGInviteTableHeaderView.h"

@interface PGInviteFriendListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) PGInviteTableHeaderView * tableHeaderView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) PGInviteInComeModel * incomeModel;
@property (nonatomic, strong) PGInviteInFriendModel * friendModel;
@property (nonatomic, strong) NSMutableArray * origralArray;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) BOOL haveMore;

@end

@implementation PGInviteFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    [self loadUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"refreshInviteList" object:nil];
}
- (void)loadUI
{
    self.naviView.alpha = 0;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
   
}

- (void)listDidAppear {
   
}

- (void)listWillDisappear {
   
}

- (void)listDidDisappear {
   
}
- (void)loadData
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:@(page) forKey:@"current"];
    [dic setValue:@"10" forKey:@"size"];
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    if (self.index == 0) {
        [PGAPIService myIncomeListWithParameters:dic Success:^(id  _Nonnull data) {
            [QMUITips hideAllTips];
            weakself.incomeModel = [PGInviteInComeModel mj_objectWithKeyValues:data[@"data"]];
            weakself.tableHeaderView.incomeModel = weakself.incomeModel;
            [weakself updateData];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
            [weakself.superMainTableView.mj_header endRefreshing];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:message];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.superMainTableView.mj_header endRefreshing];
        }];
    }else if (self.index == 1){
        [PGAPIService myInviteListWithParameters:dic Success:^(id  _Nonnull data) {
            [QMUITips hideAllTips];
            weakself.friendModel = [PGInviteInFriendModel mj_objectWithKeyValues:data[@"data"]];
            weakself.tableHeaderView.friendModel = weakself.friendModel;
            [weakself updateData];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
            [weakself.superMainTableView.mj_header endRefreshing];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:message];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.superMainTableView.mj_header endRefreshing];
        }];
    }
}

- (void)updateData
{
    if (page == 1) {
        [self.dataArray removeAllObjects];
        [self.origralArray removeAllObjects];
    }
    if (self.index == 0) {
        NSMutableArray * timeArr = [NSMutableArray array];
        for (PGInviteInComeModelListRecordsModel * record in self.incomeModel.list.records) {
            NSString * time = @"";
            if (record.createTime.length>=10) {
                time = [record.createTime substringToIndex:10];
            }
            if (![timeArr containsObject:time]) {
                [timeArr addObject:time];
            }
            [self.origralArray addObject:record];
        }
        
        NSMutableArray * items = [NSMutableArray array];
        for (NSString * time in timeArr) {
            NSMutableArray * listArr = [NSMutableArray array];
            for (PGInviteInComeModelListRecordsModel * record in self.incomeModel.list.records) {
                if ([record.createTime containsString:time]) {
                    [listArr addObject:record];
                }
            }
            [items addObject:@{time:listArr}];
        }
        [self.dataArray addObjectsFromArray:items];
        self.haveMore = self.origralArray.count >= self.friendModel.list.total ? NO : YES;
    }else if (self.index == 1){
        NSMutableArray * timeArr = [NSMutableArray array];
        for (PGInviteInFriendModelListRecordsModel * record in self.friendModel.list.records) {
            NSString * time = @"";
            if (record.createTime.length>=10) {
                time = [record.createTime substringToIndex:10];
            }
            if (![timeArr containsObject:time]) {
                [timeArr addObject:time];
            }
            [self.origralArray addObject:record];
        }
        
        NSMutableArray * items = [NSMutableArray array];
        for (NSString * time in timeArr) {
            NSMutableArray * listArr = [NSMutableArray array];
            for (PGInviteInFriendModelListRecordsModel * record in self.friendModel.list.records) {
                if ([record.createTime containsString:time]) {
                    [listArr addObject:record];
                }
            }
            [items addObject:@{time:listArr}];
        }
        [self.dataArray addObjectsFromArray:items];
        self.haveMore = self.origralArray.count >= self.friendModel.list.total ? NO : YES;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary * dic = self.dataArray[section];
    NSArray * items = dic.allValues.firstObject;
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGInviteFriendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGInviteFriendListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.getConLabel.alpha = cell.diamondsNumlabel.alpha = cell.diaImg.alpha = self.index == 0 ? 1 : 0;
    cell.timeLabel.alpha = self.index == 0 ? 0 : 1;
    NSDictionary * dic = self.dataArray[indexPath.section];
    NSArray * items = dic.allValues.firstObject;
    if (self.index == 0) {
        cell.incomeListRecordModel = items[indexPath.row];
    }else if (self.index == 1){
        cell.friendListRecordModel = items[indexPath.row];
    }
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.dataArray.count-1) {
        return 30;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary * dic = self.dataArray[section];
    UIView * header = [[UIView alloc] init];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    titleLabel.textColor = HEX(#666666);
    titleLabel.text = dic.allKeys.firstObject;
    [header addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.top.mas_equalTo(10);
    }];
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == self.dataArray.count-1 && self.haveMore) {
        UIView * footer = [[UIView alloc] init];
        self.moreBtn = [[UIButton alloc] init];
        [self.moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:HEX(#FF5E5E) forState:UIControlStateNormal];
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightHeavy];
        [self.moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        return footer;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

- (void)moreBtnAction
{
    page++;
    [self loadData];
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
        UIView * tabH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 83)];
        [tabH addSubview:self.tableHeaderView];
        [self.tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.tableHeaderView = tabH;
        [_tableView registerNib:[UINib nibWithNibName:@"PGInviteFriendListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGInviteFriendListTableViewCell"];
        WeakSelf(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self->page = 1;
            [weakself loadData];
        }];
//        _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
//            self->page++;
//            [weakself loadData];
//        }];
    }
    return _tableView;
}
- (PGInviteTableHeaderView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[PGInviteTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 83)];
        if (self.index == 1) {
            _tableHeaderView.leftTitleLabel.text = @"今日邀请好友";
            _tableHeaderView.rightTitleLabel.text = @"昨日邀请好友";
            _tableHeaderView.leftIcon.image = _tableHeaderView.rightIcon.image = MPImage(@"friend");
        }
    }
    return _tableHeaderView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)origralArray
{
    if (!_origralArray) {
        _origralArray = [NSMutableArray array];
    }
    return _origralArray;
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
