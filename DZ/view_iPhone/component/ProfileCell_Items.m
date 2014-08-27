//
//  ProfileCell_Items.m
//  DZ
//
//  Created by Nonato on 14-8-6.
//
//

#import "ProfileCell_Items.h"
#import "UIImage+Bundle.h"
#import "Bee.h"
#import "RedPoint.h"
#import "CreateComponent.h"
@implementation ProfileCell_Items
@synthesize bgView,lblsendhtm,btnsenthtm, lblfriend,btnfriend,lblmessage,btnmessage,lblcollect,btncollect, lblreply,btnreply,redpt,redpt_frd;

@synthesize profiletype;

@synthesize btnfriendTap,btnmessageTap,btnReplyTap,btnsenthtmTap,btncollectTap,seltarget;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        bgView.backgroundColor = [UIColor clearColor];
        [self setBackgroundImage:[UIImage bundleImageNamed:@"dise"]];
        bgView.alpha = 1;
        [self addSubview:bgView];
        [self relayoutSubviews];
    }
    return self;
}

-(void)relayoutSubviews
{
    float startPositionX = 5;
    float startPositionY = 0;
    float distanceX = 55;
    float distanceY = 30;
    int index = 0;
    
    float remain= (320 - (distanceX * 4 + 50));
    if (profiletype == PROFILE_SELF)
    {
         remain= (320 - (distanceX * 4 + 50));
    }
    else
    {
         distanceX = 65;
         remain= (320 - (distanceX * 3 + 50));
    }
    startPositionX = remain/2;
    if (!lblsendhtm) {
        lblsendhtm = [CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX, startPositionY, 50, 30) andTxt:@"发帖"];
        lblsendhtm.titleLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:lblsendhtm];
        btnsenthtm = [CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX, startPositionY + distanceY, 50, 30) andTxt:@"0"];
        btnsenthtm.titleLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:btnsenthtm];
    }
    lblsendhtm.frame = CGRectMake(startPositionX, startPositionY, 50, 30);
    btnsenthtm.frame = CGRectMake(startPositionX, startPositionY + distanceY, 50, 30);
    index++;
    if (!lblfriend) {
        lblfriend = [CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX + distanceX * index, startPositionY, 50, 30) andTxt:@"好友"];
        lblfriend.titleLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:lblfriend];
        btnfriend = [CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX+ distanceX * index, startPositionY + distanceY, 50, 30) andTxt:@"0"];
        btnfriend.titleLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:btnfriend];
        
    }
    lblfriend.frame =CGRectMake(startPositionX + distanceX * index, startPositionY, 50, 30);
    btnfriend.frame = CGRectMake(startPositionX+ distanceX * index, startPositionY + distanceY, 50, 30);
    
    if (profiletype == PROFILE_SELF)
     {
         if (!redpt_frd) {
             redpt_frd = [[RedPoint alloc] initWithFrame:CGRectMake(bgView.frame.origin.x + CGRectGetMidX(lblfriend.frame), startPositionY + bgView.frame.origin.y , 10, 10)];
             redpt_frd.alpha = 0.7;
             [self addSubview:redpt_frd];
         }
         redpt_frd.frame =CGRectMake(bgView.frame.origin.x + CGRectGetMidX(lblfriend.frame) + 10, startPositionY + bgView.frame.origin.y , 10, 10);
     }
    index++;
    if (profiletype == PROFILE_SELF) {
        if (!lblmessage) {
            lblmessage=[CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX + distanceX * index, startPositionY, 50, 30) andTxt:@"消息"];
            lblmessage.titleLabel.font = [UIFont systemFontOfSize:13];
            [bgView addSubview:lblmessage];
            btnmessage=[CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX+ distanceX * index, startPositionY + distanceY, 50, 30) andTxt:@"0"];
            btnmessage.titleLabel.font = [UIFont systemFontOfSize:13];
            [bgView addSubview:btnmessage];
            
            redpt = [[RedPoint alloc] initWithFrame:CGRectMake(bgView.frame.origin.x + startPositionX + distanceX *index + 35, startPositionY + bgView.frame.origin.y , 10, 10)];
            redpt.alpha = 0.7;
            [self addSubview:redpt];
        }
        lblmessage.frame = CGRectMake(startPositionX + distanceX * index, startPositionY, 50, 30);
        btnmessage.frame = CGRectMake(startPositionX+ distanceX * index, startPositionY + distanceY, 50, 30);
        redpt.frame =CGRectMake(bgView.frame.origin.x + startPositionX + distanceX *index + 35, startPositionY + bgView.frame.origin.y , 10, 10);
        //红点
        index++;
        
    }
    if (!lblreply) {
        lblreply=[CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX + distanceX * index, startPositionY, 50, 30) andTxt:@"回复"];
        lblreply.titleLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:lblreply];
        btnreply=[CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX+ distanceX * index, startPositionY + distanceY, 50, 30) andTxt:@"0"];
        btnreply.titleLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:btnreply];
    }
    
    lblreply.frame = CGRectMake(startPositionX + distanceX * index, startPositionY, 50, 30);
    btnreply.frame = CGRectMake(startPositionX+ distanceX * index, startPositionY + distanceY, 50, 30);
    index++;
    if (!lblcollect) {
        lblcollect = [CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX + distanceX * index, startPositionY, 50, 30) andTxt:@"收藏"];
     
        lblcollect.titleLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:lblcollect];
        btncollect = [CreateComponent CreateButtonWithFrame:CGRectMake(startPositionX+ distanceX * index, startPositionY + distanceY, 50, 30) andTxt:@"0"];
        
        btncollect.titleLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:btncollect];
    }
    lblcollect.frame = CGRectMake(startPositionX + distanceX * index, startPositionY, 50, 30);
    btncollect.frame = CGRectMake(startPositionX+ distanceX * index, startPositionY + distanceY, 50, 30);
    
}

-(void)reReshButtonsSels
{
    [self relayoutSubviews];
    [lblsendhtm addTarget:seltarget action:btnsenthtmTap forControlEvents:UIControlEventTouchUpInside];
    [btnsenthtm addTarget:seltarget action:btnsenthtmTap forControlEvents:UIControlEventTouchUpInside];
    [lblfriend addTarget:seltarget action:btnfriendTap forControlEvents:UIControlEventTouchUpInside];
    [lblmessage addTarget:seltarget action:btnmessageTap forControlEvents:UIControlEventTouchUpInside];
    [lblreply addTarget:seltarget action:btnReplyTap forControlEvents:UIControlEventTouchUpInside];
    [btnfriend addTarget:seltarget action:btnfriendTap forControlEvents:UIControlEventTouchUpInside];
    [btnmessage addTarget:seltarget action:btnmessageTap forControlEvents:UIControlEventTouchUpInside];
    [btnreply addTarget:seltarget action:btnReplyTap forControlEvents:UIControlEventTouchUpInside];
    [btncollect addTarget:seltarget action:btncollectTap forControlEvents:UIControlEventTouchUpInside];
    [lblcollect addTarget:seltarget action:btncollectTap forControlEvents:UIControlEventTouchUpInside];
}
//- (BeeUIImageView *)CreateImageViewWithFrame:(CGRect)frame andImgName:(NSString *)imgname
//{
//    BeeUIImageView *imgView=[[BeeUIImageView alloc] initWithFrame:frame];
//    imgView.contentMode=UIViewContentModeScaleAspectFit;
//    //    imgView.data=imgname;
//    imgView.image=[UIImage bundleImageNamed:imgname];
//    return imgView;
//}
//
//- (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:frame];
//    label.text = TXT;
//    label.font = GB_FontHelveticaNeue(15);//[UIFont systemFontOfSize:15];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    return label;
//}
//
//- (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT txtcolor:(UIColor *)color
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
//    [button setTitle:TXT forState:UIControlStateNormal];
//    button.frame = frame;
//    [button setTitleColor:color forState:UIControlStateNormal];
//    return button;
//}
//
//- (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
//    [button setTitle:TXT forState:UIControlStateNormal];
//    button.frame = frame;
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    return button;
//}
//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
