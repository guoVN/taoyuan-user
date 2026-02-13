//
//  YBShowBigVideoVC.h


#import "PGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^videoDeleteBlock)(void);

@interface YBShowBigVideoVC : PGBaseViewController
@property (nonatomic,strong) NSString *videoPath;       /// 视频地址
@property (nonatomic,copy) videoDeleteBlock block;      /// 回调

@property(nonatomic,assign)BOOL isHttpVideo;            /// 是否是网络视频【YES网络-NO本地】
@property (nonatomic,strong) UIImage *coverImage;       //本地封面
@property(nonatomic,strong)NSString *coverThumbStr;     //远程封面

@end

NS_ASSUME_NONNULL_END
