//
//  PGReportViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/5.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGReportViewController.h"
#import "PGPublishDynamicCollectionViewCell.h"
#import "HMPublishSuccessAlertView.h"

#define photoCount 3

@interface PGReportViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) QMUITextView * textView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) QMUIButton * submitBtn;
@property (nonatomic, strong) NSMutableArray * photoArray;
@property (nonatomic, copy) NSString * photoStr;

@end

@implementation PGReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    self.titleStr = Localized(@"举报");
    self.view.backgroundColor = HEX(#FFFFFF);
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(STATUS_H_F+55);
        make.height.mas_equalTo(170);
    }];
    UILabel * nameLabel2 = [[UILabel alloc] init];
    nameLabel2.font = MPFont(14);
    nameLabel2.textColor = HEX(#000000);
    nameLabel2.text = Localized(@"上传凭证");
    [self.view addSubview:nameLabel2];
    [nameLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(nameLabel2.mas_bottom).offset(10);
    }];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.naviView.titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(52, 26));
    }];
    self.photoStr = @"";
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
    return CGSizeMake((ScreenWidth-50)/3.0, (ScreenWidth-50)/3.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 10, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
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
        if (self.photoArray.count==4) {
            [QMUITips showWithText:Localized(@"最多允许4张图片")];
            return;
        }
        [self reuploadAction:indexPath.row];
    }else{
        NSMutableArray * imgA = [NSMutableArray array];
        for (NSInteger i=0; i<self.photoArray.count; i++) {
            [imgA addObject:self.photoArray[i]];
        }
        PGPublishDynamicCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
        [HUPhotoBrowser showFromImageView:cell withURLStrings:imgA atIndex:indexPath.row];
    }
}
- (void)reuploadAction:(NSInteger)row
{
     WeakSelf(self)
     [[PGManager shareModel] chooseMediaWith:1 count:4-self.photoArray.count withCrop:NO selectImg:^(NSArray * _Nonnull imgArr) {
         [weakself.photoArray addObjectsFromArray:imgArr];
         [weakself.collectionView reloadData];
     } selectVideo:^(UIImage * _Nonnull coverImg, NSURL * _Nonnull videoUrl) {
         
     }];
}

- (void)deleteImg:(NSInteger)row
{
    [self.photoArray removeObjectAtIndex:row];
    [self.collectionView reloadData];
}
#pragma mark===提交
- (void)submitBtnAction
{
    [self.textView resignFirstResponder];
    self.submitBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.submitBtn.enabled = YES;
    });
    if (self.textView.text.length == 0) {
        [QMUITips showWithText:Localized(@"请描述被举报人的不当行为（200字以内）")];
        return;
    }
    if (self.photoArray.count>0) {
        [self uploadImg];
    }else{
        [self doSubmitAction];
    }
}
- (void)uploadImg
{
     WeakSelf(self)
     [PGAPIService uploadFileWithImages:self.photoArray Success:^(id  _Nonnull data) {
         NSArray * photoArr = data[@"data"];
         weakself.photoStr = [photoArr componentsJoinedByString:@","];
         [weakself doSubmitAction];
     } failure:^(NSInteger code, NSString * _Nonnull message) {
         [QMUITips showWithText:message];
     }];
}
- (void)doSubmitAction
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:self.textView.text forKey:@"reason"];
    [dic setValue:self.anchorId forKey:@"anchorId"];
    [dic setValue:self.photoStr forKey:@"evidence"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService reportWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [weakself reportSuccess];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)reportSuccess
{
    WeakSelf(self)
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
        .wLevelSet(999)
        .wTagSet(random()%100000)
        .wTypeSet(DialogTypeMyView)
        .wShowAnimationSet(AninatonZoomInCombin)
        .wHideAnimationSet(AninatonZoomOut)
        .wShadowCanTapSet(NO)
        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
            mainView.backgroundColor = [UIColor clearColor];
            HMPublishSuccessAlertView *view = [[HMPublishSuccessAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-70, 178) superView:mainView];
                view.messageLabel.text = Localized(@"举报成功，已向管理员发送举报通知。");
                view.sureBlock = ^{
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                };
                return view;
            })
        .wStart();
}

- (QMUITextView *)textView
{
    if (!_textView) {
        _textView = [[QMUITextView alloc] init];
        _textView.backgroundColor = HEX(#F0F2F4);
        _textView.placeholder = Localized(@"请描述被举报人的不当行为（200字以内）");
        _textView.placeholderColor = HEX(#9DA2A8);
        _textView.font = MPFont(14);
        _textView.textColor = HEX(#000000);
        _textView.maximumTextLength = 200;
        _textView.layer.cornerRadius = 10;
        _textView.layer.masksToBounds = YES;
        _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
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
- (QMUIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[QMUIButton alloc] init];
        _submitBtn.backgroundColor = HEX(#FF6B97);
        [_submitBtn setTitle:Localized(@"完成") forState:UIControlStateNormal];
        [_submitBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = MPFont(14);
        _submitBtn.layer.cornerRadius = 5;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
