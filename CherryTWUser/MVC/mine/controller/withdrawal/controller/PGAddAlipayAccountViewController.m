//
//  PGAddAlipayAccountViewController.m
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGAddAlipayAccountViewController.h"
//view
#import "PGWriteAccountInfoTableViewCell.h"

@interface PGAddAlipayAccountViewController ()<UITableViewDataSource,UITableViewDelegate,QMUITextFieldDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UILabel * tipsLabel;
@property (nonatomic, strong) UIButton * submitBtn;
@property (nonatomic, copy) NSString * nameStr;
@property (nonatomic, copy) NSString * idCardStr;
@property (nonatomic, copy) NSString * aliAccountStr;
@property (nonatomic, copy) NSString * phoneStr;

@end

@implementation PGAddAlipayAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    self.titleStr = @"添加支付宝";
    [self.naviView yd_setHorizentalGradualFromColor:HEXAlpha(#5F92A1, 0.1f) toColor:HEXAlpha(#823A79, 0.08f)];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-SafeBottom-20);
        make.height.mas_equalTo(40);
    }];
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.submitBtn.mas_top).offset(-9);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.tipsLabel.mas_top).offset(-10);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
    self.dataArray = @[@{@"name":@"请输入姓名",@"value":@""},
//                       @{@"name":@"请输入身份证号码",@"value":@""},
                       @{@"name":@"请输入支付宝账号",@"value":@""},
                       @{@"name":@"请绑定你的手机号",@"value":@""}];
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
    PGWriteAccountInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGWriteAccountInfoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = self.dataArray[indexPath.section];
    cell.titleLabel.text = dic[@"name"];
    cell.valueField.tag = indexPath.section;
    cell.valueField.delegate = self;
    if (indexPath.section == 2) {
        cell.valueField.keyboardType = UIKeyboardTypeNumberPad;
        cell.valueField.maximumTextLength = 11;
    }
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            self.nameStr = textField.text;
            break;
//        case 1:
//            self.idCardStr = textField.text;
//            break;
        case 1:
            self.aliAccountStr = textField.text;
            break;
        case 2:
            self.phoneStr = textField.text;
            break;
            
        default:
            break;
    }
}

#pragma mark===提交
- (void)submitBtnAction
{
    if (self.nameStr.length==0) {
        [QMUITips showWithText:@"请输入姓名"];
        return;
    }
//    else if (self.idCardStr.length==0) {
//        [QMUITips showWithText:@"请输入身份证号"];
//        return;
//    }
    else if (self.aliAccountStr.length==0) {
        [QMUITips showWithText:@"请输入支付宝账号"];
        return;
    }else if (self.phoneStr.length==0) {
        [QMUITips showWithText:@"请输入手机号"];
        return;
    }
    [QMUITips showLoadingInView:self.view];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
//    [dic setValue:@"123" forKey:@"idCard"];
    [dic setValue:@"4" forKey:@"userType"];
    [dic setValue:self.nameStr forKey:@"realName"];
    [dic setValue:@"1" forKey:@"type"];
    [dic setValue:self.aliAccountStr forKey:@"cardNo"];
    [dic setValue:self.phoneStr forKey:@"phone"];
    WeakSelf(self)
    [PGAPIService addWithdrawAccountWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:@"添加成功"];
        if (weakself.addBlock) {
            weakself.addBlock();
        }
        [weakself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
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
        [_tableView registerNib:[UINib nibWithNibName:@"PGWriteAccountInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGWriteAccountInfoTableViewCell"];
    }
    return _tableView;
}
- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 40)];
        [_submitBtn yd_setHorizentalGradualFromColor:HEX(#A0A0EB) toColor:HEX(#E6BEE2)];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = MPFont(16);
        _submitBtn.layer.cornerRadius = 10;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = MPFont(12);
        _tipsLabel.textColor = HEX(#CCCCCC);
        _tipsLabel.text = @"确保绑定银行信息与当前帐号实名认证信息相同才可提现";
    }
    return _tipsLabel;
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
