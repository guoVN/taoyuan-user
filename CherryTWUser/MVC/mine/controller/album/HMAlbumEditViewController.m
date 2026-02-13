//
//  HMAlbumEditViewController.m
//  HoneyMelonAnchor
//
//  Created by guo on 2025/8/28.
//

#import "HMAlbumEditViewController.h"
#import "HMAlbumCollectionViewCell.h"
#import "HMChooseImgCollectionViewCell.h"

#define photoCount 10

@interface HMAlbumEditViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@end

@implementation HMAlbumEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    self.titleStr = Localized(@"相册修改");
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
    return self.photoArray.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self)
    if (indexPath.row == self.photoArray.count) {
        HMChooseImgCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HMChooseImgCollectionViewCell.class) forIndexPath:indexPath];
        
        return cell;
    }else{
        HMAlbumCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HMAlbumCollectionViewCell.class) forIndexPath:indexPath];
        cell.isEidtPage = YES;
        cell.model = self.photoArray[indexPath.row];
        cell.deleteImgBlock = ^{
            [weakself.photoArray removeObjectAtIndex:indexPath.row];
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
    if (indexPath.row == self.photoArray.count) {
        if (self.photoArray.count == photoCount) {
            [QMUITips showWithText:Localized(@"相册照片不能多于十张")];
            return;
        }
        [[HMManager shareModel] chooseMediaWith:1 count:1 withCrop:NO selectImg:^(NSArray *imgArr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.photoArray addObjectsFromArray:imgArr];
                [weakself uploadImg:imgArr];
                [weakself.collectionView reloadData];
             });
        } selectVideo:^(UIImage *coverImg, NSURL *videoUrl) {
        }];
    }else{
        NSMutableArray * imgArr = [NSMutableArray array];
        for (NSInteger i=0; i<self.photoArray.count; i++) {
            id model = self.photoArray[i];
            if ([model isKindOfClass:[HMAlbumListModel class]]) {
                HMAlbumListModel * mm = model;
                [imgArr addObject:mm.photoUrl];
            }else if ([model isKindOfClass:[UIImage class]]){
                [imgArr addObject:model];
            }
        }
        YBImageView *imgView = [[YBImageView alloc] initWithImageArray:imgArr andIndex:indexPath.row andBlock:^(NSArray * _Nonnull array) {
        }];
        [[UIApplication sharedApplication].delegate.window addSubview:imgView];
    }
}

- (void)uploadImg:(NSArray *)imgArr
{
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    [HMNetService uploadFileWithImages:imgArr Success:^(id  _Nonnull data) {
        [weakself checkImg:data[@"data"]];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
    }];
}
- (void)checkImg:(NSArray *)imgDataArr
{
    NSMutableArray * photoArr = [NSMutableArray array];
    for (NSString * str in imgDataArr) {
        [photoArr addObject:str];
    }
    NSString * imgStr = [photoArr componentsJoinedByString:@","];
    [self doUploadAction:imgStr];
//    WeakSelf(self)
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:@"IMAGE" forKey:@"eventId"];
//    [dic setValue:imgStr forKey:@"img"];
//    [dic setValue:[HMManager shareModel].userInfo.userid forKey:@"userid"];
//    [HMNetService shumeiImgCheckWithParameters:dic Success:^(id  _Nonnull data) {
//        [QMUITips hideAllTips];
//        [weakself doUploadAction:imgStr];
//    } failure:^(NSInteger code, NSString * _Nonnull message) {
//        [QMUITips hideAllTips];
//        [QMUITips showWithText:message];
//    }];
}
- (void)doUploadAction:(NSString *)imgStr
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:imgStr forKey:@"imgUrl"];
    [dic setValue:@"0" forKey:@"isDynamic"];
    [dic setValue:[HMManager shareModel].userInfo.userid forKey:@"userId"];
    WeakSelf(self)
    [HMNetService uploadPhotoToAlbumWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        NSArray * items = [HMAlbumListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [weakself.photoArray replaceObjectAtIndex:weakself.photoArray.count-1 withObject:items.firstObject];
        [weakself.collectionView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
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
- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
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
