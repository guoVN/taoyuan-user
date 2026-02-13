//
//  YBImageView.h


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^YBImageViewBlock)(NSArray *array);
@interface YBImageView : UIView
/// 初始化
/// @param array 数组
/// @param index 下标
/// @param block 回调
- (instancetype)initWithImageArray:(NSArray *)array andIndex:(NSInteger)index andBlock:(YBImageViewBlock)block;

/// 添加删除
-(void)createDel;
@end

NS_ASSUME_NONNULL_END
