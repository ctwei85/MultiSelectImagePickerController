//
//  LSYPublicForWechat.h
//  xxt_xj
//
//  Created by hw on 16/8/26.
//  Copyright © 2016年 hw. All rights reserved.
//

#ifndef LSYPublicForWechat_h
#define LSYPublicForWechat_h

#define ScreenSize [UIScreen mainScreen].bounds.size
#define kThumbnailLength    ([UIScreen mainScreen].bounds.size.width - 5*5)/4
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define DistanceFromTopGuiden(view) (view.frame.origin.y + view.frame.size.height)
#define DistanceFromLeftGuiden(view) (view.frame.origin.x + view.frame.size.width)
#define ViewOrigin(view)   (view.frame.origin)
#define ViewSize(view)  (view.frame.size)
#endif /* LSYPublicForWechat_h */
