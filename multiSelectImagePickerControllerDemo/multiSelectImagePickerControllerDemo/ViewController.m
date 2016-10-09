//
//  ViewController.m
//  multiSelectImagePickerControllerDemo
//
//  Created by hw on 16/10/9.
//  Copyright © 2016年 hw. All rights reserved.
//

#import "ViewController.h"

#import "LSYAlbumCatalog.h"
#import "LSYNavigationController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()<LSYAlbumCatalogDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ClickToSend:(id)sender {
    
    LSYAlbumCatalog *albumCatalog = [[LSYAlbumCatalog alloc] init];
    albumCatalog.delegate = self;
    albumCatalog.toolbarDisplayText = @"发送";//
    LSYNavigationController *navigation = [[LSYNavigationController alloc] initWithRootViewController:albumCatalog];
    albumCatalog.maximumNumberOfSelectionMedia = 8;//最多选择8张，可修改
    [self presentViewController:navigation animated:YES completion:^{
        
    }];

}

- (IBAction)ClickToFinish:(id)sender {
    LSYAlbumCatalog *albumCatalog = [[LSYAlbumCatalog alloc] init];
    albumCatalog.delegate = self;
    albumCatalog.toolbarDisplayText = @"完成";
    LSYNavigationController *navigation = [[LSYNavigationController alloc] initWithRootViewController:albumCatalog];
    albumCatalog.maximumNumberOfSelectionMedia = 8;
    [self presentViewController:navigation animated:YES completion:^{
        
    }];

}

-(void)AlbumDidFinishPick:(NSArray *)assets
{
    NSMutableArray*arr = [NSMutableArray arrayWithArray:assets];
    for (ALAsset*asset in arr) {
         if ([[asset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypePhoto"]) {
             UIImage * img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
             if(img.size.width>960){
                 img = [self compressImage:img toTargetWidth:960];
                 
                 //压缩图片
                 NSData *imageData = UIImageJPEGRepresentation(img, 1.0f);
                 CGFloat compression = 200.0*1024/imageData.length*1.0;
                 NSData *dataUpload = UIImageJPEGRepresentation(img, compression);
                 img = [UIImage imageWithData:dataUpload];

             }
         }
    }
}

- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth {
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
