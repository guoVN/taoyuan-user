//
//  YBShowBigVideoVC.m


#import "YBShowBigVideoVC.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFIJKPlayerManager.h>
#import <ZFPlayer/ZFAVPlayerManager.h>

@interface YBShowBigVideoVC (){
    UIView *naviView;
    UIButton *bottomBtn;
}
@property (nonatomic,strong) UIImageView *playImgView;          /// 封面
@property (nonatomic, strong) ZFPlayerController *player;       /// 播放器

@end

@implementation YBShowBigVideoVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

/// 类入口
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.naviView.backBtn setImage:MPImage(@"white_back") forState:UIControlStateNormal];
    _playImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _playImgView.backgroundColor = [UIColor blackColor];
    _playImgView.image = _coverImage;
    if (_isHttpVideo) {
        [_playImgView sd_setImageWithURL:[NSURL URLWithString:_coverThumbStr] placeholderImage:nil];
    }
    _playImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_playImgView];
    [self.view sendSubviewToBack:_playImgView];
    
//    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
//    NSString *ijkRef = [NSString stringWithFormat:@"Referer:%@\r\n",BaseUrl];
//    [playerManager.options setFormatOptionValue:ijkRef forKey:@"headers"];
//    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:_playImgView];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:_playImgView];
    
    NSArray *videoA = videoA = @[[NSURL URLWithString:_videoPath]];
//    if (_isHttpVideo) {
//        videoA = @[[NSURL URLWithString:_videoPath]];
//    }else {
//        videoA = @[[NSURL fileURLWithPath:_videoPath]];
//    }
    self.player.assetURLs = videoA;
    self.player.shouldAutoPlay = YES;
    self.player.allowOrentitaionRotation = NO;
    self.player.pauseWhenAppResignActive = NO;
    self.player.WWANAutoPlay = YES;
    @weakify(self)
    self.player.playerPrepareToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        NSLog(@"结束");
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
    [self.player playTheIndex:0];
    
    [PGUtils changeAVAudioSessionState];

    [self creatView];
}
- (void)creatView{
    self.titleStr = Localized(@"预览");
    self.naviView.titleLabel.textColor = UIColor.whiteColor;
    self.naviView.backgroundColor = HEXAlpha(#000000, 0.5);
}

/// 返回
- (void)clickNaviLeftBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 删除
- (void)doDelete{
    if (self.block) {
        self.block();
    }
    [self clickNaviLeftBtn];
}
- (void)dealloc{

}


@end
