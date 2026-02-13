//
//  PGAudioSessionObject.h
//  CherryTWUser
//
//  Created by guo on 2024/12/19.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGAudioSessionObject : NSObject


/// 创建单利
+ (PGAudioSessionObject *)shareManager;
 
/// 创建音乐播放器
- (void)creatAVAudioSessionObject;
 
/// 开始播放音乐
- (void)startPlayAudioSession;
 
/// 停止播放音乐
- (void)stopPlayAudioSession;

@end

NS_ASSUME_NONNULL_END
