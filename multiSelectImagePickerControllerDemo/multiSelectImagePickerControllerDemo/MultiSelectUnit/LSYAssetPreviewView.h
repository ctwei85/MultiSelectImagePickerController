//
//  LSYAssetPreviewView.h
//  AlbumPicker
//
//  Created by Labanotation on 15/8/1.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSYAssetPreviewNavBarDelegate <NSObject>
-(void)selectButtonClick:(UIButton *)selectButton;
-(void)backButtonClick:(UIButton *)backButton;
@end
@protocol LSYAssetPreviewToolBarDelegate <NSObject>
-(void)sendButtonClick:(UIButton *)sendButton;
@end
@interface LSYAssetPreviewNavBar : UIView
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,weak) id <LSYAssetPreviewNavBarDelegate> delegate;
@end

@interface LSYAssetPreviewToolBar : UIView
@property (nonatomic,weak) id <LSYAssetPreviewToolBarDelegate> delegate;
//@property(nonatomic,copy)NSString*toolbarDisplayText;//发送 还是完成
-(instancetype)initWithToolbarDisplayText:(NSString*)tmpText;
-(void)setSendNumber:(int)number;
@end
