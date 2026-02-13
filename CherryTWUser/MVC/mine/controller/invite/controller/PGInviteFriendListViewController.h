//
//  PGInviteFriendListViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"
#import <JXPagingView/JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGInviteFriendListViewController : PGBaseViewController<JXPagerViewListViewDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) JXPagerMainTableView * superMainTableView;

@end

NS_ASSUME_NONNULL_END
