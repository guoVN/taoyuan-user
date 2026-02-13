//
//  PGWriteInviteCodeViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/18.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGWriteInviteCodeViewController.h"
//view
#import "PGWriteInviteCodeSureView.h"
#import "PGWriteInviteCodeWarningView.h"

@interface PGWriteInviteCodeViewController ()
@property (weak, nonatomic) IBOutlet QMUITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) PGWriteInviteCodeWarningView * warnView;
@property (nonatomic, strong) PGWriteInviteCodeSureView * sureView;

@end

@implementation PGWriteInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
}
- (void)loadUI
{
    self.titleBtnStr = @"绑定邀请码";
    self.sureBtn.frame = CGRectMake(0, 0, ScreenWidth-40, 60);
    [self.sureBtn yd_setHorizentalGradualFromColor:HEX(#FBAE9C) toColor:HEX(#FF6796)];
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 32)];
    self.codeField.leftView = leftView;
    self.codeField.leftViewMode = UITextFieldViewModeAlways;
}
- (IBAction)sureBtnAction:(id)sender {
    if (self.codeField.text.length == 0) {
        return;
    }
    [[UIApplication sharedApplication].delegate.window addSubview:self.sureView];
}
- (void)doBindCode
{
    WeakSelf(self)
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:app_Version forKey:@"version"];
    [dic setValue:self.codeField.text forKey:@"invitationCode"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService writeInviteCodeWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:@"邀请码绑定成功"];
        if (weakself.bindInviteCodeBlock) {
            weakself.bindInviteCodeBlock(weakself.codeField.text);
        }
        [weakself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [[UIApplication sharedApplication].delegate.window addSubview:self.warnView];
    }];
}

- (PGWriteInviteCodeWarningView *)warnView
{
    if (!_warnView) {
        _warnView = [[PGWriteInviteCodeWarningView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return _warnView;
}
- (PGWriteInviteCodeSureView *)sureView
{
    WeakSelf(self)
    if (!_sureView) {
        _sureView = [[PGWriteInviteCodeSureView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _sureView.sureBlock = ^{
            [weakself doBindCode];
        };
    }
    return _sureView;
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
