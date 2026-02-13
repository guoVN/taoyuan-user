//
//  ViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/4/7.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView * lanuchImg;
@property (nonatomic, strong) UILabel * tipsLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
//    [self loadLanuchImg];
}
- (void)loadUI
{
    [self.view addSubview:self.lanuchImg];
    [self.lanuchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+108);
        make.height.mas_equalTo(384);
    }];
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.lanuchImg.mas_bottom).offset(124);
        make.height.mas_equalTo(25);
    }];
}
- (UIImageView *)lanuchImg
{
    if (!_lanuchImg) {
        _lanuchImg = [[UIImageView alloc] init];
        _lanuchImg.contentMode = UIViewContentModeScaleAspectFit;
        [_lanuchImg setImage:MPImage(@"launchBg")];
    }
    return _lanuchImg;
}
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = MPLightFont(18);
        _tipsLabel.textColor = HEX(#000000);
        _tipsLabel.text = Localized(@"吃块糖，补充下体力");
    }
    return _tipsLabel;
}

@end
