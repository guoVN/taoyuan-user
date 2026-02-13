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
//    if(self.accountField.text.length == 0){
//        [QMUITips showWithText:Localized(@"Please enter your email")];
//        return;
//    }
    WeakSelf(self)
//    NSDictionary * dic = @{@"account":self.accountField.text};
//    [MPAPIService sendMsgCodeWithParameters:dic Success:^(id  _Nonnull data) {
//        weakself.sendCodeBtn.enabled = NO;
        [weakself.sendCodeBtn beginCountDown];
//    } failure:^(NSInteger code, NSString * _Nonnull message) {
//        [QMUITips showError:message];
//    }];
   
}
- (IBAction)sureBtnAction:(id)sender {
    
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
