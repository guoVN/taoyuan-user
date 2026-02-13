//
//  PGCountDownButton.m
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#import "PGCountDownButton.h"

@interface PGCountDownButton(){
    dispatch_source_t timer;
}

@property (nonatomic,assign)NSInteger second;

@end

@implementation PGCountDownButton

- (void)beginCountDown {
        
    __block NSInteger times = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    LRWeakSelf(self);
    dispatch_source_set_event_handler(timer, ^{
        
        if(times <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(self->timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself setTitle:@"重新获取" forState:UIControlStateNormal];
                [weakself setTitleColor:THEAME_COLOR forState:UIControlStateNormal];
                if ([weakself.delegate respondsToSelector:@selector(countDownFinish:)]) {
                    [weakself.delegate countDownFinish:self];
                }
            });
            
        }else{
            
            int seconds = times % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString * showText = [NSString stringWithFormat:@"%ds",seconds];
                [self setTitle:showText forState:UIControlStateNormal];
                [self setTitleColor:HEX(#6D6D6D) forState:UIControlStateNormal];
                
                
            });
            
            times--;
            
            
            
        }
    });
    
    dispatch_resume(timer);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
