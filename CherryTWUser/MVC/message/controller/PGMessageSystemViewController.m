//
//  PGMessageSystemViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/16.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGMessageSystemViewController.h"
//view
#import "PGMessageSystemTableViewCell.h"

@interface PGMessageSystemViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) QMUIButton * titleBtn;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PGMessageSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadData];
}
- (void)loadUI
{
    self.view.backgroundColor = HEX(#262429);
    self.naviView.backgroundColor = HEX(#5B5B5B);
    [self.naviView.backBtn setImage:MPImage(@"returnW") forState:UIControlStateNormal];
    [self.naviView addSubview:self.titleBtn];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_H_F+2);
        make.centerX.mas_equalTo(0);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
}
- (void)loadData
{
    [self.dataArray removeAllObjects];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        self.listModel.unReadNumStr = @"0";
    }];
    for (PGMessageChatModel * model in self.listModel.listArray) {
        [self.dataArray addObject:model];
    }
    self.dataArray = (NSMutableArray *)[[self.dataArray reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    PGMessageSystemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGMessageSystemTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
   
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
        [_tableView registerNib:[UINib nibWithNibName:@"PGMessageSystemTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGMessageSystemTableViewCell"];
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

- (QMUIButton *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [[QMUIButton alloc] init];
        _titleBtn.imagePosition = QMUIButtonImagePositionLeft;
        _titleBtn.spacingBetweenImageAndTitle = 4;
        [_titleBtn setImage:MPImage(@"horn") forState:UIControlStateNormal];
        [_titleBtn setTitle:@"系统消息" forState:UIControlStateNormal];
        [_titleBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _titleBtn;
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
