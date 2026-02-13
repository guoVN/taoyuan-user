//
//  PGWriteInfoViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/2.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGWriteInfoViewController.h"
#import "PGRegisterViewController.h"

@interface PGWriteInfoViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImgTC;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet QMUITextField *nameField;
@property (nonatomic, strong) UIImage * chooseImg;
@property (nonatomic, copy) NSString * headImgStr;

@end

@implementation PGWriteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    WeakSelf(self)
    [self.headImg jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakself chooseImg:nil];
    }];
}
- (void)uploadHeadImg
{
    WeakSelf(self)
    [QMUITips showLoading:@"头像上传中" inView:self.view];
    [PGAPIService uploadFileWithImages:@[self.chooseImg] Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        NSArray * imgDataArr = data[@"data"];
        NSMutableArray * photoArr = [NSMutableArray array];
        for (NSString * str in imgDataArr) {
            [photoArr addObject:str];
        }
        weakself.headImgStr = [photoArr componentsJoinedByString:@","];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:@"上传失败"];
    }];
}

#pragma mark===下一步
- (IBAction)nextBtnAction:(id)sender {
    if (self.headImgStr.length == 0) {
        [QMUITips showWithText:@"请上传头像"];
        return;
    }
    if (self.nameField.text.length == 0) {
        [QMUITips showWithText:@"请填写昵称"];
        return;
    }
    [self goRegisterAction];
}
- (void)goRegisterAction
{
    NSString * timeStampString = [PGUtils getCurrentTimeStamp];
    NSString * packageName = Package_Name;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.nameField.text forKey:@"nickName"];
    [dic setValue:@"18" forKey:@"age"];
    [dic setValue:self.headImgStr forKey:@"photo"];
    [dic setValue:self.phoneStr forKey:@"phone"];
    [dic setValue:Channel_Name forKey:@"channel"];
    [dic setValue:timeStampString forKey:@"timestamp"];
    [dic setValue:app_Version forKey:@"aversion"];
    [dic setValue:packageName forKey:@"packName"];
    [dic setValue:@"YES" forKey:@"init"];
    [dic setValue:[PGUtils getAdId] forKey:@"oaid"];
    [dic setValue:[PGUtils getAdId] forKey:@"androidid"];
    [dic setValue:@"YES" forKey:@"isRegister"];
    [dic setValue:@"1" forKey:@"isTextChat"];
    [dic setValue:@"0" forKey:@"sex"];
    [dic setValue:[PGManager shareModel].channelNo.length>0?[PGManager shareModel].channelNo:Channel_Name forKey:@"channelNo"];
    [dic setValue:[PGUtils getMacAddress] forKey:@"mac"];
    NSString * sign = [PGParameterSignTool encoingPameterSignWithDic:[NSMutableDictionary dictionaryWithDictionary:dic] andTimeSta:timeStampString];

    [dic setValue:sign forKey:@"sign"];
    [dic setValue:self.smsCodeStr forKey:@"verifyCode"];
    [dic setValue:self.inviteCodeStr.length>0?self.inviteCodeStr:@"" forKey:@"invitationCode"];
    [dic setValue:[PGManager shareModel].promptionChannel forKey:@"promotionChannel"];
    [dic setValue:[PGManager shareModel].userAgent forKey:@"ua"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService userRegisterWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        NSDictionary * dic = data[@"data"];
        [PGUtils loginSuccess:dic];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (IBAction)chooseImg:(id)sender {
    WeakSelf(self)
    [[PGManager shareModel] chooseMediaWith:1 count:1 withCrop:NO selectImg:^(NSArray *imgArr) {
        weakself.chooseImg = imgArr.firstObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.headImg setImage:weakself.chooseImg];
        });
        [weakself uploadHeadImg];
    } selectVideo:^(UIImage *coverImg, NSURL *videoUrl) {
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
