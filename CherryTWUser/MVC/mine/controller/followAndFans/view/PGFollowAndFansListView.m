//
//  PGFollowAndFansListView.m
//  CherryTWUser
//
//  Created by guo on 2025/10/24.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGFollowAndFansListView.h"
//model
#import "HMFansAndFollowListModel.h"
//view
#import "PGFollowAndFansListTableViewCell.h"

@interface PGFollowAndFansListView ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PGFollowAndFansListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (UIView *)listView
{
    return self;
}
- (void)initSubView
{
    page = 1;
    [self addSubview:self.tableView];
}
- (void)snapSubView
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (void)setIndex:(NSInteger)index
{
    _index = index;
    [self loadData];
}
- (void)loadData
{
    WeakSelf(self)
    NSDictionary * dic = @{@"userid":[PGManager shareModel].userInfo.userid};
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    if (self.index == 0) {
        [PGAPIService followListWithParameters:dic Success:^(id  _Nonnull data) {
            [QMUITips hideAllTips];
            weakself.dataArray = [HMFansAndFollowListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:message];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
        }];
    }else if (self.index == 1){
        [PGAPIService fansListWithParameters:dic Success:^(id  _Nonnull data) {
            [QMUITips hideAllTips];
            weakself.dataArray = [HMFansAndFollowListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:message];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
        }];
    }
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
    WeakSelf(self)
    PGFollowAndFansListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGFollowAndFansListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.vcIndex = self.index;
    cell.listModel = self.dataArray[indexPath.row];
    cell.statusBtn.alpha = self.index == 0 ? 1 : 0;
    cell.chatBtn.alpha = self.index == 0 ? 0 : 1;
    cell.cancelFollowBlock = ^{
        [weakself.dataArray removeObjectAtIndex:indexPath.row];
        [weakself.tableView reloadData];
    };
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 25;
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
/// 空数据UI
/// @param scrollView tableview
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = self.index == 0 ? Localized(@"暂无关注") : Localized(@"暂无粉丝");
    NSDictionary *attributes = @{NSFontAttributeName: MPFont(16),
                                 NSForegroundColorAttributeName: HEX(#000000)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return MPImage(@"empty");
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView; {
    return 0;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -STATUS_H_F;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
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
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"PGFollowAndFansListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGFollowAndFansListTableViewCell"];
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
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
