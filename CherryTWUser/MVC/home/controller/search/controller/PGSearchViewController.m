//
//  PGSearchViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGSearchViewController.h"
#import "PGSearchResultViewController.h"
#import "PGPersonalDetailViewController.h"
//model
#import "PGHomeListModel.h"
//view
#import "PGSearchResultTableViewCell.h"

@interface PGSearchViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,QMUITextFieldDelegate>

@property (weak, nonatomic) IBOutlet QMUITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PGSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    self.view.backgroundColor = HEX(#F9F9F9);
    self.naviView.backgroundColor = HEX(#FFFFFF);
    [self.view bringSubviewToFront:self.searchView];
    self.searchField.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+44);
    }];
}
- (void)searchBtnAction {
    if (self.searchField.text.length == 0) {
        return;
    }
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.searchField.text forKey:@"anchorId"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService searchAnchorWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        PGHomeListModel * detailModel = [PGHomeListModel mj_objectWithKeyValues:data[@"data"]];
        [weakself.dataArray removeAllObjects];
        if (detailModel != nil) {
            [weakself.dataArray addObject:detailModel];
        }
        [weakself.tableView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtnAction];
    return YES;;
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
    PGSearchResultTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGSearchResultTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.section];
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
    PGHomeListModel * listModel = self.dataArray[indexPath.section];
    PGPersonalDetailViewController * vc = [[PGPersonalDetailViewController alloc] init];
    vc.anchorid = [NSString stringWithFormat:@"%ld",listModel.userid];
    [self.navigationController pushViewController:vc animated:YES];
}
/// 空数据UI
/// @param scrollView tableview
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = Localized(@"抱歉，没有搜索到您要找的人");
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
        [_tableView registerNib:[UINib nibWithNibName:@"PGSearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGSearchResultTableViewCell"];
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
