//
//  PreviewViewController.m
//  xxt_xj
//
//  Created by hw on 16/9/26.
//  Copyright © 2016年 hw. All rights reserved.
//

#import "PreviewViewController.h"
#import "PhotoCollectionCell.h"
#import "LSYAlbumModel.h"
//#import "PhotoCollectionViewFlowLayout.h"


@interface PreviewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation PreviewViewController
{
    UICollectionView*_collectionView;
    //int _selectingItem;//正在选择的item
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    //[self setAutomaticallyAdjustsScrollViewInsets:NO];
    //[self prefersStatusBarHidden];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//10
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    _collectionView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width*_selectedItem, 0);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = false;//去掉滚动条
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:@"COLLECTION_CELL"];
    [self.view addSubview:_collectionView];
    [_collectionView reloadData];

    [self.view addSubview:self.previewToolBar];
    [self.view addSubview:self.previewNavBar];
    LSYAlbumModel *model = self.allAssets[_selectedItem];
    self.previewNavBar.selectButton.selected = model.isSelect;
     [self.previewToolBar setSendNumber:(int)self.assets.count/*self.AlbumCollection.indexPathsForSelectedItems.count*/];
    
   
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
        _previewToolBar = [[LSYAssetPreviewToolBar alloc] initWithToolbarDisplayText:self.toolbarDisplayText];
        [_previewToolBar setBackgroundColor:[UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.75]];
        //_previewToolBar.toolbarDisplayText = self.toolbarDisplayText;
        _previewToolBar.delegate = self;
        [_previewToolBar setSendNumber:(int)self.assets.count];
    }
    return _previewToolBar;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -LSYAssetPreviewNavBarDelegate
-(void)backButtonClick:(UIButton *)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
/*-(void)selectButtonClick:(UIButton *)selectButton
{
    if(_collectionView.isDecelerating){
        return;
    }
    LSYAlbumModel *model = self.allAssets[_selectedItem];
    model.isSelect = !model.isSelect;
    model.indexPath =[NSIndexPath indexPathForItem:_selectedItem inSection:0];
    self.previewNavBar.selectButton.selected = model.isSelect;
    if (model.isSelect) {
        //[self.AlbumCollection selectItemAtIndexPath:model.indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self.assets addObject:model];
        //[self.AlbumCollection.delegate collectionView:self.AlbumCollection didSelectItemAtIndexPath:model.indexPath];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectModel:)]) {
            [self.delegate didSelectModel:model];//处理上一页的活动
        }
        
        
    }
    else
    {
        //[self.AlbumCollection deselectItemAtIndexPath:model.indexPath animated:NO];
        [self.assets removeObject:model];
        //[self.AlbumCollection.delegate collectionView:self.AlbumCollection didDeselectItemAtIndexPath:model.indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectModel:)]) {
            [self.delegate didSelectModel:model];//处理上一页的活动
        }
    }
    [self.previewToolBar setSendNumber:(int)self.assets.count/*self.AlbumCollection.indexPathsForSelectedItems.count*/];
}*/
    -(void)selectButtonClick:(UIButton *)selectButton
{
    /*if (self.maxminumNumber) {
        if (!(self.maxminumNumber>self.assets.count)) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能选%d张照片",(int)self.maxminumNumber] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }*/
    
    if(_collectionView.isDecelerating){
        return;
    }
    LSYAlbumModel *model = self.allAssets[_selectedItem];
    
    if(self.assets.count<self.maxminumNumber)
    {//当选中数量小于总限制数
        [self selectButtonClickAgain:model];
    }else if(self.assets.count>self.maxminumNumber){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能选%d张照片",(int)self.maxminumNumber] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }else if(self.assets.count==self.maxminumNumber) {
        //当选中数量==总限制数
        BOOL isInclude = NO;
        for(int i=0;i<self.assets.count;i++){
            LSYAlbumModel *tmpM = self.assets[i];
            if([tmpM isEqual:model]){
                isInclude = YES;
                break;
            }
        }
        if(isInclude){
            //已被选中
            [self selectButtonClickAgain:model];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能选%d张照片",(int)self.maxminumNumber] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
            
        }
    }
    
}

-(void)selectButtonClickAgain:(LSYAlbumModel *)model
{
     model.indexPath =[NSIndexPath indexPathForItem:_selectedItem inSection:0];
    model.isSelect = !model.isSelect;
    self.previewNavBar.selectButton.selected = model.isSelect;
    if (model.isSelect) {
        //[self.AlbumCollection selectItemAtIndexPath:model.indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self.assets addObject:model];
        //[self.AlbumCollection.delegate collectionView:self.AlbumCollection didSelectItemAtIndexPath:model.indexPath];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectModel:)]) {
            [self.delegate didSelectModel:model];//处理上一页的活动
        }
        
        
    }
    else
    {
        //[self.AlbumCollection deselectItemAtIndexPath:model.indexPath animated:NO];
        [self.assets removeObject:model];
        //[self.AlbumCollection.delegate collectionView:self.AlbumCollection didDeselectItemAtIndexPath:model.indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectModel:)]) {
            [self.delegate didSelectModel:model];//处理上一页的活动
        }
    }
    [self.previewToolBar setSendNumber:(int)self.assets.count/*self.AlbumCollection.indexPathsForSelectedItems.count*/];
}
#pragma mark -LSYAssetPreviewToolBarDelegate
-(void)sendButtonClick:(UIButton *)sendButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AssetPreviewDidFinishPick:)]) {
        NSMutableArray *tmpassets = [NSMutableArray array];
        for (LSYAlbumModel *model in self.assets) {
            [tmpassets addObject:model.asset];
        }
        [self.delegate AssetPreviewDidFinishPick:tmpassets];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
     self.navigationController.navigationBar.hidden = NO;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_previewNavBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [_previewToolBar setFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDelegate
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.allAssets.count;
}
//配置每个item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width-10, [UIScreen mainScreen].bounds.size.height);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"COLLECTION_CELL" forIndexPath:indexPath];
    LSYAlbumModel*m =  [self.allAssets objectAtIndex:indexPath.row];
    UIImage * img = [UIImage imageWithCGImage:m.asset.defaultRepresentation.fullScreenImage];
    //UIImage*img = [UIImage imageWithCGImage:m.asset.thumbnail];//显示不清楚

    cell.imageView.image = img;
    
    return cell;
}

#pragma mark - 点击查看大图
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //_selectingItem =(int) indexPath.item;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _selectedItem = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    LSYAlbumModel *model = self.allAssets[_selectedItem];
    self.previewNavBar.selectButton.selected = model.isSelect;
    
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
