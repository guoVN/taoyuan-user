//
//  PGPickerView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/6.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGPickerView : UIView

@property (nonatomic, strong) UIView * menuView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIPickerView * pickView;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, copy) void(^choosePickBlock)(NSString * result);

@end

NS_ASSUME_NONNULL_END
