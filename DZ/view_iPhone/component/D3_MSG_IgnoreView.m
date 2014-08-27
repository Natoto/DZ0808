//
//  D3_MSG_IgnoreView.m
//  DZ
//
//  Created by Nonato on 14-7-21.
//
//
#import "DZ_SystemSetting.h"
#import "D3_MSG_IgnoreView.h"
#import "Bee.h"
@implementation D3_MSG_IgnoreView

- (id)initWithFrame:(CGRect)frame sel:(SEL)ignoreMessages target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        headView.backgroundColor=[UIColor whiteColor];
        //    headView.layer.borderColor = LINE_LAYERBOARDCOLOR;
        //    headView.layer.borderWidth = LINE_LAYERBOARDWIDTH;
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(220, 5, 80, 30);
        
        if (self.ignoreMessage) {
            [button setTitle:@"点此开启" forState:UIControlStateNormal];
        }
        else
            [button setTitle:@"点此屏蔽" forState:UIControlStateNormal];
         UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
        [button setTitleColor:color forState:UIControlStateNormal];
        [button addTarget:target action:ignoreMessages forControlEvents:UIControlEventTouchUpInside];
        self.ignoreButton=button;
        [headView addSubview:button];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, 30)];
        label.text=@"不希望收到此消息?";
        self.ignoreLabel=label;
        [headView addSubview:label];
        
        self.ignoreLabel.font = [UIFont systemFontOfSize:14];
        self.ignoreButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        if (self.ignoreMessage) {
            [self.ignoreButton setTitle:@"点此开启" forState:UIControlStateNormal];
            self.ignoreLabel.text=self.recievemessage?self.recievemessage:@"需要接受好友互动吗？";
        }
        else
        {
            [self.ignoreButton setTitle:@"点此屏蔽" forState:UIControlStateNormal];
            self.ignoreLabel.text = @"不希望收到此消息?";
        }
        [self addSubview:headView];
        
        bottomBorder = [CALayer layer];
        float height=self.frame.size.height-LINE_LAYERBOARDWIDTH;
        bottomBorder.frame = CGRectMake(0, height, self.frame.size.width, LINE_LAYERBOARDWIDTH);
        bottomBorder.backgroundColor =LINE_LAYERBOARDCOLOR;
        [headView.layer addSublayer:bottomBorder];
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    float height=self.frame.size.height - LINE_LAYERBOARDWIDTH;
    float width=self.frame.size.width ; 
    bottomBorder.frame = CGRectMake(0, height, width  , LINE_LAYERBOARDWIDTH);
}

+(float)heightOfView
{
    return 40.0;
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
