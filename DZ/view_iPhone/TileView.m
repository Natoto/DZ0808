//
//  TileView.m
//  IPhoneTest
//
//  Created by Lovells on 13-8-27.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "TileView.h"
//#import "rmbdz.h"
#import "home.h"
#define kLabelWidth     30.f
#define kLabelHeight    30.f

//static int counter = 0;

@interface TileView ()
{
    UIButton *closebutton;
}
@end

@implementation TileView
@synthesize delegate;
DEF_SIGNAL(mask)
DEF_SIGNAL(CLOSTBTNTAPPED)
- (id)initWithTarget:(id)target dragaction:(SEL)dragaction andlongpressaction:(SEL)longpressaction
{
    self = [super init];
    if (self)
    {
        self.enableDelete=YES;
        self.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];// [UIColor colorWithRed:0.605 green:0.000 blue:0.007 alpha:1.000];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:dragaction];
        panGestureRecognizer.delegate=self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        UILongPressGestureRecognizer  *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:longpressaction];
        longPressGestureRecognizer.delegate=self;
        [self addGestureRecognizer:longPressGestureRecognizer];
        
        [self createLabelAndAddToSelf];
         _Tileitem =[[HOME2TOPICSPOSITIONITEM alloc] init];
//        [_Tileitem setValue:@"模块" forKey:@"fid"];
//        [self.Tileitem addObserver:self forKeyPath:@"count" options: NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//        [self.Tileitem addObserver:self forKeyPath:@"subject" options: NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//        [self.Tileitem addObserver:self forKeyPath:@"fid" options: NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}
//没用？？？
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if([keyPath isEqualToString:[NSString stringWithFormat:@"%@",@"fid"]])
//    {
////        HOMETOPICSITEM *item=[self.TileitemDic objectForKey:@"TopicItem"];
////        _synopsislbl.text=item.subject;
//        _titlelbl.text=keyPath;
//    }
//}
// UILongPressGestureRecognizer

- (void)createLabelAndAddToSelf
{
    _imgView=[[BeeUIImageView alloc] init];
    
    _imgView.frame=CGRectMake(0, 0, kTileWidth, kTileHeight);
    BeeLog(@"%@",_imgView.frame);
    _imgView.image=[UIImage imageNamed:@"homecellbgimg.jpg"];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleAspectFill;//
    [self addSubview:_imgView];
    
    _synopsislbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTileWidth, kTileHeight-kLabelHeight)];
    _synopsislbl.textColor=[UIColor blackColor];
    _synopsislbl.backgroundColor = [UIColor clearColor];
    _synopsislbl.numberOfLines=0;
    _synopsislbl.font=[UIFont systemFontOfSize:10];
    _synopsislbl.lineBreakMode = NSLineBreakByWordWrapping;// 自动折行
    [self addSubview:_synopsislbl];
    
    
    _titlelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kTileHeight-kLabelHeight, kTileWidth, kLabelHeight)];
//    _titlelbl.text = [NSString stringWithFormat:@"%i", ++counter];
    _titlelbl.textColor=[UIColor blackColor];
    _titlelbl.backgroundColor = [UIColor whiteColor];
    _titlelbl.textAlignment=UITextAlignmentCenter;
    _titlelbl.alpha=0.9;
    [self addSubview:_titlelbl];
    
    closebutton=[[UIButton alloc] initWithFrame:CGRectMake(kTileWidth-30, 0, 30, 30)];
    [self addSubview:closebutton];
    closebutton.hidden=YES;
    [closebutton setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    [closebutton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside ];  //:@"buttonTap" forControlEvents:UIControlEventTouchUpInside];
}
-(IBAction)buttonTap:(id)sender
{
     closebutton.hidden=YES;
    [self stopShake];
    BeeLog(@"closebutton TAPED");
    if (delegate!= nil && [delegate respondsToSelector:@selector(TileViewCloseBtnTap:)])
    {
        [delegate performSelector:@selector(TileViewCloseBtnTap:) withObject:self];
    }
//    [self sendUISignal:self.CLOSTBTNTAPPED];
 
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BeeLog(@"点击了label");
    if (!self.editmode) {
        [self sendUISignal:self.mask withObject:self.Tileitem];
    }
}


- (void)startShake
{
    self.editmode=YES;
    if (self.enableDelete) {
        closebutton.hidden=NO;
    }
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -0.01, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.01, 0, 0, 1)];
    [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake
{
    closebutton.hidden=YES;
    self.editmode=NO;
    [self.layer removeAnimationForKey:@"shakeAnimation"];
}
//屏蔽手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[gestureRecognizer class] isSubclassOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }
    return self.editmode;
}

//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // switch (recognizer.state) {\
//case UIGestureRecognizerStateBegan:
//    if ([[gestureRecognizer class] isSubclassOfClass:[UILongPressGestureRecognizer class]]) {
//        return YES;
//    }
//    return self.editmode;
//}


/*
- (void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] set];
    
    // 填充白色圆角矩形
    CGFloat rwk = 0.5f;
    CGFloat rhk = 0.34f;
    CGRect drawRect = CGRectMake(rect.size.width * (1 - rwk) / 2, rect.size.height * (1 - rhk) / 2,
                                 rect.size.width * rwk, rect.size.height * rhk);
    [[UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:5] fill];
    
    // 填充白色三角形
    CGFloat twk = 0.3 * rwk;
    CGFloat thk = 0.2 * rhk;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(rect.size.width * 0.5,
                                                                   drawRect.origin.y + drawRect.size.height);
    CGMutablePathRef trianglePath = CGPathCreateMutable();
    CGPathMoveToPoint(trianglePath, &transform, 0, 0);
    CGPathAddLineToPoint(trianglePath, &transform, rect.size.width * twk, 0);
    CGPathAddLineToPoint(trianglePath, &transform, rect.size.width * twk * 1.2, rect.size.height * thk);
    CGPathCloseSubpath(trianglePath);
    
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextAddPath(context, trianglePath);
    CGContextFillPath(context);
    
    // 画两个背景色的小圆点
    [self.backgroundColor set];
    CGFloat midy = drawRect.origin.y + drawRect.size.height / 2;
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, midy - 5 - 4, 4, 4)] fill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, midy + 5, 4, 4)] fill];
    
    CGContextSetLineWidth(context, 2.f);
    
    // 画背景色的直线
    CGContextMoveToPoint(context, 57, midy);
    CGContextAddLineToPoint(context, 65, midy);
    CGContextStrokePath(context);
    
    // 画背景色的弧
    //    CGContextMoveToPoint(context, 65, midy - 15);
    //    CGContextAddLineToPoint(context, 75, midy);
    //    CGContextAddLineToPoint(context, 65, midy + 15);
    CGContextMoveToPoint(context, 69, midy - 13);
    CGContextAddArcToPoint(context, 79, midy, 69, midy + 13, 20);
    CGContextStrokePath(context);
}*/

@end
