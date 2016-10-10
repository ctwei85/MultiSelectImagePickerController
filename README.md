该项目在githubh中AlbumPicker-master基础上修改而成。首先谢谢AlbumPicker-master作者。
主要实现仿微信中多选照片，预览功能
###使用方法：
1）添加头文件
#import "LSYAlbumCatalog.h"
#import "LSYNavigationController.h"
#import <AssetsLibrary/AssetsLibrary.h>

2）
代理：LSYAlbumCatalogDelegate

3）在选择相册点击事件里添加如下代码：


    LSYAlbumCatalog *albumCatalog = [[LSYAlbumCatalog alloc] init];
    
    albumCatalog.delegate = self;
    
    albumCatalog.toolbarDisplayText = @"发送";//在照片缩略图和预览照片时选择照片完成后显示发送还是完成 可在此处配置修改
   
    LSYNavigationController *navigation = [[LSYNavigationController alloc] initWithRootViewController:albumCatalog];
    
    albumCatalog.maximumNumberOfSelectionMedia = 8;//最多选择8张，可修改
    
    [self presentViewController:navigation animated:YES completion:nil];
    
4）选择的图片返回的数组



-(void)AlbumDidFinishPick:(NSArray *)assets
{
    
    NSMutableArray*arr = [NSMutableArray arrayWithArray:assets];
    
    for (ALAsset*asset in arr) {
         
         if ([[asset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypePhoto"]) {
             
             UIImage * img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    }

}
