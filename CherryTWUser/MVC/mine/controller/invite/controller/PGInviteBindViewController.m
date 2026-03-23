//
//  PGInviteBindViewController.m
//  CherryTWUser
//
//  Created by guo on 2026/3/23.
//  Copyright © 2026 guo. All rights reserved.
//

#import "PGInviteBindViewController.h"
#import "PGInviteBindTableViewCell.h"
#import "PGAnchorModel.h"
#import "PGCheckBindAnchorModel.h"

@interface PGInviteBindViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet QMUITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) PGCheckBindAnchorModel * bindStatusModel;

@end

@implementation PGInviteBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    [self loadData];
}
- (void)loadUI
{
    self.titleStr = @"邀请绑定";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.searchView.mas_bottom).offset(10);
    }];
}
- (void)loadData
{
    WeakSelf(self)
    [PGAPIService checkBindAnchorWithParameters:@{@"userId":[PGManager shareModel].userInfo.userid} Success:^(id  _Nonnull data) {
        weakself.bindStatusModel = [PGCheckBindAnchorModel mj_objectWithKeyValues:data[@"data"]];
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObject:weakself.bindStatusModel.anchorUser];
        [weakself.tableView reloadData];
        if (weakself.bindStatusModel.bindStatus == 1) {
            weakself.searchBtn.backgroundColor = HEX(#999999);
            weakself.searchBtn.enabled = NO;
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (IBAction)searchBtnAction:(id)sender {
    if (self.searchField.text.length == 0) {
        return;
    }
    [self.view endEditing:YES];
    WeakSelf(self)
    [PGAPIService checkAnchorByIdWithParameters:@{@"id":self.searchField.text} Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        PGAnchorModel * model = [PGAnchorModel mj_objectWithKeyValues:data[@"data"]];
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObject:model];
        weakself.tableView.emptyDataSetSource = weakself;
        weakself.tableView.emptyDataSetDelegate = weakself;
        [weakself.tableView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
        weakself.tableView.emptyDataSetSource = weakself;
        weakself.tableView.emptyDataSetDelegate = weakself;
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
    WeakSelf(self)
    PGInviteBindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGInviteBindTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    if (self.bindStatusModel.bindStatus == 1) {
        cell.bindBtn.backgroundColor = HEX(#999999);
        cell.bindBtn.enabled = NO;
    }
    cell.refreshStatusBlock = ^{
        [weakself loadData];
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
    return 0.01;
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
    NSString *text = Localized(@"暂无数据");
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
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"PGInviteBindTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGInviteBindTableViewCell"];
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
