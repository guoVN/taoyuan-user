//
//  PGLeftAudioTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/29.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGLeftAudioTableViewCell.h"
#import "PGPersonalDetailViewController.h"
#import "PGRightAudioTableViewCell.h"

@interface PGLeftAudioTableViewCell ()<AVAudioPlayerDelegate>

@property AVAudioPlayer * audioPlayer;

@end

@implementation PGLeftAudioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.audioView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)]];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    // 监听停止动画的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopVoiceMessage)
                                                     name:kShouldStopVoiceMessageNotification
                                                   object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
- (void)setChatModel:(PGMessageChatModel *)chatModel
{
    _chatModel = chatModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:chatModel.headStr] placeholderImage:MPImage(@"netFaild")];
    NSString * path = @"fshyAudio";
    BOOL isDir = false;
    NSURL * fileUrl = [NSURL URLWithString:self.chatModel.contenStr];
    NSString * fileName = fileUrl.lastPathComponent;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSString * filePath = [docPath stringByAppendingPathComponent:@"fshyAudio"];
    filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSData* data = [NSData dataWithContentsOfURL:url] ;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        bool result = [self.audioPlayer prepareToPlay];
        self.secondLabel.text = [NSString stringWithFormat:@"%.0f''",self.audioPlayer.duration];
        self.audioViewWC.constant = self.audioPlayer.duration/60.0*60+64;
        if (!result) {
            [self downAudio:path];
        }
    }else{
        [self downAudio:path];
    }
    self.audioPlayer.delegate = self;
}
 */

- (void)setMsdDic:(NSDictionary *)msdDic
{
    _msdDic = msdDic;
    NSString * contentStr = msdDic[@"content"];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.friendHead] placeholderImage:MPImage(@"womanDefault")];
    NSURL *fileUrl = [NSURL URLWithString:contentStr];
    NSString *fileName = fileUrl.lastPathComponent;

    // 获取 Caches 目录下的 fshyAudio 文件夹作为下载目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = [paths lastObject];
    NSString *audioDir = [cachesPath stringByAppendingPathComponent:@"fshyAudio"];

    // 本地完整文件路径
    NSString *localFilePath = [audioDir stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath]) {
        NSData *data = [NSData dataWithContentsOfFile:localFilePath];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        bool result = [self.audioPlayer prepareToPlay];
        self.secondLabel.text = [NSString stringWithFormat:@"%.0f''",self.audioPlayer.duration];
        self.audioViewWC.constant = self.audioPlayer.duration/60.0*60+64;
        if (!result) {
            [self downAudio:contentStr filePath:audioDir];
        }
    }else{
        [self downAudio:contentStr filePath:audioDir];
    }
    self.audioPlayer.delegate = self;
}

- (void)downAudio:(NSString *)url filePath:(NSString *)path
{
    WeakSelf(self)
    [PGAPIService downFileWithUrl:url filePath:path Success:^(id  _Nonnull data) {
        NSURL *url = [NSURL URLWithString:data];
        weakself.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [weakself.audioPlayer prepareToPlay];
        weakself.secondLabel.text = [NSString stringWithFormat:@"%.0f''",weakself.audioPlayer.duration];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)setFriendHead:(NSString *)friendHead
{
    _friendHead = friendHead;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:friendHead]];
}
- (void)playAudio
{
    // 让所有正在播放动画的 cell 停止
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldStopVoiceMessageNotification object:nil];
    
    self.audioPlayer.delegate = self;
    [[PGManager shareModel].audioPlayer stop];
    [PGManager shareModel].audioPlayer = self.audioPlayer;
    [PGManager shareModel].audioPlayer.currentTime = 0;
    [[PGManager shareModel].audioPlayer play];
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"audioPlay_%d",i];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    [self.audioImg setAnimationImages:images];
    [self.audioImg setAnimationDuration:1];
    [self.audioImg setAnimationRepeatCount:0];
    [self.audioImg startAnimating];
}
- (void)stopVoiceMessage {
    [self.audioImg stopAnimating];
    if ([[PGManager shareModel].audioPlayer isPlaying]) {
        [[PGManager shareModel].audioPlayer stop];
        [PGManager shareModel].audioPlayer = nil;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    [self stopVoiceMessage];
}
- (void)headClick
{
    PGPersonalDetailViewController * vc = [[PGPersonalDetailViewController alloc] init];
    vc.anchorid = self.channelId;
    vc.isFromChat = YES;
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
