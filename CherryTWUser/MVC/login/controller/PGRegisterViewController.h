//
//  PGRegisterViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGRegisterViewController : PGBaseViewController

@property (weak, nonatomic) IBOutlet QMUITextField *smsCodeField;
@property (weak, nonatomic) IBOutlet PGCountDownButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet QMUITextField *inviteCodeField;

@property (nonatomic, copy) NSString * phoneStr;

@end

NS_ASSUME_NONNULL_END
