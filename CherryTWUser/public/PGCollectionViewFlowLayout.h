//
//  PGCollectionViewFlowLayout.h
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray * dataArray;
///文字左右距离和
@property (nonatomic, assign) CGFloat addWidth;

@property (nonatomic, assign) CGFloat fontNum;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) CGFloat cellSpace;

@property (nonatomic, assign) CGFloat cellSpaceY;
///cell的x绝对坐标
@property (nonatomic, assign) CGFloat itemLeft;

@property (nonatomic, assign) CGFloat collectViewWidth;

@end

NS_ASSUME_NONNULL_END
