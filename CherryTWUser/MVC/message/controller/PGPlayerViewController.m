//
//  PGPlayerViewController.m
//  CherryTWUser
//
//  Created by guo on 2025/1/16.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGPlayerViewController.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFIJKPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/ZFPlayerConst.h>

@interface PGPlayerViewController ()

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation PGPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    @zf_weakify(self)
    self.controlView.backBtnClickCallback = ^{
        @zf_strongify(self)
        [self.player rotateToOrientation:UIInterfaceOrientationPortrait animated:NO completion:nil];
        [self dismissViewControllerAnimated:NO completion:^{
            [self.player stop];
        }];
    };

    WeakSelf(self)
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:self.view];
    self.player.controlView = self.controlView;
//    self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskLandscape;
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        [weakself.player.currentPlayerManager replay];
    };
    
    /// 设置转屏方向
//    [self.player rotateToOrientation:UIInterfaceOrientationLandscapeRight animated:NO completion:nil];
    playerManager.assetURL = [NSURL URLWithString:self.videoUrlStr];
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player enterPortraitFullScreen:YES animated:YES];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.effectViewShow = NO;
        _controlView.prepareShowLoading = YES;
//        _controlView.showCustomStatusBar = YES;
        _controlView.fullScreenMode = ZFFullScreenModePortrait;
    }
    return _controlView;
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
