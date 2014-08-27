//
//  B4_PreviewImageViewController.h
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"

@interface B4_PreviewImageView : UIView
//@property(nonatomic,strong)BeeUIImageView *imgview;
-(id)initWithFrame:(CGRect)frame withurl:(NSString *)url target:(id)target andSEL:(SEL)selaction contentAry:(NSArray *)contentAry;

@property(nonatomic,retain)NSString * imgURL;
@property(nonatomic,retain)NSArray *contentAry;
@end
