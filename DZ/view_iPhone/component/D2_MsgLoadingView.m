//
//  D2_MsgLoadView.m
//  DZ
//
//  Created by Nonato on 14-6-6.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_MsgLoadingView.h"

#define ANGLE(a) 2*M_PI/360*a

@interface D2_MsgLoadingView ()

@property (nonatomic, assign) CGFloat anglePer;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation D2_MsgLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.iconimg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        self.iconimg.image=[UIImage bundleImageNamed:@"browser_baritem_refresh"];
        self.iconimg.center=CGPointMake(frame.size.width/2, frame.size.height/2);
        self.iconimg.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:self.iconimg];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setAnglePer:(CGFloat)anglePer
{
    _anglePer = anglePer;
    //    [self setNeedsDisplay];
}

- (void)startAnimation
{
    if (self.isAnimating) {
        [self stopAnimation];
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_6_1
#else
        [self.iconimg.layer removeAllAnimations];
#endif
    }
    _isAnimating = YES;
    
    self.anglePer = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02f
                                                  target:self
                                                selector:@selector(drawPathAnimation:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation
{
    _isAnimating = NO;
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self stopRotateAnimation];
}

- (void)drawPathAnimation:(NSTimer *)timer
{
    self.anglePer += 0.03f;
    
    if (self.anglePer >= 1) {
        self.anglePer = 1;
        [timer invalidate];
        self.timer = nil;
        [self startRotateAnimation];
    }
}

- (void)startRotateAnimation
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_6_1
#else
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2*M_PI);
    animation.duration = 1.f;
    animation.repeatCount = INT_MAX;
    
    [self.iconimg.layer addAnimation:animation forKey:@"keyFrameAnimation"];
#endif
}

- (void)stopRotateAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        self.iconimg.alpha = 0;
    } completion:^(BOOL finished) {
        self.anglePer = 0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_6_1
#else
        [self.iconimg.layer removeAllAnimations];
#endif
        self.iconimg.alpha = 1;
    }];
}

- (void)drawRect:(CGRect)rect
{
    if (self.anglePer <= 0) {
        _anglePer = 0;
    }
    
    CGFloat lineWidth = 1.f;
    UIColor *lineColor = [UIColor lightGrayColor];
    if (self.lineWidth) {
        lineWidth = self.lineWidth;
    }
    if (self.lineColor) {
        lineColor = self.lineColor;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextAddArc(context,
                    CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds),
                    CGRectGetWidth(self.bounds)/2-lineWidth,
                    ANGLE(120), ANGLE(120)+ANGLE(330)*self.anglePer,
                    0);
    CGContextStrokePath(context);
}
@end
