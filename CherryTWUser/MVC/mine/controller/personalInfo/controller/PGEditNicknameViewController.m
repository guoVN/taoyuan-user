//
//  PGEditNicknameViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/6.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGEditNicknameViewController.h"

@interface PGEditNicknameViewController ()
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (nonatomic, strong) QMUIButton * submitBtn;

@end

@implementation PGEditNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
}
- (void)loadUI
{
    self.view.backgroundColor = HEX(#EDEEF2);
    if (self.type == 1) {
        self.textField.maximumTextLength = 5;
    }
    self.titleStr = self.type == 1 ? @"编辑昵称" : @"更改个性签名";
    self.textField.placeholder = self.type == 1 ? @"请输入昵称" : @"请输入个性签名";
    self.textField.text = self.contentStr;
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.naviView.titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(52, 26));
    }];
}
- (void)submitBtnAction {
    if (self.textField.text.length == 0) {
        return;
    }
    if (self.type == 1) {
        WeakSelf(self)
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
        [dic setValue:self.textField.text forKey:@"name"];
        [QMUITips showLoadingInView:self.view];
        [PGAPIService updateNickNameWithParameters:dic Success:^(id  _Nonnull data) {
            [QMUITips hideAllTips];
            if (weakself.updateBlock) {
                weakself.updateBlock(weakself.textField.text);
            }
            [weakself.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:message];
        }];
    }else if (self.type == 2){
        [[NSUserDefaults standardUserDefaults] setValue:self.textField.text forKey:@"signStr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [QMUITips showWithText:@"保存成功"];
        if (self.updateBlock) {
            self.updateBlock(self.textField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (QMUIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[QMUIButton alloc] init];
        _submitBtn.backgroundColor = HEX(#FF6B97);
        [_submitBtn setTitle:Localized(@"完成") forState:UIControlStateNormal];
        [_submitBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = MPFont(14);
        _submitBtn.layer.cornerRadius = 5;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        _submitBtn.enabled = NO;
    }
    return _submitBtn;
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
