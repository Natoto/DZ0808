//
//  C0_HairPost_ToolsView.m
//  DZ
//
//  Created by Nonato on 14-4-28.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "UIImage+Bundle.h"
#import "C0_HairPost_ToolsView.h"
#define TOP_VIEW_HEIGHT 33.0f
@interface C0_HairPost_ToolsView()
@property(nonatomic,strong)UIButton *btnFacial;
@property(nonatomic,strong)UIButton *btnpicture;
@property(nonatomic,strong)UIButton *btnphoto;
@property(nonatomic,strong)UIButton *btnkeyboard;
@end

@implementation C0_HairPost_ToolsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame=CGRectMake(frame.origin.x, frame.origin.y, 320, TOP_VIEW_HEIGHT);
        _btnFacial=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFacial setImage:[UIImage bundleImageNamed:@"face"] forState:UIControlStateNormal];
        _btnFacial.frame=CGRectMake(18, 0, 32, 33);
        [self addSubview:_btnFacial];
        
        _btnpicture=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnpicture setImage:[UIImage bundleImageNamed:@"photoMark"] forState:UIControlStateNormal];
        _btnpicture.frame=CGRectMake(60, 0, 32, 33);
        [self addSubview:_btnpicture];
        
        _btnkeyboard=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnkeyboard setImage:[UIImage bundleImageNamed:@"jianpan"] forState:UIControlStateNormal];
        _btnkeyboard.frame=CGRectMake(250, 0, 32, 33);
        [self addSubview:_btnkeyboard];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withTarget:(id)delegate andFacialSel:(SEL)facialTap andpictureSel:(SEL)pictureTap andkeyboardSel:(SEL)keyboardTap
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame=CGRectMake(frame.origin.x, frame.origin.y, 320, TOP_VIEW_HEIGHT);
        _btnFacial=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFacial setImage:[UIImage bundleImageNamed:@"biaoqing"] forState:UIControlStateNormal];
        _btnFacial.frame=CGRectMake(18, 0, 32, 33);
        [self addSubview:_btnFacial];
        [_btnFacial addTarget:delegate action:facialTap forControlEvents:UIControlEventTouchUpInside];
        
        _btnpicture=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnpicture setImage:[UIImage bundleImageNamed:@"tianjia-02"] forState:UIControlStateNormal];
        _btnpicture.frame=CGRectMake(60, 0, 32, 33);
        [self addSubview:_btnpicture];
        [_btnpicture addTarget:delegate action:pictureTap forControlEvents:UIControlEventTouchUpInside];
        
        _btnkeyboard=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnkeyboard setImage:[UIImage bundleImageNamed:@"jianpan"] forState:UIControlStateNormal];
        _btnkeyboard.frame=_btnFacial.frame; //CGRectMake(250, 0, 32, 33);
        [self addSubview:_btnkeyboard];
        [_btnkeyboard addTarget:delegate action:keyboardTap forControlEvents:UIControlEventTouchUpInside];
        [self showKeyboardBtn:NO];
    }
    return self;
}
-(void)showKeyboardBtn:(BOOL)show
{
    _btnkeyboard.hidden=!show;
    _btnFacial.hidden = show;
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
