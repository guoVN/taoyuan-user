//
//  HMEditVideoViewController.m
//  CherryTWanchor
//
//  Created by guo on 2025/8/30.
//

#import "HMEditVideoViewController.h"
#import "HMAlbumCollectionViewCell.h"
#import "HMChooseImgCollectionViewCell.h"
#import "YBShowBigVideoVC.h"

#define photoCount 10

@interface HMEditVideoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@end

@implementation HMEditVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    self.titleStr = Localized(@"视频修改");
    self.view.backgroundColor = UIColor.whiteColor;
    [self.naviView.navImg setImage:MPImage(@"liushuiBavBg")];
    self.naviView.showNavImg = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
}
#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.videoArray.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self)
    if (indexPath.row == self.videoArray.count) {
        HMChooseImgCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HMChooseImgCollectionViewCell.class) forIndexPath:indexPath];
        [cell.iconImg setImage:MPImage(@"uploadVideo")];
        cell.titleLabel.text = Localized(@"上传视频");
        return cell;
    }else{
        HMAlbumCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HMAlbumCollectionViewCell.class) forIndexPath:indexPath];
        cell.isVideo = YES;
        cell.isEidtPage = YES;
        cell.videoModel = self.videoArray[indexPath.row];
        cell.deleteImgBlock = ^{
            [weakself.videoArray removeObjectAtIndex:indexPath.row];
            [weakself.collectionView reloadData];
        };
        return cell;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-26-10)/3.0, (ScreenWidth-26-10)/3.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(13, 13, 13, 13);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf(self)
    if (indexPath.row == self.videoArray.count) {
        if (self.videoArray.count == photoCount) {
            [QMUITips showWithText:Localized(@"视频不能多于十个")];
            return;
        }
        [[PGManager shareModel] chooseMediaWith:2 count:1 withCrop:NO selectImg:^(NSArray * _Nonnull imgArr) {
                    
        } selectVideo:^(UIImage * _Nonnull coverImg, NSURL * _Nonnull videoUrl) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary * dic = @{@"img":coverImg,@"url":videoUrl};
                [weakself.videoArray addObject:dic];
                [weakself uploadCoverImg:coverImg video:videoUrl];
                [weakself.collectionView reloadData];
             });
        }];
    }else{
        id videoModel = self.videoArray[indexPath.row];
        YBShowBigVideoVC *vc = [[YBShowBigVideoVC alloc]init];
        if ([videoModel isKindOfClass:[HMVideoListModel class]]) {
            HMVideoListModel * vv = videoModel;
            vc.isHttpVideo = YES;
            vc.videoPath = vv.videoUrl;
            vc.coverThumbStr = vv.thumbnailUrl;
        }else if ([videoModel isKindOfClass:[NSDictionary class]]){
            NSDictionary * dic = videoModel;
            NSURL * videoUrl = dic[@"url"];
            vc.isHttpVideo = NO;
            vc.videoPath = videoUrl.absoluteString;
            vc.coverImage = dic[@"img"];
        }
        vc.block = ^{
            
        };
        [self.navigationController pushViewController:vc animated:NO];
    }
}
- (void)uploadCoverImg:(UIImage *)coverImg video:(NSURL *)videoUrl
{
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    [PGAPIService uploadFileWithImages:@[coverImg] Success:^(id  _Nonnull data) {
        NSArray * imgDataArr = data[@"data"];
        NSMutableArray * photoArr = [NSMutableArray array];
        for (NSString * str in imgDataArr) {
            [photoArr addObject:str];
        }
        NSString * imgStr = [photoArr componentsJoinedByString:@","];
        [weakself shumeiThumbCheck:imgStr video:videoUrl];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
    }];
}
- (void)shumeiThumbCheck:(NSString *)imgStr video:(NSURL *)videoUrl
{
    [self uploadVideo:videoUrl withThumb:imgStr];
//    WeakSelf(self)
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:@"IMAGE" forKey:@"eventId"];
//    [dic setValue:imgStr forKey:@"img"];
//    [dic setValue:[HMManager shareModel].userInfo.userid forKey:@"userid"];
//    [HMNetService shumeiImgCheckWithParameters:dic Success:^(id  _Nonnull data) {
//        [weakself uploadVideo:videoUrl withThumb:imgStr];
//    } failure:^(NSInteger code, NSString * _Nonnull message) {
//        [QMUITips hideAllTips];
//        [QMUITips showWithText:message];
//    }];
}
- (void)uploadVideo:(NSURL *)videoUrl withThumb:(NSString *)imgStr
{
    WeakSelf(self)
    [PGAPIService uploadVideoFileWithImages:@[videoUrl] Success:^(id  _Nonnull data) {
        [weakself doVideoUpload:data[@"data"] thumb:imgStr];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
    }];
}
- (void)doVideoUpload:(NSArray *)videoArr thumb:(NSString *)thumbStr
{
    NSMutableArray * videoDataArr = [NSMutableArray array];
    for (NSString * str in videoArr) {
        [videoDataArr addObject:str];
    }
    NSString * videoStr = [videoDataArr componentsJoinedByString:@","];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:videoStr forKey:@"imgUrl"];
    [dic setValue:@"0" forKey:@"isDynamic"];
    [dic setValue:thumbStr forKey:@"thumbnailUrl"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    WeakSelf(self)
    [PGAPIService uploadVideoToVideoWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        HMVideoListModel * model = [HMVideoListModel mj_objectWithKeyValues:data[@"data"]];
        [weakself.videoArray replaceObjectAtIndex:weakself.videoArray.count-1 withObject:model];
        [weakself.collectionView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
    }];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"HMAlbumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMAlbumCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HMChooseImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMChooseImgCollectionViewCell"];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = UICollectionViewFlowLayout.new;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.estimatedItemSize = CGSizeZero;
    }
    return _flowLayout;
}
- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
