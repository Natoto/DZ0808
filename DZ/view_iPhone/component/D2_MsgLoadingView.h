//
//  D2_MsgLoadView.h
//  DZ
//
//  Created by Nonato on 14-6-6.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Bundle.h"
@interface D2_MsgLoadingView : UIView


//default is 1.0f
@property (nonatomic, assign) CGFloat lineWidth;

//default is [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, readonly) BOOL isAnimating;

@property (nonatomic, strong) UIImageView *iconimg;
//use this to init
- (id)initWithFrame:(CGRect)frame;

- (void)startAnimation;
- (void)stopAnimation;
@end
