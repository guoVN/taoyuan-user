//
//  PGSetViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGSetViewController.h"
#import "PGCacheUtil.h"
#import "PGBindPhoneViewController.h"
#import "PGWriteInviteCodeViewController.h"
#import "HMBlackListViewController.h"
//view
#import "PGEditInfoTableViewCell.h"
#import "PGCustomAlertView.h"

@interface PGSetViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet QMUIButton *logOutBtn;
@property (assign, nonatomic) long cacheSize;
@property (nonatomic, copy) NSString * inviteCode;
///为2，表示在其他渠道注册过
@property (nonatomic, assign) NSInteger inviteCodeStatus;

@end

@implementation PGSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    [self loadData];
    [self loadInviteCode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVersionTips) name:@"VersionLatest" object:nil];
}
- (void)loadUI
{
    self.titleStr = Localized(@"设置");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+44);
        make.bottom.equalTo(self.logOutBtn.mas_top).offset(-20);
    }];
    [PGCacheUtil computeCache:^(long size) {
        self.cacheSize = size;
        [self loadData];
        // 刷新
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.inviteCodeStatus == 2 ? 2 : 3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
- (void)loadData
{
    long size = self.cacheSize;
    NSString *unit = @"K";
    if (size >= kCacheUnitK) {
        size = size / kCacheUnitK;
        unit = @"M";
    }
    NSString *cacheSize = [NSString stringWithFormat:@"%.2f%@", (float)size, unit];
    self.dataArray = [@[@{@"name":@"当前账号",@"value":[PGManager shareModel].userInfo.userid},
                        @{@"name":@"绑定手机号",@"value":[PGManager shareModel].userInfo.phone.length>0?[PGManager shareModel].userInfo.phone:@"未绑定"},
                        @{@"name":@"清理缓存",@"value":cacheSize},
                        @{@"name":@"黑名单",@"value":@""},
                        @{@"name":@"注销账号",@"value":@""},
                        @{@"name":@"当前版本",@"value":[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]]}
                       ] mutableCopy];
}
- (void)loadInviteCode
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [PGAPIService getBindInviteCodeWithParameters:dic Success:^(id  _Nonnull data) {
        NSString * inviteCode = data[@"data"];
        weakself.inviteCode = [inviteCode isKindOfClass:[NSString class]] ? inviteCode : @"";
        [weakself updateData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        weakself.inviteCodeStatus = code;
        [weakself updateData];
    }];
}
- (void)updateData
{
//    if (self.inviteCodeStatus != 2) {
//        [self.dataArray insertObject:@{@"name":@"补填邀请码",@"value":self.inviteCode.length>0?self.inviteCode:@""} atIndex:2];
//    }
    [self.tableView reloadData];
}
- (void)showVersionTips
{
    [QMUITips showWithText:@"当前已是最新版本"];
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
    PGEditInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGEditInfoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.titleLabel.text = dic[@"name"];
    cell.valueLabel.text = dic[@"value"];
    cell.valueLabel.textColor = HEX(#666666);
    cell.rightImg.alpha = indexPath.row == 0 ? 0 : 1;
    cell.valueLabelRC.constant = indexPath.row == 0 ? 20 : 46;
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
    WeakSelf(self)
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSString * title = dic[@"name"];
    if ([title isEqualToString:@"补填邀请码"]){
        if (self.inviteCode.length>0) {
            return;
        }
        PGWriteInviteCodeViewController * vc = [[PGWriteInviteCodeViewController alloc] init];
        vc.bindInviteCodeBlock = ^(NSString * _Nonnull code) {
            [weakself.dataArray replaceObjectAtIndex:2 withObject:@{@"name":@"补填邀请码",@"value":code}];
            [weakself.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"清理缓存"]){
        [QMUITips showWithText:@"清理中"];
        [PGCacheUtil cleanCache:^{
            [QMUITips hideAllTips];
            self.cacheSize = 0;
            [weakself.dataArray replaceObjectAtIndex:2 withObject:@{@"name":@"清理缓存",@"value":@"0.00k"}];
            [self.tableView reloadData];
            [QMUITips showWithText:@"清理完成"];
        }];
    }else if ([title isEqualToString:@"注销账号"]){
        PGCustomAlertView * alertView = [[PGCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        alertView.type = 4;
        [alertView.tipsImg setImage:MPImage(@"yiwen")];
        alertView.titleLabel.text = @"温馨提示";
        alertView.contentLabel.text = @"注销后，15天内无法操作软件，15天后会清除您在app内所有信息，请谨慎操作，确定注销吗？";
        [alertView.sureBtn setTitle:@"确定注销" forState:UIControlStateNormal];
        [[UIApplication sharedApplication].delegate.window addSubview:alertView];
    }else if ([title isEqualToString:@"当前版本"]){
        [PGUtils versionUpdate];
    }else if ([title isEqualToString:@"黑名单"]){
        HMBlackListViewController * vc = [[HMBlackListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"绑定手机号"]){
        PGBindPhoneViewController * vc = [[PGBindPhoneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        [_tableView registerNib:[UINib nibWithNibName:@"PGEditInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGEditInfoTableViewCell"];
    }
    return _tableView;
}
- (IBAction)logoutBtnAction:(id)sender {
    PGCustomAlertView * alertView = [[PGCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alertView.type = 3;
    [alertView.tipsImg setImage:MPImage(@"yiwen")];
    alertView.titleLabel.text = @"是否退出当前帐号？";
    alertView.contentLabel.text = @"";
    [alertView.sureBtn setTitle:@"确定退出" forState:UIControlStateNormal];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}
- (IBAction)userProAction:(id)sender {
}
- (IBAction)privateAction:(id)sender {
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
