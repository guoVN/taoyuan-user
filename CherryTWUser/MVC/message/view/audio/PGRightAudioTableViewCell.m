//
//  PGRightAudioTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/29.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGRightAudioTableViewCell.h"

@interface PGRightAudioTableViewCell ()<AVAudioPlayerDelegate>

@property AVAudioPlayer * audioPlayer;

@end

@implementation PGRightAudioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.audioView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)]];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
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

- (void)downAudio:(NSString *)path
{
    WeakSelf(self)
    [PGAPIService downFileWithUrl:self.chatModel.contenStr filePath:path Success:^(id  _Nonnull data) {
        NSURL *url = [NSURL URLWithString:data];
        weakself.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [weakself.audioPlayer prepareToPlay];
        weakself.secondLabel.text = [NSString stringWithFormat:@"%.0f''",weakself.audioPlayer.duration];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakself.chatModel = weakself.chatModel;
        });
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
 */
- (void)playAudio
{
    self.audioPlayer.delegate = self;
    [[PGManager shareModel].audioPlayer stop];
    [PGManager shareModel].audioPlayer = self.audioPlayer;
    [[PGManager shareModel].audioPlayer play];
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"audioPlayR_%d",i];
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


@end
