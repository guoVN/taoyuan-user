//
//  PGInviteTableHeaderView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGInviteTableHeaderView.h"

@implementation PGInviteTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PGInviteTableHeaderView class]) owner:nil options:nil] firstObject];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    
}
- (void)snapSubView
{
    
}

- (void)setIncomeModel:(PGInviteInComeModel *)incomeModel
{
    _incomeModel = incomeModel;
    self.leftTitleLabel.text = @"今日钻石奖励";
    self.leftNumLabel.text = [NSString stringWithFormat:@"%.0f",incomeModel.todayInviterSum*0.1];
    self.rightTitleLabel.text = @"昨日钻石奖励";
    self.rightNumLabel.text = [NSString stringWithFormat:@"%.0f",incomeModel.yesterdayInviterSum*0.1];
}
- (void)setFriendModel:(PGInviteInFriendModel *)friendModel
{
    _friendModel = friendModel;
    self.leftTitleLabel.text = @"今日邀请好友";
    self.leftNumLabel.text = [NSString stringWithFormat:@"%ld",friendModel.todayCount];
    self.rightTitleLabel.text = @"昨日邀请好友";
    self.rightNumLabel.text = [NSString stringWithFormat:@"%ld",friendModel.yesterdayCount];
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
