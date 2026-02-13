//
//  PGRegisterViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGRegisterViewController.h"
#import "PGWriteInfoViewController.h"
//model
#import "PGLoginModel.h"

@interface PGRegisterViewController ()<PGCountDownButtonDelegate>

@end

@implementation PGRegisterViewController

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
    WeakSelf(self)
    NSString * timeStampString = [PGUtils getCurrentTimeStamp];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.phoneStr forKey:@"phone"];
    NSString * sign = [PGParameterSignTool encoingPameterSignWithDic:[NSMutableDictionary dictionaryWithDictionary:dic] andTimeSta:timeStampString];
    [dic setValue:sign forKey:@"sign"];
    [dic setValue:@"sywl" forKey:@"packName"];
    [PGAPIService sendMsgCodeWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.sendCodeBtn.enabled = NO;
        [weakself.sendCodeBtn beginCountDown];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showError:message];
    }];
}

- (IBAction)sureBtnAction:(id)sender {
    if (self.smsCodeField.text.length == 0) {
        [QMUITips showWithText:@"请输入验证码"];
        return;
    }
    PGWriteInfoViewController * vc = [[PGWriteInfoViewController alloc] init];
    vc.phoneStr = self.phoneStr;
    vc.smsCodeStr = self.smsCodeField.text;
    vc.inviteCodeStr = self.inviteCodeField.text;
    [self.navigationController pushViewController:vc animated:YES];
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
