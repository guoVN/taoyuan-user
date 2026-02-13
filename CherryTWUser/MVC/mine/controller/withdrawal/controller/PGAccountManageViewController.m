//
//  PGAccountManageViewController.m
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGAccountManageViewController.h"
#import "PGAddAlipayAccountViewController.h"
//model
#import "PGWithdrawalAccountListModel.h"
//view
#import "PGAccountListTableViewCell.h"

@interface PGAccountManageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PGAccountManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"refreshAccount" object:nil];
}
- (void)loadUI
{
    self.titleStr = @"账号管理";
    [self.naviView yd_setHorizentalGradualFromColor:HEXAlpha(#5F92A1, 0.1f) toColor:HEXAlpha(#823A79, 0.08f)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
    [self setupEmptyView];
    [self.emptyView setTextLabelText:@"暂无提现账号"];
}
- (void)loadData
{
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:@(YES) forKey:@"filter"];
    [PGAPIService withdrawListWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [weakself.dataArray removeAllObjects];
        NSArray * items = [PGWithdrawalAccountListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [weakself.dataArray addObjectsFromArray:items];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        weakself.emptyView.hidden = weakself.dataArray.count>0?YES:NO;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
        [weakself.tableView.mj_header endRefreshing];
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
    PGAccountListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGAccountListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] init];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
    titleLabel.textColor = HEX(#333333);
    titleLabel.text = @"我的支付宝";
    [header addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(13);
    }];
    QMUIButton * addBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(0, 0, 58, 25)];
    addBtn.imagePosition = QMUIButtonImagePositionLeft;
    addBtn.spacingBetweenImageAndTitle = 5;
    [addBtn setImage:MPImage(@"tianjia") forState:UIControlStateNormal];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [addBtn yd_setHorizentalGradualFromColor:HEX(#A0A0EB) toColor:HEX(#E6BEE2)];
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.masksToBounds = YES;
    [addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [addBtn bringSubviewToFront:addBtn.imageView];
    [header addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(13);
        make.width.mas_equalTo(58);
        make.height.mas_equalTo(25);
    }];
    
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)addBtnAction
{
    WeakSelf(self)
    PGAddAlipayAccountViewController * vc = [[PGAddAlipayAccountViewController alloc] init];
    vc.addBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself loadData];
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
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
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"PGAccountListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGAccountListTableViewCell"];
        WeakSelf(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
