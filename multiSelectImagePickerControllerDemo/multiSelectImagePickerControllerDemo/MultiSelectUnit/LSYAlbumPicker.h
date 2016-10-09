//
//  LSYAlbumPicker.h
//  AlbumPicker
//
//  Created by okwei on 15/7/23.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@protocol LSYAlbumPickerDelegate<NSObject>
-(void)AlbumPickerDidFinishPick:(NSArray *)assets;
@end
@interface LSYAlbumPicker : UIViewController
@property(nonatomic,copy)NSString*toolbarDisplayText;//发送 还是完成
@property (nonatomic,strong) ALAssetsGroup *group;
@property (nonatomic) NSInteger maxminumNumber;
@property (nonatomic,weak) id<LSYAlbumPickerDelegate>delegate;
-(void)sendButtonClick;
@end
