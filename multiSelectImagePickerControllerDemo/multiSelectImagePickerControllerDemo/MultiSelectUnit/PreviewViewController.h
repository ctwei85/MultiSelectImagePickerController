//
//  PreviewViewController.h
//  xxt_xj
//
//  Created by hw on 16/9/26.
//  Copyright © 2016年 hw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYAssetPreviewView.h"
@class LSYAlbumModel;
/*@protocol PreviewViewControllerDelegate <NSObject>
-(void)AssetPreviewDidFinishPick:(NSArray *)assets;
-(void)didSelectModel:(LSYAlbumModel*)m;
@end*/
@protocol PreviewViewControllerDelegate <NSObject>

-(void)AssetPreviewDidFinishPick:(NSArray *)assets;
-(void)didSelectModel:(LSYAlbumModel*)m;

@end

@interface PreviewViewController : UIViewController<LSYAssetPreviewNavBarDelegate,LSYAssetPreviewToolBarDelegate>
@property(nonatomic,strong)LSYAssetPreviewNavBar*previewNavBar;
@property(nonatomic,strong)LSYAssetPreviewToolBar*previewToolBar;
@property (nonatomic,strong) NSMutableArray *assets;
@property(nonatomic,strong)NSArray*allAssets;
@property(nonatomic,assign)NSInteger selectedItem;
@property(nonatomic,copy)NSString*toolbarDisplayText;//发送 还是完成
@property(nonatomic,assign)id<PreviewViewControllerDelegate>delegate;
@end
