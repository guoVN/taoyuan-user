//
//  PGYuYueRecordViewController.m
//  CherryTWUser
//
//  Created by guo on 2025/10/24.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGYuYueRecordViewController.h"
//model
#import "HMYuYueRecordModel.h"
//view
#import "HMYuYueRecordTableViewCell.h"

@interface PGYuYueRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PGYuYueRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadData];
}
- (void)loadUI
{
    self.titleStr = Localized(@"预约记录");
    page = 1;
    self.view.backgroundColor = HEX(#EDEEF2);
    self.naviView.backgroundColor = HEX(#FFFFFF);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.naviView.mas_bottom).offset(5);
        make.bottom.mas_equalTo(0);
    }];
}
- (void)loadData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:@(page) forKey:@"pageNum"];
    [dic setValue:@(10) forKey:@"pageSize"];
    WeakSelf(self)
    [PGAPIService checkYuyueRecordLsitWithParameters:dic Success:^(id  _Nonnull data) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        if ([data[@"code"] integerValue] == 0) {
            HMYuYueRecordModel * model = [HMYuYueRecordModel mj_objectWithKeyValues:data[@"data"]];
            if (self->page == 1) {
                [weakself.dataArray removeAllObjects];
            }
            [weakself.dataArray addObjectsFromArray:model.records];
            
            if (model.records.count == 0) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakself.tableView reloadData];
        }else{
            [QMUITips showWithText:data[@"message"]];
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMYuYueRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HMYuYueRecordTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listModel = self.dataArray[indexPath.section];
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
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
        [_tableView registerNib:[UINib nibWithNibName:@"HMYuYueRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMYuYueRecordTableViewCell"];
        WeakSelf(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self->page = 1;
            [weakself loadData];
        }];
        _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            self->page++;
            [weakself loadData];
        }];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
