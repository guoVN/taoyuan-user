//
//  PGPublishDynamicViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/5.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGPublishDynamicViewController.h"
#import "TZImagePickerHelper.h"
//view
#import "PGPublishDynamicCollectionViewCell.h"

#define photoCount 5

@interface PGPublishDynamicViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) QMUITextView * textView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) UIButton * submitBtn;
@property (nonatomic, strong) NSMutableArray * photoArray;
@property (nonatomic, strong) TZImagePickerHelper * helper;
@property (nonatomic, assign) BOOL isReUpload;
@property (nonatomic, assign) NSInteger currentChooseIndex;

@end

@implementation PGPublishDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    [self setTitleBtnStr:@"发布动态"];
    [self.view yd_setVeticalGradualFromColor:HEXAlpha(#FFECF2, 0.5) toColor:HEX(#FFFFFF)];
    self.naviView.backBtn.alpha = 1;
    [self.naviView.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(STATUS_H_F+44+10);
        make.height.mas_equalTo(100);
    }];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.submitBtn];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.bottom.equalTo(self.submitBtn.mas_top).offset(-10);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(-SafeBottom-14);
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
        cell.deleteBtn.alpha = 0;
    }else{
        cell.addImg.alpha = 0;
        [cell.chooseImg setImage:self.photoArray[indexPath.row]];
        cell.deleteBtn.alpha = 1;
    }
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
    return CGSizeMake(115, 115);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
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
    [self reuploadAction:indexPath.row];
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
#pragma mark===发布
- (void)submitBtnAction
{
    if (self.textView.text.length == 0) {
        [QMUITips showWithText:@"说点什么吧"];
        return;
    }
    WeakSelf(self)
    if (self.photoArray.count>0) {
        NSMutableArray * urlArr = [NSMutableArray array];
        [QMUITips showLoading:@"图片上传中" inView:self.view];
        for (NSInteger i=0; i<self.photoArray.count; i++) {
            [PGAPIService uploadFileWithImages:@[self.photoArray[i]] Success:^(id  _Nonnull data) {
                NSString * imgStr = data[@"data"];
                [urlArr addObject:imgStr];
                if (urlArr.count==weakself.photoArray.count) {
                    [QMUITips hideAllTips];
                    [weakself doPublish:weakself.textView.text withImg:urlArr];
                }
            } failure:^(NSInteger code, NSString * _Nonnull message) {
                [QMUITips hideAllTips];
                [QMUITips showWithText:@"上传失败"];
            }];
        }
    }else{
        [self doPublish:self.textView.text withImg:@[]];
    }
}
- (void)doPublish:(NSString *)content withImg:(NSArray *)urlArr
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:content forKey:@"content"];
    if (urlArr.count>0) {
        NSString * urlStr = [urlArr componentsJoinedByString:@","];
        [dic setValue:urlStr forKey:@"photoUrl"];
    }
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    [PGAPIService publishDynamicWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:@"发布成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDynamic" object:nil userInfo:nil];
        [weakself backBtnAction:weakself.naviView.backBtn];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}

- (void)backBtnAction:(QMUIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (QMUITextView *)textView
{
    if (!_textView) {
        _textView = [[QMUITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.placeholder = @"写下你想说的话，分享你的生活...";
        _textView.placeholderColor = HEX(#999999);
        _textView.font = MPFont(18);
        _textView.textColor = HEX(#333333);
        _textView.maximumTextLength = 200;
    }
    return _textView;
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
- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-80, 60)];
        [_submitBtn yd_setHorizentalGradualFromColor:HEX(#FBAE9C) toColor:HEX(#FF6796)];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        _submitBtn.layer.cornerRadius = 30;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
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
