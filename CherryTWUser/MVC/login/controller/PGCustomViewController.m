//
//  PGCustomViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/2.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGCustomViewController.h"
#import "PGWritePhoneViewController.h"
#import "PGWriteInfoViewController.h"

@interface PGCustomViewController ()

@end

@implementation PGCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
}

- (void)loadUI
{

}
- (IBAction)touristBtnAction:(id)sender {
    PGWriteInfoViewController * vc = [[PGWriteInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)enterBtnAction:(id)sender {
    PGWritePhoneViewController * vc = [[PGWritePhoneViewController alloc] init];
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
