//
//  LSYAssetPreview.m
//  AlbumPicker
//
//  Created by okwei on 15/7/31.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "LSYAssetPreview.h"
#import "LSYAssetPreviewView.h"
#import "LSYAssetPreviewItem.h"
#import "LSYAlbumModel.h"
#import "LSYPublicForWechat.h"
@interface LSYAssetPreview ()<UIScrollViewDelegate,LSYAssetPreviewNavBarDelegate,LSYAssetPreviewToolBarDelegate,LSYAssetPreviewItemDelegate>
@property (nonatomic,strong)UIScrollView *previewScrollView;
@property (nonatomic,strong) LSYAssetPreviewNavBar *previewNavBar;
@property (nonatomic,strong) LSYAssetPreviewToolBar *previewToolBar;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@end

@implementation LSYAssetPreview

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self prefersStatusBarHidden];
    self.selectedAssets = [NSMutableArray arrayWithArray:self.assets];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:self.previewScrollView];
    [self.view addSubview:self.previewToolBar];
    [self.view addSubview:self.previewNavBar];
    [self setAssets];
    //当点击缩略图，进入预览功能时，导航栏上方的选择按钮是否被选中
    LSYAlbumModel *model = self.allAssets[self.selectedItem];
    self.previewNavBar.selectButton.selected = model.isSelect;
}
-(UIScrollView *)previewScrollView
{
    if (!_previewScrollView) {
        _previewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,ScreenSize.width, ScreenSize.height)];
        [_previewScrollView setBackgroundColor:[UIColor blackColor]];
        [_previewScrollView setPagingEnabled:YES];
        [_previewScrollView setDelegate:self];
        [_previewScrollView setShowsHorizontalScrollIndicator:NO];
        [_previewScrollView setShowsVerticalScrollIndicator:NO];
        [_previewScrollView setContentOffset:CGPointMake(ScreenSize.width*self.selectedItem, 0)];
    }
    return _previewScrollView;
}
-(LSYAssetPreviewNavBar *)previewNavBar
{
    if (!_previewNavBar) {
        _previewNavBar = [[LSYAssetPreviewNavBar alloc] init];
        [_previewNavBar setBackgroundColor:[UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.75]];
        _previewNavBar.delegate = self;
    }
    return _previewNavBar;
}
-(LSYAssetPreviewToolBar*)previewToolBar
{
    if (!_previewToolBar) {
        _previewToolBar = [[LSYAssetPreviewToolBar alloc] init];
        [_previewToolBar setBackgroundColor:[UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.75]];
        _previewToolBar.delegate = self;
        [_previewToolBar setSendNumber:(int)self.selectedAssets.count];
    }
    return _previewToolBar;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)setAssets
{
    [self.previewScrollView setContentSize:CGSizeMake(ScreenSize.width*self.allAssets.count, ScreenSize.height)];
    for (int i = 0; i<_allAssets.count; i++) {
        LSYAssetPreviewItem *previewItem = [[LSYAssetPreviewItem alloc] initWithFrame:CGRectMake(ScreenSize.width*i, 0, ScreenSize.width, ScreenSize.height)];
        previewItem.delegate = self;
        LSYAlbumModel *model = _allAssets[i];
        previewItem.asset = model.asset;
        self.previewNavBar.selectButton.selected = model.isSelect;
        [self.previewScrollView addSubview:previewItem];
    }
}
#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int assetNumber = scrollView.contentOffset.x/ViewSize(self.view).width;
    LSYAlbumModel *model = self.allAssets[assetNumber];
    self.previewNavBar.selectButton.selected = model.isSelect;
    
}
#pragma mark -LSYAssetPreviewItemDelegate
-(void)hiddenBarControl
{
    _previewNavBar.hidden = !_previewNavBar.hidden;
    _previewToolBar.hidden = !_previewToolBar.hidden;
}
#pragma mark -LSYAssetPreviewNavBarDelegate
-(void)backButtonClick:(UIButton *)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)selectButtonClick:(UIButton *)selectButton
{
    if (self.previewScrollView.isDecelerating) {
        return;
    }
    int assetNumber = self.previewScrollView.contentOffset.x/ViewSize(self.view).width;
    LSYAlbumModel *model = self.allAssets[assetNumber];
    model.isSelect = !model.isSelect;
    self.previewNavBar.selectButton.selected = model.isSelect;
    if (model.isSelect) {
        //[self.AlbumCollection selectItemAtIndexPath:model.indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self.selectedAssets addObject:model];
        //[self.AlbumCollection.delegate collectionView:self.AlbumCollection didSelectItemAtIndexPath:model.indexPath];
        [_delegate didSelectModel:model];//处理上一页的活动
    }
    else
    {
        //[self.AlbumCollection deselectItemAtIndexPath:model.indexPath animated:NO];
        [self.selectedAssets removeObject:model];
        //[self.AlbumCollection.delegate collectionView:self.AlbumCollection didDeselectItemAtIndexPath:model.indexPath];
        [_delegate didSelectModel:model];
    }
    [self.previewToolBar setSendNumber:(int)self.selectedAssets.count/*self.AlbumCollection.indexPathsForSelectedItems.count*/];
}
#pragma mark -LSYAssetPreviewToolBarDelegate
-(void)sendButtonClick:(UIButton *)sendButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AssetPreviewDidFinishPick:)]) {
        NSMutableArray *assets = [NSMutableArray array];
        for (LSYAlbumModel *model in self.selectedAssets) {
            [assets addObject:model.asset];
        }
        [self.delegate AssetPreviewDidFinishPick:assets];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_previewNavBar setFrame:CGRectMake(0, 0, ViewSize(self.view).width, 64)];
    [_previewToolBar setFrame:CGRectMake(0, ViewSize(self.view).height-44, ViewSize(self.view).width, 44)];
}
-(void)dealloc
{
    
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
