//
//  PGRechargeViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGRechargeViewController.h"
#import "PGWebViewController.h"
//model
#import "PGPayListModel.h"
//view
#import "PGRechargeTableViewCell.h"

@interface PGRechargeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *diamonsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
///1.原生，2.三方
@property (nonatomic, assign) NSInteger aliPayType;

@end

@implementation PGRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    [self loadData];
    [self judgeOriginOrThird];
}
- (void)loadUI
{
    self.titleStr = @"充值";
    if (self.isCallRecharge) {
        self.naviView.frame = CGRectMake(0, 0, ScreenWidth, 64);
        self.naviView.backBtn.alpha = 0;
        [self.naviView.titleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
        }];
    }
    self.diamonsNumLabel.text = [NSString stringWithFormat:@"%.0f",self.coinModel.coin*0.01];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %ld.00",self.coinModel.money];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
        make.bottom.mas_equalTo(-SafeBottom-80);
    }];
}
- (void)loadData
{
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    NSString * packageName = Package_Name;
    [PGAPIService payListWithParameters:@{@"packageName":packageName} Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        PGPayListModel * listModel = [PGPayListModel mj_objectWithKeyValues:data[@"data"]];
        [weakself updateData:listModel];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)judgeOriginOrThird
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@"ALI_PAY" forKey:@"payType"];
    [dic setValue:@"ntdlaz" forKey:@"packageName"];
    [PGAPIService payOriginOrThirdWithParameters:dic Success:^(id  _Nonnull data) {
        BOOL isOrigin = [data[@"data"] boolValue];
        weakself.aliPayType = isOrigin == YES ? 1 : 2;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)updateData:(PGPayListModel*)model
{
    if ([model.aliPayState integerValue] == 1) {
        NSDictionary * dic = @{@"img":@"ali_icon",@"name":@"支付宝"};
        [self.dataArray addObject:dic];
    }
    if ([model.weChatState integerValue] == 1) {
        NSDictionary * dic = @{@"img":@"wxpay",@"name":@"微信支付"};
        [self.dataArray addObject:dic];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:defaultIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:defaultIndexPath];
    });
    [self.tableView reloadData];
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
    PGRechargeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGRechargeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = self.dataArray[indexPath.section];
    [cell.iconImg setImage:MPImage(dic[@"img"])];
    cell.titleLabel.text = dic[@"name"];
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
    PGRechargeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.chooseImg setImage:MPImage(@"choose_ed")];
    cell.backgroundColor = HEX(#FFE3EB);
    cell.layer.borderColor = HEX(#FF6B97).CGColor;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGRechargeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.chooseImg setImage:MPImage(@"choose_nor")];
    cell.backgroundColor = HEX(#FFFFFF);
    cell.layer.borderColor = HEX(#707070).CGColor;
}

#pragma mark===充值
- (IBAction)doRechargeAction:(id)sender {
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:@"充值" forKey:@"category"];
    [dic setValue:self.aliPayType == 1 ? @"ZN" : @"ALPN" forKey:@"payType"];
    [dic setValue:@(self.coinModel.money) forKey:@"chargeAmount"];
    [dic setValue:@(self.coinModel.coin) forKey:@"coinAmount"];
    [dic setValue:@"ntdlaz" forKey:@"packName"];
    [PGAPIService payRechargeWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        if (weakself.aliPayType == 1) {
            NSString * orderStr = data[@"orderString"];
            [weakself goForAlipayAction:orderStr];
        }else{
            NSString * payUrl = data[@"data"];
            [weakself goPay:payUrl];
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)goPay:(NSString *)url
{
    PGWebViewController * vc = [PGWebViewController controllerWithTitle:@"充值" url:url];
    vc.isRecharge = YES;
    vc.isCallRecharge = self.isCallRecharge;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark===支付宝原生支付
- (void)goForAlipayAction:(NSString *)orderSn
{
    NSString *appScheme=@"HYAlipayScheames";
    [[AlipaySDK defaultService] payOrder:orderSn fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic[@"resultCode"]);
        if ([resultDic[@"resultCode"] integerValue] == 9000) {
            [self paySuccess];
        }else{
            [QMUITips showWithText:@"支付失败"];
        }
    }];
    //不用管下面的,对回调有用
    [[AlipaySDK defaultService] payInterceptorWithUrl:orderSn fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic[@"resultCode"]);
    }];
}
- (void)paySuccess
{
    [QMUITips showWithText:@"支付成功"];
    [PGUtils getUserInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
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
        [_tableView registerNib:[UINib nibWithNibName:@"PGRechargeTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGRechargeTableViewCell"];
        _tableView.scrollEnabled = NO;
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
