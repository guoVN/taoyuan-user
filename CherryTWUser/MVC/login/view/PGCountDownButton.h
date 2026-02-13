//
//  PGCountDownButton.h
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PGCountDownButton;

@protocol PGCountDownButtonDelegate <NSObject>
/**
 倒计时结束
 */
- (void)countDownFinish:(PGCountDownButton *)button;

@end

@interface PGCountDownButton : UIButton

@property (nonatomic, weak) id<PGCountDownButtonDelegate> delegate;

- (void)beginCountDown;

@end

NS_ASSUME_NONNULL_END
