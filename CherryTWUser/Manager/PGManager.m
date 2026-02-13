//
//  PGManager.m
//  CherryTWUser
//
//  Created by guo on 2024/4/9.
//

#import "PGManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "HMMaskCircleHoleView.h"

@interface PGManager ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, assign) CGFloat compressionQuality;

// 使用 NSCache 缓存缩略图
@property (nonatomic, strong) NSCache *thumbnailCache;

@end

@implementation PGManager

+(PGManager*)shareModel
{
    static PGManager *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[PGManager alloc] init];
    });
    
    return model;
}
- (void)chooseMediaWithSelectImg:(chooseImgSuccessBlock)imgBlock selectVideo:(finishChooseVideoBlock)videoBlock
{
    WeakSelf(self)
    self.imgBlock = imgBlock;
    self.videoBlock = videoBlock;
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
    .wTypeSet(DialogTypeSheet)
    //完成操作事件
    .wEventFinishSet(^(id anyID,NSIndexPath *path, DialogType type) {
        if (path.row == 0) {
            [weakself publishDynamicWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }else if (path.row == 1){
            [weakself publishDynamicWithType:UIImagePickerControllerSourceTypeCamera];
        }
    })
    .wShowAnimationSet(AninatonShowTop)
    .wHideAnimationSet(AninatonHideTop)
    .wAnimationDurtionSet(0.2)
    .wMainRadiusSet(10)
    .wDataSet(@[Localized(@"相册"),Localized(@"拍照")])
    .wCancelTitleSet(Localized(@"取消"))
    /// 添加下划线
    .wSeparatorStyleSet(UITableViewCellSeparatorStyleSingleLine)
    /// 下划线透明度
    .wLineAlphaSet(0.5)
    /// cell高度
    .wCellHeightSet(50)
    .wStart();
}
- (void)publishDynamicWithType:(UIImagePickerControllerSourceType)type
{
    if (type == UIImagePickerControllerSourceTypeCamera) {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = type;
        imagePickerController.allowsEditing = YES;
        imagePickerController.showsCameraControls = YES;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagePickerController.modalPresentationStyle = 0;
        imagePickerController.videoMaximumDuration = 15;
        [[PGUtils getCurrentVC] presentViewController:imagePickerController animated:YES completion:nil];
    }else {
        TZImagePickerController *imagePC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
        imagePC.showSelectBtn = NO;
        imagePC.allowCrop = NO;
        imagePC.cropRect = CGRectMake(0, (ScreenHeight-ScreenWidth)/2, ScreenWidth, ScreenWidth);
        imagePC.allowPickingOriginalPhoto = NO;
        imagePC.oKButtonTitleColorNormal = HEX(#A0A0EB);
        imagePC.allowTakePicture = NO;
        imagePC.allowTakeVideo = YES;
        imagePC.allowPickingVideo = YES;
        imagePC.allowPickingMultipleVideo = YES;
        imagePC.sortAscendingByModificationDate = NO;
        imagePC.videoMaximumDuration = 15;
        imagePC.modalPresentationStyle = 0;
        [[PGUtils getCurrentVC] presentViewController:imagePC animated:YES completion:nil];
    }
}
- (void)chooseMediaWith:(NSInteger)mediaType count:(NSInteger)count withCrop:(BOOL)crop selectImg:(chooseImgSuccessBlock)imgBlock selectVideo:(finishChooseVideoBlock)videoBlock
{
    WeakSelf(self)
    self.imgBlock = imgBlock;
    self.videoBlock = videoBlock;
    NSArray * titlesArr = @[];
    if (mediaType == 1) {
        titlesArr = @[Localized(@"相册"),Localized(@"拍照")];
    }else if(mediaType == 2){
        titlesArr = @[Localized(@"相册"),Localized(@"录制")];
    }
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
    .wTypeSet(DialogTypeSheet)
    //完成操作事件
    .wEventFinishSet(^(id anyID,NSIndexPath *path, DialogType type) {
        if (path.row == 0) {
            [weakself selectThumbWithType:UIImagePickerControllerSourceTypePhotoLibrary count:count withCrop:crop withType:mediaType];
        }else if (path.row == 1){
            [weakself selectThumbWithType:UIImagePickerControllerSourceTypeCamera count:count withCrop:crop withType:mediaType];
        }
    })
    .wShowAnimationSet(AninatonShowTop)
    .wHideAnimationSet(AninatonHideTop)
    .wAnimationDurtionSet(0.2)
    .wMainRadiusSet(10)
    .wDataSet(titlesArr)
    .wCancelTitleSet(Localized(@"取消"))
    /// 添加下划线
    .wSeparatorStyleSet(UITableViewCellSeparatorStyleSingleLine)
    /// 下划线透明度
    .wLineAlphaSet(0.5)
    /// cell高度
    .wCellHeightSet(50)
    .wStart();
}
- (void)selectThumbWithType:(UIImagePickerControllerSourceType)type count:(NSInteger)count withCrop:(BOOL)crop withType:(NSInteger)mediaType{
    
    if (mediaType == 1) {
        if (type == UIImagePickerControllerSourceTypeCamera) {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = type;
            imagePickerController.allowsEditing = YES;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.modalPresentationStyle = 0;
            imagePickerController.videoMaximumDuration = 15;
            [[PGUtils getCurrentVC] presentViewController:imagePickerController animated:YES completion:nil];
        }else {
            TZImagePickerController *imagePC = [[TZImagePickerController alloc]initWithMaxImagesCount:count delegate:self];
            imagePC.showSelectBtn = NO;
            imagePC.allowCrop = crop;
            imagePC.needCircleCrop = NO;
            imagePC.cropRect = CGRectMake(10, (ScreenHeight-472)/2, ScreenWidth-20, 472);
            imagePC.allowPickingOriginalPhoto = NO;
            imagePC.oKButtonTitleColorNormal = HEX(#A0A0EB);
            imagePC.allowTakePicture = NO;
            imagePC.allowTakeVideo = NO;
            imagePC.allowPickingVideo = NO;
            imagePC.allowPickingMultipleVideo = NO;
            imagePC.sortAscendingByModificationDate = NO;
            imagePC.videoMaximumDuration = 15;
            imagePC.modalPresentationStyle = 0;
            imagePC.cropViewSettingBlock = ^(UIView *cropView) {
                HMMaskCircleHoleView *maskView = [[HMMaskCircleHoleView alloc] initWithFrame:cropView.bounds];
                    maskView.circleRadius = (ScreenWidth-22)/2;
                    [cropView addSubview:maskView];
            };
            [[PGUtils getCurrentVC] presentViewController:imagePC animated:YES completion:nil];
        }
    }else if (mediaType == 2){
        if (type == UIImagePickerControllerSourceTypeCamera) {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = type;
            imagePickerController.allowsEditing = YES;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
            //视频上传质量
                //UIImagePickerControllerQualityTypeHigh高清
                //UIImagePickerControllerQualityTypeMedium中等质量
                //UIImagePickerControllerQualityTypeLow低质量
                //UIImagePickerControllerQualityType640x480
            imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
            //设置摄像头模式（拍照，录制视频）为录像模式
            imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            imagePickerController.videoMaximumDuration = 15;
            if ([[[UIDevice
                  currentDevice] systemVersion] floatValue] >= 8.0)
            {
                imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            }
            imagePickerController.modalPresentationStyle = 0;
            [[PGUtils getCurrentVC] presentViewController:imagePickerController animated:YES completion:nil];
        }else{
            TZImagePickerController *imagePC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
            imagePC.showSelectBtn = NO;
            imagePC.allowCrop = crop;
            imagePC.allowPickingOriginalPhoto = NO;
            imagePC.oKButtonTitleColorNormal = HEX(#A0A0EB);
            imagePC.allowPickingImage = NO;
            imagePC.allowTakePicture = NO;
            imagePC.allowTakeVideo = YES;
            imagePC.allowPickingVideo = YES;
            imagePC.allowPickingMultipleVideo = NO;
            imagePC.videoMaximumDuration = 15;
            imagePC.sortAscendingByModificationDate = NO;
            imagePC.modalPresentationStyle = 0;
            [[PGUtils getCurrentVC] presentViewController:imagePC animated:YES completion:nil];
        }
    }
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    NSLog(@"-dsddddddddd--%@\n===%@",asset,coverImage);
    if (asset.duration>15) {
        [QMUITips showWithText:Localized(@"视频时长不能超过15秒")];
        return;
    }
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetMediumQuality success:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        if (outputPath) {
            NSURL * videoUrl = [NSURL fileURLWithPath:outputPath];
            UIImage *image = [PGUtils thumbnailImageForVideo:videoUrl];
            // 1. 处理图片
            image = [self imageProcessing:image];
            self.videoBlock(image, videoUrl);
        }else{
            
        }

    } failure:^(NSString *errorMessage, NSError *error) {
      
    }];
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    NSLog(@"------多选择图片--：%@",photos);
    if (photos.count > 0) {
        //先把图片转成NSData
        self.imgBlock(photos);
    }
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        self.imgBlock(@[[info objectForKey:@"UIImagePickerControllerOriginalImage"]]);
    }else if([type isEqualToString:@"public.movie"]){
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMUITips showLoading:Localized(@"处理中") inView:[PGUtils getCurrentVC].view];
            });
            NSURL * videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
            UIImage *image = [PGUtils thumbnailImageForVideo:videoUrl];
            // 1. 处理图片
            image = [self imageProcessing:image];
            self.videoBlock(image, videoUrl);
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMUITips hideAllTips];
            });
        });
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}

/**
 处理图片

 @param image image
 @return return 新图片
 */
- (UIImage *)imageProcessing:(UIImage *)image
{
    UIImageOrientation imageOrientation = image.imageOrientation;
    if (imageOrientation != UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    CGSize imagesize = image.size;
    //质量压缩系数
    self.compressionQuality = 1;
    
    //如果大于两倍屏宽 或者两倍屏高
    if (image.size.width > 640 || image.size.height > 568*2)
    {
        self.compressionQuality = 0.5;
        //宽大于高
        if (image.size.width > image.size.height)
        {
            imagesize.width = 320*2;
            imagesize.height = image.size.height*imagesize.width/image.size.width;
        }
        else
        {
            imagesize.height = 568*2;
            imagesize.width = image.size.width*imagesize.height/image.size.height;
        }
    }
    else
    {
        self.compressionQuality = 0.6;
    }
    
    // 对图片大小进行压缩
    UIImage *newImage = [UIImage imageWithImage:image scaledToSize:imagesize];
    return newImage;
}

- (void)getVideoThumbnailAsync:(NSURL *)videoURL completion:(void(^)(UIImage *thumbnail))completion {
    if (!videoURL) {
           if (completion) completion(nil);
           return;
       }
       
       // 先检查缓存
       NSString *cacheKey = videoURL.absoluteString;
       UIImage *cachedImage = [self.thumbnailCache objectForKey:cacheKey];
       if (cachedImage) {
           if (completion) completion(cachedImage);
           return;
       }
       
       // 异步获取
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           @autoreleasepool {
               AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @NO}];
               
               // 检查asset是否可读
               if (!asset.readable) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (completion) completion(nil);
                   });
                   return;
               }
               
               AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
               generator.appliesPreferredTrackTransform = YES;
               generator.requestedTimeToleranceBefore = kCMTimeZero;
               generator.requestedTimeToleranceAfter = kCMTimeZero;
               generator.maximumSize = CGSizeMake(200, 200); // 限制尺寸提高性能
               
               CMTime time = CMTimeMakeWithSeconds(0.1, 600); // 0.1秒的位置，避免黑帧
               NSError *error = nil;
               CGImageRef imageRef = [generator copyCGImageAtTime:time actualTime:NULL error:&error];
               
               if (!error && imageRef) {
                   UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
                   CGImageRelease(imageRef);
                   
                   // 缓存结果
                   if (thumbnail) {
                       // 计算图片成本（字节大小）
                       NSData *imageData = UIImageJPEGRepresentation(thumbnail, 0.8);
                       NSUInteger cost = imageData.length;
                       [self.thumbnailCache setObject:thumbnail forKey:cacheKey cost:cost];
                   }
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (completion) completion(thumbnail);
                   });
               } else {
                   NSLog(@"生成缩略图失败: %@", error);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (completion) completion(nil);
                   });
               }
           }
       });
}

- (NSCache *)thumbnailCache {
    if (!_thumbnailCache) {
        _thumbnailCache = [[NSCache alloc] init];
        _thumbnailCache.name = @"VideoThumbnailCache";
        _thumbnailCache.countLimit = 50; // 缓存50张图片
        _thumbnailCache.totalCostLimit = 50 * 1024 * 1024; // 50MB内存限制
    }
    return _thumbnailCache;
}

- (void)getAliOssInfo
{
    [PGAPIService getAliOSSInfoWithParameters:@{} Success:^(id  _Nonnull data) {
        NSDictionary * dic = data;
        [PGManager shareModel].AccessKeyId = dic[@"AccessKeyId"];
        [PGManager shareModel].AccessKeySecret = dic[@"AccessKeySecret"];
        [PGManager shareModel].SecurityToken = dic[@"SecurityToken"];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}

@end
