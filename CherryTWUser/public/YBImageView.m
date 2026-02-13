//
//  YBImageView.m


#import "YBImageView.h"
#import "YBShowBigImageView.h"
#import "SDWebImageDownloader.h"
@interface YBImageView ()<UIScrollViewDelegate>{
    
    NSInteger currentIndex;
    UILabel *indexLb;
    UIButton *deleteBtn;
    UIView *navi;
}
@property (nonatomic,copy) YBImageViewBlock returnBlock;

@end
@implementation YBImageView{
    UITapGestureRecognizer *tap;
    UIScrollView *backScrollV;
    NSMutableArray *imageArray;
    NSMutableArray *imgViewArray;
}

/// 初始化
/// @param array 数组
/// @param index 下标
/// @param block 回调
- (instancetype)initWithImageArray:(NSArray *)array andIndex:(NSInteger)index andBlock:(nonnull YBImageViewBlock)block{
    self = [super init];
    imageArray = [array mutableCopy];
    currentIndex = index;
    self.returnBlock = block;
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    if (self) {
        self.userInteractionEnabled = YES;
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showHideNavi)];
        [self addGestureRecognizer:tap];
        backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(ScreenWidth/2, ScreenHeight/2, 0, 0)];
        backScrollV.backgroundColor = [UIColor blackColor];
        backScrollV.contentSize = CGSizeMake(ScreenWidth*imageArray.count, 0);
        backScrollV.contentOffset = CGPointMake(ScreenWidth * index, 0);
        backScrollV.delegate = self;
        backScrollV.pagingEnabled=YES;
        //设置最大伸缩比例
        backScrollV.maximumZoomScale=1;
        //设置最小伸缩比例
        backScrollV.minimumZoomScale=1;
        backScrollV.showsHorizontalScrollIndicator = NO;
        backScrollV.showsVerticalScrollIndicator = NO;

        [self addSubview:backScrollV];
        imgViewArray = [NSMutableArray array];
        for (int i = 0; i < imageArray.count; i++) {
            id imageContent = imageArray[i];
            YBShowBigImageView *imgV = [[YBShowBigImageView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight)];
            if ([imageContent isKindOfClass:[UIImage class]]) {
                imgV.imageView.image = imageContent;
            }else if ([imageContent isKindOfClass:[NSString class]]){
                [imgV.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageContent]] placeholderImage:nil];
            }
            [backScrollV addSubview:imgV];
            [imgViewArray addObject:imgV];
        }
        [self showBigView];
        [self creatNavi];
    }
    return self;
}
- (void)showBigView{
        [UIView animateWithDuration:0.2 animations:^{
            self->backScrollV.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        }];
}

/// 返回
- (void)doreturn{
    [UIView animateWithDuration:0.2 animations:^{
        self->backScrollV.frame = CGRectMake(ScreenWidth/2, ScreenHeight/2, 0, 0);
    }completion:^(BOOL finished) {
        if (self.returnBlock) {
            self.returnBlock(self->imageArray);
        }
        [self->backScrollV removeFromSuperview];
        self->backScrollV = nil;
        [self removeFromSuperview];
    }];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    currentIndex = scrollView.contentOffset.x/ScreenWidth;
    indexLb.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,imageArray.count];

}
-(void)creatNavi {
    
    navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44+STATUS_H_F)];
    navi.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:navi];
    
    
    UIButton *retrunBtn = [UIButton buttonWithType:0];
    retrunBtn.frame = CGRectMake(10, 5+STATUS_H_F, 30, 30);
    [retrunBtn setImage:[UIImage imageNamed:@"white_back"] forState:0];
    [retrunBtn addTarget:self action:@selector(doreturn) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:retrunBtn];
    
    UILabel *titleL = [[UILabel alloc]init];
    titleL.frame = CGRectMake(ScreenWidth/2-40, 5+STATUS_H_F, 80, 30);
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = Localized(@"预览");
    [navi addSubview:titleL];

    
    indexLb = [[UILabel alloc]init];
    indexLb.frame = CGRectMake(ScreenWidth-100, 2+STATUS_H_F, 80, 30);
    indexLb.textColor = [UIColor whiteColor];
    indexLb.font = [UIFont systemFontOfSize:15];
    indexLb.textAlignment = NSTextAlignmentRight;
    indexLb.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,imageArray.count];
    [navi addSubview:indexLb];
    /*
    id imageContent = [imageArray firstObject];
    if ([imageContent isKindOfClass:[UIImage class]] || isMine) {
        deleteBtn = [UIButton buttonWithType:0];
        deleteBtn.frame = CGRectMake(0, ScreenHeight-40, ScreenWidth, 40);
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTitle:rklang(@"删除") forState:0];
        [deleteBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self addSubview:deleteBtn];
    }
    */
    //[[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 63+statusbarHeight, ScreenWidth, 1) andColor:colorf3 andView:navi];
    
}

/// 添加删除按钮
-(void)createDel {
    if (deleteBtn) {
        return;;
    }
    deleteBtn = [UIButton buttonWithType:0];
    deleteBtn.frame = CGRectMake(0, ScreenHeight-40, ScreenWidth, 40);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitle:Localized(@"删除") forState:0];
    [deleteBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [self addSubview:deleteBtn];
}

-(void)deleteBtnClick{
    
    [self deleteSucess];
}

/// 移除成功
- (void)deleteSucess{
    [imageArray removeObjectAtIndex:currentIndex];
    if (imageArray.count == 0) {
        [self doreturn];
    }else{
        UIImageView *imgV = imgViewArray[currentIndex];
        [imgV removeFromSuperview];
        [imgViewArray removeObjectAtIndex:currentIndex];
        if (currentIndex == 0) {
            currentIndex = 0;
        }else{
            currentIndex -= 1;
        }
        indexLb.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,imageArray.count];
        backScrollV.contentSize = CGSizeMake(ScreenWidth*imageArray.count, 0);
        [backScrollV setContentOffset:CGPointMake(ScreenWidth*currentIndex, 0)];
        for (int i = 0; i < imgViewArray.count; i ++) {
            YBShowBigImageView *imgVVVV = imgViewArray[i];
            imgVVVV.qmui_left = ScreenWidth * i;
        }
    }

}
- (void)showHideNavi{
    navi.hidden = !navi.hidden;
    if (deleteBtn) {
        deleteBtn.hidden = navi.hidden;
    }
}
@end
