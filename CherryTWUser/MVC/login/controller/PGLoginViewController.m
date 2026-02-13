//
//  PGLoginViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGLoginViewController.h"

@interface PGLoginViewController ()<PGCountDownButtonDelegate>

@property (weak, nonatomic) IBOutlet QMUITextField *smsCodeField;
@property (weak, nonatomic) IBOutlet PGCountDownButton *sendCodeBtn;

@end

@implementation PGLoginViewController

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
    [dic setValue:@"stl" forKey:@"packName"];
    [PGAPIService sendMsgCodeWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.sendCodeBtn.enabled = NO;
        [weakself.sendCodeBtn beginCountDown];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showError:message];
    }];
}
- (IBAction)sureBtnAction:(id)sender {
    NSString * packageName = Package_Name;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.phoneStr forKey:@"phone"];
    [dic setValue:self.smsCodeField.text forKey:@"verifyCode"];
    [dic setValue:packageName forKey:@"packName"];
    [dic setValue:[PGUtils getAdId] forKey:@"oaid"];
    [dic setValue:[PGUtils getAdId] forKey:@"androidid"];
    [dic setValue:[PGUtils getAdId] forKey:@"imei"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService phoneLoginWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        NSDictionary * dic = data[@"data"];
        [PGUtils loginSuccess:dic];
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
