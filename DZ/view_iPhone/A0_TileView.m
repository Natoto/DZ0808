//
//  TileView.m
//  IPhoneTest
//
//  Created by Lovells on 13-8-27.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//
#import "UIImage+Tint.h"
#import "A0_TileView.h"
#import "Constants.h"
//#import "rmbdz.h"
#import "home.h"
#define kLabelWidth     30.f
#define kLabelHeight    30.f

//static int counter = 0;

@interface A0_TileView ()
{
    UIButton *closebutton;
}
@end

@implementation A0_TileView
@synthesize delegate;
DEF_SIGNAL(mask)
DEF_SIGNAL(CLOSTBTNTAPPED)

-(id)initWithTileView:(A0_TileView *)item
{
    self = [super init];
    if (self)
    {
        self = item;
    }
    return self;
}
- (id)initWithTarget:(id)target dragaction:(SEL)dragaction andlongpressaction:(SEL)longpressaction
{
    self = [super init];
    if (self)
    {
        self.enableDelete=YES;
        self.editmode=NO;
        self.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];// [UIColor colorWithRed:0.605 green:0.000 blue:0.007 alpha:1.000];        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:dragaction];
        panGestureRecognizer.delegate=self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        UILongPressGestureRecognizer  *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:longpressaction];
        longPressGestureRecognizer.delegate=self;
        [self addGestureRecognizer:longPressGestureRecognizer];
        
        [self createLabelAndAddToSelf];
         _Tileitem =[[HOME2TOPICSPOSITIONITEM alloc] init];
    }
    return self;
} 

- (void)createLabelAndAddToSelf
{
    _imgView=[[BeeUIImageView alloc] init];
    
    _imgView.frame=CGRectMake(0, 0, kTileWidth, kTileHeight);
    BeeLog(@"%@",_imgView.frame);
    self.backgroundColor=KT_HEXCOLOR(0x00acf4);
    _imgView.indicator=[_imgView indicator];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;
    [self addSubview:_imgView];
    
    _synopsislbl=[[BeeUILabel alloc] initWithFrame:CGRectMake(10, 10, kTileWidth-20, kTileHeight-kLabelHeight)];
    _synopsislbl.textColor=[UIColor whiteColor];
    _synopsislbl.backgroundColor = [UIColor clearColor];
    _synopsislbl.numberOfLines=0;
    _synopsislbl.font=GB_FontHelveticaNeue(10); //[UIFont systemFontOfSize:10];
    _synopsislbl.lineBreakMode = NSLineBreakByWordWrapping;// 自动折行
    _synopsislbl.textAlignment = UITextAlignmentLeft;
    [_synopsislbl setVerticalAlignment:VerticalAlignmentTop];
    [self addSubview:_synopsislbl];
    
    _titlelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kTileHeight-kLabelHeight, kTileWidth, kLabelHeight)];
    _titlelbl.textColor=[UIColor blackColor];
    _titlelbl.backgroundColor = [UIColor whiteColor];
    _titlelbl.textAlignment=UITextAlignmentCenter;
    [self addSubview:_titlelbl];
    
    closebutton=[[UIButton alloc] initWithFrame:CGRectMake(-5, -5, 30, 30)];
    [self addSubview:closebutton];
    closebutton.hidden=YES;
    UIImage *image = [UIImage bundleImageNamed:@"guanbi"];
     image = [image imageWithTintColor:[UIColor redColor]];
    [closebutton setImage:image forState:UIControlStateNormal];
    [closebutton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside ];
    
     _titlelbl.alpha=0.5;
    _titlelbl.font = GB_FontHelvetica_BoldNeue(16);
    _synopsislbl.font=GB_FontHelveticaNeue(12);
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

-(void)layoutSubviews
{
    CGSize size = self.imgView.image.size;
    if (self.imgView.command == COMMAND_NOPERMISSION)
    {
        self.imgView.frame = CGRectMake(0, 0, size.width/2, size.height/2);
        self.imgView.center =CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
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
    shakeAnimation.duration = 0.1;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -0.01, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.01, 0, 0, 1)];
    [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

-(void)dataChange:(HOME2TOPICSPOSITIONITEM *)item
{
    self.Tileitem=item;
    if (item.icon.length>1) {
//        self.imgView.data=item.icon;
        [self.imgView GET:item.icon useCache:YES];
    }
    else
    {
        self.imgView.data = nil;
    }
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    unsigned long red = strtoul([item.backgroundcolor UTF8String],0,16);
    // strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    // unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
    self.backgroundColor=KT_HEXCOLOR(red);
    self.titlelbl.text=item.title.trim;
    self.synopsislbl.text=item.subject.trim;
    self.enableDelete=[item.enableDelete boolValue];
    
    int length = [NSString unicodeLengthOfString:self.synopsislbl.text];
    if (length > 30) {
        int index = [NSString unicodeIndexOfString:self.synopsislbl.text index:30];
        NSString * text =[self.synopsislbl.text substringToIndex:index];
        text = [text stringByAppendingFormat:@"..."];
        self.synopsislbl.text = text;
    }
    
}
-(id)copyWithZone:(NSZone *)zone
{
    A0_TileView *tileView = [[A0_TileView alloc] init]; //[super copyWithZone:zone];
//    tileView.delegate = [[self delegate] mutableCopy];
    [tileView setDelegate:[self delegate]];
    [tileView setTileitem:[self Tileitem]];
    [tileView setImgView:[self imgView]];
    [tileView setSynopsislbl:[self synopsislbl]];
    [tileView setTitlelbl:_titlelbl];
	return tileView;

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


@end
