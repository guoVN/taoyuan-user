//
//  PGInviteFriendPageHeaderView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGInviteFriendPageHeaderView.h"
#import "PGInviteFriendCopyAlertView.h"
#import "PGInviteFriendPosterView.h"

@implementation PGInviteFriendPageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PGInviteFriendPageHeaderView class]) owner:nil options:nil] firstObject];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
//    self.inviteCodeLabel.text = [PGManager shareModel].userInfo.invitationCode;
}
- (void)snapSubView
{
    
}

- (void)setInviteModel:(PGInviteModel *)inviteModel
{
    _inviteModel = inviteModel;
    self.inviteCodeLabel.text = inviteModel.invitationCode;
    NSString * urlStr = inviteModel.womanChannelBindDTOS.firstObject.invitationLandingPageLink;
    urlStr = [NSString stringWithFormat:@"%@?channelNo=%@",urlStr,Channel_Name];
    self.linkLabel.text = urlStr;
    self.persentLabel.text = [NSString stringWithFormat:@"获得消费金额%@%@的奖励",inviteModel.inviteUserPercent,@"%"];
}

- (IBAction)copyCodeAction:(id)sender {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.inviteModel.invitationCode;
    [QMUITips showWithText:@"已复制"];
}
- (IBAction)copyLinkAction:(id)sender {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    NSString * urlStr = self.inviteModel.womanChannelBindDTOS.firstObject.invitationLandingPageLink;
    urlStr = [NSString stringWithFormat:@"%@?channelNo=%@",urlStr,Channel_Name];
    paste.string = urlStr;
    PGInviteFriendCopyAlertView * alert = [[PGInviteFriendCopyAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [[UIApplication sharedApplication].delegate.window addSubview:alert];
}
- (IBAction)downImgAction:(id)sender {
    PGInviteFriendPosterView * poster = [[PGInviteFriendPosterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    NSString * urlStr = self.inviteModel.womanChannelBindDTOS.firstObject.invitationLandingPageLink;
    urlStr = [NSString stringWithFormat:@"%@?channelNo=%@",urlStr,Channel_Name];
    poster.inviteCode = self.inviteModel.invitationCode;
    poster.linkUrl = urlStr;
    [[UIApplication sharedApplication].delegate.window addSubview:poster];
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
