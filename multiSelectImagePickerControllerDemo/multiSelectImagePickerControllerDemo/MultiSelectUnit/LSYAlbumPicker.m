//
//  LSYAlbumPicker.m
//  AlbumPicker
//
//  Created by okwei on 15/7/23.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "LSYAlbumPicker.h"
#import "LSYDelegateDataSource.h"
#import "LSYAlbum.h"
#import "LSYPickerButtomView.h"
#import "LSYAssetPreview.h"
#import "LSYAlbumCell.h"
#import "LSYPublicForWechat.h"
#import "PreviewViewController.h"
@interface LSYAlbumPicker ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LSYPickerButtomViewDelegate,LSYAssetPreviewDelegate,PreviewViewControllerDelegate>
@property (nonatomic,strong) UICollectionView *albumView;
@property (nonatomic,strong) LSYDelegateDataSource *albumDelegateDataSource;
@property (nonatomic,strong) NSMutableArray *albumAssets;
@property (nonatomic,strong) LSYPickerButtomView *pickerButtomView;
@property (nonatomic,strong) NSMutableArray *assetsSort;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic)int selectNumbers;
@end

@implementation LSYAlbumPicker

-(UICollectionView *)albumView
{
    if (!_albumView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = kThumbnailSize;
        flowLayout.sectionInset = UIEdgeInsetsMake(5,5,5, 5);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        _albumView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ViewSize(self.view).width, ViewSize(self.view).height-44) collectionViewLayout:flowLayout];
        _albumView.allowsMultipleSelection = YES;
        [_albumView registerClass:[LSYAlbumCell class] forCellWithReuseIdentifier:@"albumCellIdentifer"];
        _albumView.delegate = self;
        _albumView.dataSource = self;//self.albumDelegateDataSource;
        _albumView.backgroundColor = [UIColor whiteColor];
        _albumView.alwaysBounceVertical = YES;
    }
    return _albumView;
}
-(LSYDelegateDataSource *)albumDelegateDataSource
{
    if (!_albumDelegateDataSource) {
        _albumDelegateDataSource = [[LSYDelegateDataSource alloc] init];
    }
    return _albumDelegateDataSource;
}
-(LSYPickerButtomView *)pickerButtomView
{
    if (!_pickerButtomView) {
        _pickerButtomView = [[LSYPickerButtomView alloc] initWithFrame:CGRectMake(0, ViewSize(self.view).height-44, ViewSize(self.view).width, 44) withToolbarDisplayText:self.toolbarDisplayText];
        _pickerButtomView.delegate = self;
        [_pickerButtomView setSendNumber:self.selectNumbers];
    }
    return _pickerButtomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.group valueForProperty:ALAssetsGroupPropertyName];
    self.assetsSort = [NSMutableArray array];
    [self.view addSubview:self.albumView];
    [self.view addSubview:self.pickerButtomView];
    [[LSYAlbum sharedAlbum] setupAlbumAssets:self.group withAssets:^(NSMutableArray *assets) {
        self.albumAssets = assets;
        self.albumDelegateDataSource.albumDataArray = assets;
        [self.albumView reloadData];
    }];
    // Do any additional setup after loading the view.
}
-(void)setSelectNumbers:(int)selectNumbers
{
    _selectNumbers = selectNumbers;
    [self.pickerButtomView setSendNumber:selectNumbers];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.selectNumbers = (int)self.albumView.indexPathsForSelectedItems.count;
    self.selectNumbers = (int)self.assetsSort.count;
}
#pragma mark -LSYPickerButtomViewDelegate
-(void)previewButtonClick
{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
        
    }
    [_selectedAssets removeAllObjects];
    for (NSIndexPath *indexPath in self.assetsSort) {
        [_selectedAssets addObject:self.albumAssets[indexPath.item]];
    }

    LSYAssetPreview *assetPreview = [[LSYAssetPreview alloc] init];
    [self.navigationController pushViewController:assetPreview animated:YES];
    assetPreview.allAssets = self.selectedAssets;
    assetPreview.assets = self.selectedAssets;
    assetPreview.selectedItem = 0;
    assetPreview.AlbumCollection = self.albumView;
    assetPreview.delegate = self;
}
-(void)sendButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AlbumPickerDidFinishPick:)]) {
        NSMutableArray *assets = [NSMutableArray array];
        for (LSYAlbumModel *model in self.selectedAssets) {
            [assets addObject:model.asset];
        }
        [self.delegate AlbumPickerDidFinishPick:assets];
    }
    
}
#pragma mark -LSYAssetPreviewDelegate
-(void)AssetPreviewDidFinishPick:(NSArray *)assets
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AlbumPickerDidFinishPick:)]){
        [self.delegate AlbumPickerDidFinishPick:assets];
    }
}

-(void)didSelectModel:(LSYAlbumModel*)m
{
     LSYAlbumCell*cell=(LSYAlbumCell*)[_albumView cellForItemAtIndexPath:m.indexPath];
    if (m.isSelect) {
        [self.assetsSort addObject:m.indexPath];
        [cell.statusView setImage:[UIImage imageNamed:@"photo_selected"]];
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.statusView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                cell.statusView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                    cell.statusView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }
    else
    {
        [self.assetsSort removeObject:m.indexPath];
        [cell.statusView setImage:[UIImage imageNamed:@"photo_unselected"]];
    }
    
    self.selectNumbers = (int)self.assetsSort.count;

}


#pragma mark -UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.albumDelegateDataSource.albumDataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSYAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"albumCellIdentifer" forIndexPath:indexPath];
    UITapGestureRecognizer*gestureTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImage:)];
    [cell.statusView addGestureRecognizer:gestureTap];
    LSYAlbumModel *model = self.albumDelegateDataSource.albumDataArray[indexPath.row];
    model.indexPath = indexPath;
    for (NSIndexPath*tmpIndex in self.assetsSort) {
        if([tmpIndex isEqual:indexPath]){
            model.isSelect = YES;
            break;
        }
            
    }
    //NSLog(@"cell设备图片按钮被点击:%ld        %ld",(long)indexPath.section,(long)indexPath.row);
    cell.model = model;
    return cell;
}

-(void)chooseImage:(UITapGestureRecognizer *)recognizer
{
    if (self.maxminumNumber) {
        if (!(self.maxminumNumber>self.assetsSort.count)) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能选%d张照片",(int)self.maxminumNumber] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
    
    UIImageView*v = (UIImageView*)recognizer.view;
    UIImageView*vv =(UIImageView*)[v superview];
    LSYAlbumCell*cell = (LSYAlbumCell*)[[vv superview]superview];
    NSIndexPath *indexpath = [_albumView indexPathForCell:cell];//获取cell对应的indexpath;
    NSLog(@"设备图片按钮被点击:%ld        %ld",(long)indexpath.section,(long)indexpath.row);
    cell.model.isSelect = !cell.model.isSelect;
    if (cell.model.isSelect) {
        [self.assetsSort addObject:indexpath];
        [cell.statusView setImage:[UIImage imageNamed:@"photo_selected"]];
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.statusView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                cell.statusView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                    cell.statusView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }
    else
    {
        [self.assetsSort removeObject:indexpath];
        [cell.statusView setImage:[UIImage imageNamed:@"photo_unselected"]];
    }
    
    self.selectNumbers = (int)self.assetsSort.count;
    
}



#pragma mark -UICollectionViewDelegate
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*self.selectNumbers = (int)collectionView.indexPathsForSelectedItems.count;
    [self.assetsSort addObject:indexPath];*/
    /*LSYAssetPreview *assetPreview = [[LSYAssetPreview alloc] init];
    assetPreview.allAssets = self.albumAssets;
    assetPreview.assets = self.selectedAssets;
    assetPreview.selectedItem =indexPath.item;
    assetPreview.AlbumCollection = self.albumView;
    assetPreview.delegate = self;
    [self.navigationController pushViewController:assetPreview animated:YES];*/
    PreviewViewController*pvc = [[PreviewViewController alloc]init];
    pvc.toolbarDisplayText = self.toolbarDisplayText;
    pvc.allAssets  = self.albumAssets;
    pvc.assets = self.selectedAssets;
    pvc.delegate = self;
    pvc.selectedItem =indexPath.item;
    
    //[self presentViewController:pvc animated:YES completion:nil];
    [self.navigationController pushViewController:pvc animated:YES];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*self.selectNumbers = (int)collectionView.indexPathsForSelectedItems.count;
    [self.assetsSort removeObject:indexPath];*/
}
-(NSMutableArray *)selectedAssets
{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
       
    }
    [_selectedAssets removeAllObjects];
    for (NSIndexPath *indexPath in self.assetsSort) {
        [_selectedAssets addObject:self.albumAssets[indexPath.item]];
    }
    return _selectedAssets;
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
