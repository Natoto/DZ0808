//
//  C0_FacialInputView.h
//  DZ
//
//  Created by Nonato on 14-4-30.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacialView.h"

@protocol C0_FacialInputViewDelegate
-(void)selectedFacialView:(NSString*)str;
@end

@interface C0_FacialInputView : UIView<UIScrollViewDelegate,facialViewDelegate>
{
    UIPageControl *pageControl;
    UIScrollView *scrollView;
    __weak id<C0_FacialInputViewDelegate>delegate;
}
@property(nonatomic,weak)id<C0_FacialInputViewDelegate>delegate;
@property(nonatomic,strong) NSString *selectedFacialStr;
AS_SIGNAL(selectedFacialView);
@end
