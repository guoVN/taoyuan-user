//
//  PGDynamicHeaderView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGDynamicHeaderView : UIView

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIImageView * headImg;
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) NSArray * noticeArray;

@end

NS_ASSUME_NONNULL_END
