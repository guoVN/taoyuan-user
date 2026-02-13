//
//  PGWithdrawalViewController.m
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGWithdrawalViewController.h"
#import "PGAccountManageViewController.h"
#import "PGWithdrawalRecordViewController.h"
#import "PGParameterSignTool.h"
//model
#import "PGWithdrawalUserModel.h"
#import "PGWithdrawalAccountListModel.h"
//view
#import "PGWithdrawalTableViewCell.h"
#import "PGNoAccountTableViewCell.h"
#import "PGCustomAlertView.h"

@interface PGWithdrawalViewController ()<UITableViewDataSource,UITableViewDelegate,QMUITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *inviteIncomeLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *moneyField;
@property (weak, nonatomic) IBOutlet UILabel *minMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet UIButton *manageBtn;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) PGWithdrawalUserModel * userModel;
@property (nonatomic, strong) PGWithdrawalAccountListModel * currentAccountModel;
@property (nonatomic, assign) NSInteger currentChooseIndex;
@property (nonatomic, assign) BOOL isShowAccount;
@property (nonatomic, copy) NSString * feeStr;

@end

@implementation PGWithdrawalViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadBalance];
    [self loadFee];
}
- (void)loadUI
{
    self.isShowAccount = YES;
    self.currentChooseIndex = -1;
    self.titleBtnStr = @"提现";
    [self.naviView.rightBtn setTitle:@"明细" forState:UIControlStateNormal];
    [self.naviView.rightBtn setTitleColor:HEX(#FC979A) forState:UIControlStateNormal];
    self.naviView.rightBtn.titleLabel.font = MPFont(17);
    [self.naviView.rightBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView yd_setHorizentalGradualFromColor:HEX(#FFFFFF) toColor:HEX(#FFDFE9)];
    self.transferBtn.frame = CGRectMake(0, 0, ScreenWidth-160, 40);
    [self.transferBtn yd_setHorizentalGradualFromColor:HEX(#FF9CBB) toColor:HEX(#B378F4)];
    self.moneyField.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.manageBtn.mas_bottom);
        make.bottom.equalTo(self.tipsLabel.mas_top).offset(-10);
    }];
}
- (void)loadBalance
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [PGAPIService userBalanceWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.userModel = [PGWithdrawalUserModel mj_objectWithKeyValues:data[@"data"]];
        weakself.inviteIncomeLabel.text = [NSString stringWithFormat:@"%ld",weakself.userModel.withdrawIntegral/10];
        weakself.minMoneyLabel.text = [NSString stringWithFormat:@"最小可提现余额：￥%ld",weakself.userModel.minWithdrawMoney];
        weakself.balanceLabel.text = [NSString stringWithFormat:@"当前余额：%@",[PGUtils FloatKeepOneBits:[weakself.userModel.withdrawMoney floatValue]]];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)loadFee{
    WeakSelf(self)
    self.feeStr = @"";
    [PGAPIService getUserDefaultHeadImgWithParameters:@{@"code":@"fee_rate"} Success:^(id  _Nonnull data) {
        weakself.feeStr = [NSString stringWithFormat:@"(提现费率%@%@)",[PGUtils removeExcessZeros:[NSString stringWithFormat:@"%f",[data[@"data"] floatValue]*100]],@"%"];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
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
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isShowAccount) {
        return self.dataArray.count > 0 ? self.dataArray.count : 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count>0) {
        PGWithdrawalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGWithdrawalTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        if (indexPath.row == self.currentChooseIndex) {
            cell.checkBtn.selected = YES;
        }else{
            cell.checkBtn.selected = NO;
        }
        [cell layoutIfNeeded];
        return cell;
    }else{
        PGNoAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGNoAccountTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [cell layoutIfNeeded];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * header = [[UIButton alloc] init];
    QMUIButton * alipayBtn = [[QMUIButton alloc] init];
    alipayBtn.imagePosition = QMUIButtonImagePositionLeft;
    alipayBtn.spacingBetweenImageAndTitle = 10;
    [alipayBtn setImage:MPImage(@"alipay") forState:UIControlStateNormal];
    [alipayBtn setTitle:@"支付宝" forState:UIControlStateNormal];
    [alipayBtn setTitleColor:HEX(#333333) forState:UIControlStateNormal];
    alipayBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
    alipayBtn.userInteractionEnabled = NO;
    [header addSubview:alipayBtn];
    [alipayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(14);
        make.height.mas_equalTo(26);
    }];
    UILabel * feeLabel = [[UILabel alloc] init];
    feeLabel.font = MPFont(10);
    feeLabel.textColor = HEX(#333333);
    feeLabel.text = self.feeStr;
    [header addSubview:feeLabel];
    [feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayBtn.mas_right);
        make.centerY.equalTo(alipayBtn.mas_centerY);
    }];
    UIImageView * rightImg = [[UIImageView alloc] init];
    [rightImg setImage:self.isShowAccount==YES?MPImage(@"icon_down"):MPImage(@"icon_right")];
    [header addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.width.height.mas_equalTo(15);
        make.centerY.equalTo(alipayBtn.mas_centerY);
    }];
    [header addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count>0) {
        self.currentChooseIndex = indexPath.row;
        self.currentAccountModel = self.dataArray[indexPath.row];
        [self.tableView reloadData];
    }
}
#pragma mark====textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
    NSString * moneyStr = self.moneyField.text;
    if (string.length>0) {
        moneyStr = [moneyStr stringByAppendingString:string];
    }else{
        moneyStr =[moneyStr stringByReplacingCharactersInRange:NSMakeRange(moneyStr.length-1, 1) withString:@""];
    }
    //判断输入多个小数点,禁止输入多个小数点
    if (dotLocation != NSNotFound){
        if ([string isEqualToString:@"."])return NO;
    }
    //判断小数点后最多两位
    if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
        return NO;
    }
    
    return YES;
}
#pragma mark===明细
- (void)recordAction
{
    PGWithdrawalRecordViewController * vc = [[PGWithdrawalRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark===账号管理
- (IBAction)manageAction:(id)sender {
    PGAccountManageViewController * vc = [[PGAccountManageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark===转入到账户
- (IBAction)transferAction:(id)sender {
    WeakSelf(self)
    PGCustomAlertView * alertView = [[PGCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alertView.type = 6;
    [alertView.tipsImg setImage:MPImage(@"withdrawalTips")];
    alertView.titleLabel.text = @"";
    alertView.contentLabel.text = @"确认转入账户余额吗，转入账户余额后不可撤回，只能用于消费";
    [alertView.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    alertView.sureBlock = ^{
        [weakself transferToAccount];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}
- (void)transferToAccount
{
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    [PGAPIService transferToAccountWithParameters:@{@"userid":[PGManager shareModel].userInfo.userid} Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:@"转入成功"];
        [weakself loadBalance];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
#pragma mark===转入到支付宝
- (IBAction)aliBtnAction:(id)sender {
    if ([self.moneyField.text integerValue] < self.userModel.minWithdrawMoney) {
        [QMUITips showWithText:[NSString stringWithFormat:@"最小提现金额为%ld",self.userModel.minWithdrawMoney]];
        return;
    }
    if (self.currentAccountModel == nil) {
        [QMUITips showWithText:@"请选择要提现的账户"];
        return;
    }
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:[NSString stringWithFormat:@"%ld",[self.moneyField.text integerValue]*100] forKey:@"integral"];
    [dic setValue:@"1" forKey:@"type"];
    NSString * timeStampString = [PGUtils getCurrentTimeStamp];
    NSString * sign = [PGParameterSignTool encoingPameterSignWithDic:[NSMutableDictionary dictionaryWithDictionary:dic] andTimeSta:timeStampString];
    [dic setValue:sign forKey:@"sign"];
    [dic setValue:self.moneyField.text forKey:@"money"];
    [dic setValue:@"4" forKey:@"userType"];
    [dic setValue:@[self.currentAccountModel.mj_keyValues] forKey:@"configs"];
    [PGAPIService withdrawalActionWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        weakself.moneyField.text = @"";
        [QMUITips showWithText:@"操作成功"];
        [weakself loadBalance];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
#pragma mark===账户伸缩
- (void)openAction:(UIButton *)sender
{
    self.isShowAccount = !self.isShowAccount;
    [self.tableView reloadData];
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
        _tableView.layer.borderWidth = 1;
        _tableView.layer.borderColor = HEX(#F8F8F8).CGColor;
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"PGWithdrawalTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGWithdrawalTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGNoAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGNoAccountTableViewCell"];
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
