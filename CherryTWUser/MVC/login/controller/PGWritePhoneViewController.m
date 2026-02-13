//
//  PGWritePhoneViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGWritePhoneViewController.h"
#import "PGRegisterViewController.h"
#import "PGLoginViewController.h"

@interface PGWritePhoneViewController ()
@property (weak, nonatomic) IBOutlet QMUITextField *phoneField;

@end

@implementation PGWritePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
}
- (void)loadUI
{
    
}
- (IBAction)nextBtnAction:(id)sender {
    if (self.phoneField.text.length != 11) {
        [QMUITips showWithText:@"请填写正确的手机号"];
        return;
    }
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGUtils getAdId] forKey:@"androidid"];
    [dic setValue:[PGUtils getAdId] forKey:@"imei"];
    [dic setValue:[PGUtils getAdId] forKey:@"oaid"];
    [dic setValue:Package_Name forKey:@"packName"];
    [dic setValue:self.phoneField.text forKey:@"phone"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService checkPhoneWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        if (![data[@"data"] isKindOfClass:[NSNull class]]) {
            PGLoginViewController * vc = [[PGLoginViewController alloc] init];
            vc.phoneStr = weakself.phoneField.text;
            [weakself.navigationController pushViewController:vc animated:YES];
        }else{
            PGRegisterViewController * vc = [[PGRegisterViewController alloc] init];
            vc.phoneStr = weakself.phoneField.text;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
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
