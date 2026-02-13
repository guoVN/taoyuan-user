//
//  HMProjectMenuView.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMProjectMenuView : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITableView * tableView;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
