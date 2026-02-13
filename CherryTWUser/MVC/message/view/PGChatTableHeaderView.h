//
//  PGChatTableHeaderView.h
//  CherryTWUser
//
//  Created by guo on 2025/2/14.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGChatTableHeaderView : UIView

@property (nonatomic, strong) UILabel * tipsLabel;
@property (nonatomic, strong) PGAnchorModel * anchorDetailModel;

@end

NS_ASSUME_NONNULL_END
