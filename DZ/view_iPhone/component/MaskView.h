//
//  MaskView.h
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "bee.h"

@protocol MaskViewDelegate <NSObject>
- (void)MaskViewDidTaped:(id)object;
@end
@interface MaskView : UIView
@property(nonatomic,assign) BOOL isShown;
@property(nonatomic,assign)NSObject <MaskViewDelegate> *delegate;
 
//- (instancetype)sharedInstance;
//+ (instancetype)sharedInstance;
- (void)showInView:(UIView *)view;
-(void)hiddenMask;
-(void)showInView:(UIView *)view belowSubview:(UIView *)belowSubview;
@end
