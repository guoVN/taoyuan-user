//
//  PGBindPhoneViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBindPhoneViewController.h"

@interface PGBindPhoneViewController ()<PGCountDownButtonDelegate>

@property (weak, nonatomic) IBOutlet QMUITextField *phoneField;
@property (weak, nonatomic) IBOutlet QMUITextField *codeField;
@property (weak, nonatomic) IBOutlet PGCountDownButton *sendCodeBtn;

@end

@implementation PGBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
}
- (void)loadUI
{
    self.sendCodeBtn.delegate = self;
}
#pragma mark MPCountDownButtonDelegate
- (void)countDownFinish:(PGCountDownButton *)button {
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    button.enabled = YES;
}

- (IBAction)sendCodeAction:(id)sender {
    if ([self.sendCodeBtn.titleLabel.text containsString:@"s"]) {
        return;
    }
    self.sendCodeBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.sendCodeBtn.enabled = YES;
    });
    [self.view endEditing:YES];
    [self getSmsCode];
}
- (void)getSmsCode
{
    if(self.phoneField.text.length == 0){
        [QMUITips showWithText:Localized(@"请输入手机号")];
        return;
    }
    WeakSelf(self)
    NSString * timeStampString = [PGUtils getCurrentTimeStamp];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.phoneField.text forKey:@"phone"];
    NSString * sign = [PGParameterSignTool encoingPameterSignWithDic:[NSMutableDictionary dictionaryWithDictionary:dic] andTimeSta:timeStampString];
    [dic setValue:sign forKey:@"sign"];
    [dic setValue:@"ppyh" forKey:@"packName"];
    [PGAPIService sendMsgCodeWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.sendCodeBtn.enabled = NO;
        [weakself.sendCodeBtn beginCountDown];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showError:message];
    }];
   
}
- (IBAction)sureBtnAction:(id)sender {
    if(self.phoneField.text.length == 0){
        [QMUITips showWithText:Localized(@"请输入手机号")];
        return;
    }
    if(self.codeField.text.length == 0){
        [QMUITips showWithText:Localized(@"请输入验证码")];
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.phoneField.text forKey:@"phone"];
    [dic setValue:self.codeField.text forKey:@"verifyCode"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    [PGAPIService bindUserPhoneWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [PGManager shareModel].userInfo.phone = weakself.phoneField.text;
        [QMUITips showWithText:@"绑定成功"];
        if (weakself.refreshBlock) {
            weakself.refreshBlock();
        }
        [weakself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
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
