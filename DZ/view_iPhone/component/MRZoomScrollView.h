//
//  MRZoomScrollView.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "LXActionSheet.h"
@interface MRZoomScrollView : UIScrollView <UIScrollViewDelegate,LXActionSheetDelegate>
{
    BeeUIImageView *imageView;
       LXActionSheet *sheet;
}

@property (nonatomic, retain) BeeUIImageView *imageView;


@end
