//
//  PGWaterFollowLayout.h
//  CherryTWUser
//
//  Created by guo on 2025/11/13.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    PGWaterFlowVerticalEqualWidth = 0, /** 竖向瀑布流 item等宽不等高 */
    PGWaterFlowHorizontalEqualHeight = 1, /** 水平瀑布流 item等高不等宽 不支持头脚视图*/
    PGWaterFlowVerticalEqualHeight = 2,  /** 竖向瀑布流 item等高不等宽 */
    PGWaterFlowHorizontalGrid = 3,  /** 特为国务院客户端原创栏目滑块样式定制-水平栅格布局  仅供学习交流*/
    PGLineWaterFlow = 4 /** 线性布局 待完成，敬请期待 */
} PGWaterFollowLayoutStyle; //样式

@class PGWaterFollowLayout;

@protocol PGWaterFollowLayoutDelegate <NSObject>

/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为YDWaterFlowVerticalEqualWidth 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 YDWaterFlowHorizontalEqualHeight 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 YDWaterFlowHorizontalGrid   传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 YDWaterFlowVerticalEqualHeight 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 */
- (CGSize)waterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 头视图Size */
-(CGSize )waterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )waterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section;

@optional //以下都有默认值
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout;
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout;

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout;
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout;
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout;

@end

@interface PGWaterFollowLayout : UICollectionViewLayout

/** delegate*/
@property (nonatomic, weak) id<PGWaterFollowLayoutDelegate> delegate;
/** 瀑布流样式*/
@property (nonatomic, assign) PGWaterFollowLayoutStyle  flowLayoutStyle;

@end

NS_ASSUME_NONNULL_END
