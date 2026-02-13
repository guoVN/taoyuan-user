//
//  PGMyAlbumViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/5.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGMyAlbumViewController.h"
#import "TZImagePickerHelper.h"
//model
#import "PGAlbumModel.h"
//view
#import "PGPublishDynamicCollectionViewCell.h"

#define photoCount 8

@interface PGMyAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) NSMutableArray * photoArray;
@property (nonatomic, strong) TZImagePickerHelper * helper;
@property (nonatomic, assign) BOOL isReUpload;
@property (nonatomic, assign) NSInteger currentChooseIndex;
@property (nonatomic, assign) BOOL isEditAlbum;
@property (nonatomic, strong) NSMutableArray * chooseArray;
@property (nonatomic, strong) NSMutableArray * preImgArray;

@end

@implementation PGMyAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadData];
}
- (void)loadUI
{
    [self setTitleBtnStr:@"我的相册"];
    [self.naviView.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.naviView.rightBtn setTitleColor:THEAME_COLOR forState:UIControlStateNormal];
    [self.naviView.rightBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    self.naviView.titleLabel.font = MPFont(16);
    self.naviView.rightBtn.layer.borderWidth = 1;
    self.naviView.rightBtn.layer.borderColor = THEAME_COLOR.CGColor;
    self.naviView.rightBtn.layer.cornerRadius = 14;
    self.naviView.rightBtn.layer.masksToBounds = YES;
    [self.naviView.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(54);
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+44+10);
        make.bottom.mas_equalTo(-SafeBottom-72);
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-SafeBottom-10);
        make.height.mas_equalTo(48+10);
    }];
}
- (void)loadData
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService myAlbumListWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [weakself.photoArray removeAllObjects];
        [weakself.preImgArray removeAllObjects];
        NSArray * items = [PGAlbumModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [weakself.photoArray addObjectsFromArray:items];
        for (PGAlbumModel * model in weakself.photoArray) {
            [weakself.preImgArray addObject:model.photoUrl];
        }
        [weakself.collectionView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count == photoCount ? photoCount : self.photoArray.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self)
    PGPublishDynamicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PGPublishDynamicCollectionViewCell.class) forIndexPath:indexPath];
    if (indexPath.row == self.photoArray.count) {
        cell.addImg.alpha = 1;
        [cell.chooseImg setImage:MPImage(@"")];
        cell.deleteBtn.alpha = cell.chooseBtn.alpha = 0;
    }else{
        cell.addImg.alpha = 0;
        id obb = self.photoArray[indexPath.row];
        if ([obb isKindOfClass:[UIImage class]]) {
            [cell.chooseImg setImage:self.photoArray[indexPath.row]];
        }else{
            PGAlbumModel * model = obb;
            [cell.chooseImg sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:MPImage(@"netFaild")];
        }
        cell.deleteBtn.alpha = 1;
        cell.chooseBtn.alpha = self.isEditAlbum == YES ? 1 : NO;
        cell.chooseBtn.selected = [self.chooseArray containsObject:self.photoArray[indexPath.row]];
    }
    cell.deleteBtn.alpha = 0;
    cell.deleteImgBlock = ^{
        [weakself deleteImg:indexPath.row];
    };
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-6-30)*0.25, (ScreenWidth-6-30)*0.25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.photoArray.count) {
        [self reuploadAction:indexPath.row];
    }else{
        PGPublishDynamicCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (self.isEditAlbum) {
            if (!cell.chooseBtn.selected) {
                [self.chooseArray addObject:self.photoArray[indexPath.row]];
            }else{
                [self.chooseArray removeObject:self.photoArray[indexPath.row]];
            }
        }else{
            id item = self.photoArray[indexPath.row];
            if ([item isKindOfClass:[UIImage class]]) {
                [self reuploadAction:indexPath.row];
            }else{
                [HUPhotoBrowser showFromImageView:cell.chooseImg withURLStrings:self.preImgArray atIndex:indexPath.row];
            }
        }
        [self.collectionView reloadData];
    }
}

- (void)reuploadAction:(NSInteger)row
{
    if (self.photoArray.count > 0 && self.photoArray.count > row) {
        self.isReUpload = YES;
        self.currentChooseIndex = row;
        [self.helper showImagePickerControllerWithMaxCount:1 WithViewController:self];
        return;
    }
    self.isReUpload = NO;
    NSInteger chooseCount = photoCount;
    if (self.photoArray.count >= chooseCount) {
        [PGUtils showPickImageCountLimitAlertView:photoCount];
    } else {
        [self.helper showImagePickerControllerWithMaxCount:(photoCount - self.photoArray.count) WithViewController:self];
    }
}

- (void)deleteImg:(NSInteger)row
{
    [self.photoArray removeObjectAtIndex:row];
    [self.collectionView reloadData];
}
- (void)uploadImg:(UIImage *)image
{
    WeakSelf(self)
    [QMUITips showLoading:@"图片上传中" inView:self.view];
    [PGAPIService uploadFileWithImages:@[image] Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        NSString * imgStr = data[@"data"];
        [weakself upImgsToAlbum:imgStr];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:@"上传失败"];
    }];
}
- (void)upImgsToAlbum:(NSString *)urlStr
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:urlStr forKey:@"imgUrl"];
    [dic setValue:@"0" forKey:@"isDynamic"];
    [dic setValue:@"0" forKey:@"photoType"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService addPhotoToAlbumWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [weakself loadData];
        [weakself.collectionView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)editAction
{
    self.isEditAlbum = YES;
    [self.chooseArray removeAllObjects];
    [self.collectionView reloadData];
    self.bottomView.alpha = 1;
}
- (void)cancelAction
{
    self.isEditAlbum = NO;
    [self.collectionView reloadData];
    self.bottomView.alpha = 0;
}
- (void)sureBtnAction
{
    self.isEditAlbum = NO;
    [self.collectionView reloadData];
    self.bottomView.alpha = 0;
    [self deleteChooseImg];
}
#pragma mark===删除相册照片
- (void)deleteChooseImg
{
    WeakSelf(self)
    NSMutableArray * result = [NSMutableArray array];
    for (PGAlbumModel * model in self.chooseArray) {
        if ([model isKindOfClass:[PGAlbumModel class]]) {
            [result addObject:[NSString stringWithFormat:@"%ld",model.photoid]];
        }
    }
    NSString * photoIdStr = [result componentsJoinedByString:@","];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:photoIdStr forKey:@"photoId"];
    [PGAPIService deleteAlbumPhotoWithParameters:dic Success:^(id  _Nonnull data) {
        [weakself loadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
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
        [_collectionView registerNib:[UINib nibWithNibName:@"PGPublishDynamicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PGPublishDynamicCollectionViewCell"];
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
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        UIButton * cancelBtn = [[UIButton alloc] init];
        cancelBtn.backgroundColor = HEX(#DDDDDD);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HEX(#333333) forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = MPFont(16);
        cancelBtn.layer.cornerRadius = 24;
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancelBtn];
        UIButton * sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth-35)*0.5, 58)];
        [sureBtn yd_setHorizentalGradualFromColor:HEX(#FBAE9C) toColor:HEX(#FF6796)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:UUWhite forState:UIControlStateNormal];
        sureBtn.titleLabel.font = MPFont(16);
        sureBtn.layer.cornerRadius = 24;
        sureBtn.layer.masksToBounds = YES;
        [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:sureBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo((ScreenWidth-35)*0.5);
        }];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo((ScreenWidth-35)*0.5);
        }];
        _bottomView.alpha = 0;
    }
    return _bottomView;
}
- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (NSMutableArray *)preImgArray
{
    if (!_preImgArray) {
        _preImgArray = [NSMutableArray array];
    }
    return _preImgArray;
}
- (NSMutableArray *)chooseArray
{
    if (!_chooseArray) {
        _chooseArray = [NSMutableArray array];
    }
    return _chooseArray;
}
- (TZImagePickerHelper *)helper {
    if (!_helper) {
        _helper = [[TZImagePickerHelper alloc] init];
         WeakSelf(self)
        _helper.finish = ^(NSArray *array){
            for (int i = 0; i< array.count; i++) {
                UIImage *image = [UIImage imageWithContentsOfFile:array[i]];
                NSData *data=UIImageJPEGRepresentation(image,1.0f);
                if (data != nil) {
                    if ([data length]>2*1024*2014) {
                        data = [PGUtils resetSizeOfImageData:[UIImage imageWithData:data] maxSize:2048];
                    }
                    image = [UIImage imageWithData:data];
                }
                if (weakself.isReUpload) {
                    [weakself.photoArray replaceObjectAtIndex:weakself.currentChooseIndex withObject:image];
                }else{
                    [weakself.photoArray addObject:image];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.collectionView reloadData];
                [weakself uploadImg:weakself.photoArray.lastObject];
            });
        };
    }
    return _helper;
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
