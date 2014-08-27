//
//  MaskView.m
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView 
//- (instancetype)sharedInstance
//{
//    return [[self class] sharedInstance];
//}
//
//+ (instancetype)sharedInstance
//{
//    static dispatch_once_t once;
//    static id __singleton__;
//    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
//    return __singleton__;
//}
-(id)init
{
    self=[super init];
    if (self) {
        [self layoutSubviews:CGRectZero];
    }
    return self;
}

-(void)layoutSubviews:(CGRect)frame
{
//    [super layoutSubviews];
    if (frame.size.width) {
        self.frame=frame;
    }
    else
    {
        CGRect frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        self.frame=frame;
    }
    self.userInteractionEnabled=YES;
    self.backgroundColor=[UIColor colorWithWhite:1 alpha:1];
//    self.backgroundColor = [UIColor blueColor];
    self.alpha=0.1;
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    [self addGestureRecognizer:gesture];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self layoutSubviews:frame];
    }
    return self;
}

-(IBAction)gestureTap:(id)sender
{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(MaskViewDidTaped:)]) {
        [self.delegate MaskViewDidTaped:self];
    }
}

-(void)showInView:(UIView *)view belowSubview:(UIView *)belowSubview
{
    if (!view)
    {
        [[UIApplication sharedApplication].delegate.window.rootViewController.view  insertSubview:self belowSubview:belowSubview];
    }
    else
     [view insertSubview:self belowSubview:belowSubview];
}
- (void)showInView:(UIView *)view
{
    self.isShown=YES;
    if (!view) {
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    }
    else
    {
        [[UIApplication sharedApplication].delegate.window.rootViewController.view  insertSubview:self belowSubview:view];
         [view addSubview:self];
    }
}

-(void)hiddenMask
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
