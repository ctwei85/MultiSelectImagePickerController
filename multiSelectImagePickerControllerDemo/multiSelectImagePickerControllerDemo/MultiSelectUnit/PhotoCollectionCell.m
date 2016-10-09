//
//  PhotoCollectionCell.m
//  xxt_xj
//
//  Created by hw on 16/9/26.
//  Copyright © 2016年 hw. All rights reserved.
//

#import "PhotoCollectionCell.h"

@implementation PhotoCollectionCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        
        [self addSubview:_imageView];
    }
    
    
    return self;
}

@end
