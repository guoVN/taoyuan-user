//
//  PGEmojiView.m
//  CherryTWUser
//
//  Created by guo on 2025/1/5.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGEmojiView.h"

@interface PGEmojiView ()

@end

@implementation PGEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    self.pickerVC = [[MCEmojiPickerViewController alloc] init];
    self.pickerVC.sourceView = self;
    self.pickerVC.isDismissAfterChoosing = NO;
    self.pickerVC.view.frame = CGRectMake(0, 0, ScreenWidth, 300);
    [self addSubview:self.pickerVC.view];
}
- (void)snapSubView
{
    
}

#pragma mark===懒加载

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
