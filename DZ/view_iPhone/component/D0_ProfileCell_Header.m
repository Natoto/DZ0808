//
//  ProfileCell_Header.m
//  xmlaaa
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D0_ProfileCell_Header.h"
#import "Bee.h"
#import "rmbdz.h"
#import "RedPoint.h"
#import "profile.h"
#import "ProfileCell_Items.h"
#import "CreateComponent.h"
@implementation D0_ProfileCell_Header
DEF_SIGNAL(wealth)
DEF_SIGNAL(gotoqiandao)
DEF_SIGNAL(login)
DEF_SIGNAL(logout)
DEF_SIGNAL(profileinfo);
DEF_SIGNAL(gotosendhtml)
DEF_SIGNAL(gotofriend)
DEF_SIGNAL(gotomessage)
DEF_SIGNAL(gotocollect)
DEF_SIGNAL(gotoreply)
DEF_SIGNAL(gotocredit)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//         self.backgroundColor=[UIColor colorWithRed:145/255.0 green:182/255.0 blue:208/255.0 alpha:1];
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage bundleImageNamed:@"beijingdi"]];
       
        backgImageView = [[UIImageView alloc] init];
        float height=90.0-1.0f;
        float width=320;
        backgImageView.frame = CGRectMake(0, 0, width, height);
        backgImageView.image = [UIImage bundleImageNamed:@"beijingdi"];
        [self addSubview:backgImageView];
        //加分割线
        linelayer = [CALayer layer];
        linelayer.frame = CGRectMake(bee.ui.config.separatorInset.left, 0, width - 2 * bee.ui.config.separatorInset.left, LINE_LAYERBOARDWIDTH);
        linelayer.backgroundColor = LINE_LAYERBOARDCOLOR;
        [self.layer addSublayer:linelayer];
        
        [self layoutHeaderViews];
        [self reloadSubViews];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    backgImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    linelayer.frame = CGRectMake(bee.ui.config.separatorInset.left,self.frame.size.height - LINE_LAYERBOARDWIDTH, self.frame.size.width - 2 * bee.ui.config.separatorInset.left, LINE_LAYERBOARDWIDTH);
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)dataDidChanged
{
//    self.usermodel=(UserModel *)self.data;
    if (self.usermodel.login.account) {
        PROFILE *profile=self.usermodel.profile;
        if (profile.avatar.length) {
            [[BeeImageCache sharedInstance] deleteImageForURL:profile.avatar] ;            
        }
        [imgview GET:profile.avatar useCache:NO placeHolder:[UIImage bundleImageNamed:@"profile_no_avatar_icon"]];
        [btnsenthtm setTitle:profile.threads forState:UIControlStateNormal];
        [btnfriend setTitle:profile.friends forState:UIControlStateNormal];
        [btnreply setTitle:profile.replys forState:UIControlStateNormal];
        [btncollect setTitle:profile.favorites forState:UIControlStateNormal];
//        lblname.text=[NSString stringWithFormat:@"%@:%@",profile.group,profile.username];
        lblname.text=[NSString stringWithFormat:@"%@",profile.group];

        if (profile.credits) {
            lblcredit.text = [NSString stringWithFormat:@"积分:%@", profile.credits];
        }
        if (self.usermodel.messageCount.integerValue) {
            [btnmessage setTitle:self.usermodel.messageCount forState:UIControlStateNormal];
//            [btnmessage setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else
        {
            [btnmessage setTitle:@"0" forState:UIControlStateNormal];
//            [btnmessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        self.LOGEDIN=YES;
    }
    else
    {
        self.LOGEDIN=NO;
    }
    [self reloadSubViews];
}

-(void)layoutHeaderViews
{
//    UIImageView *imgview=[[UIImageView alloc] init];
//    imgview.image=[UIImage bundleImageNamed:@"profile_img_bg.png"];
//    imgview.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [self addSubview:imgview];
    //头像
    imgview = (BeeUIImageView *)[CreateComponent CreateImageViewWithFrame:CGRectMake(0, 0, 80,80) andImgName:@"profile_no_avatar_icon"];
     KT_CORNER_PROFILE(imgview);
     btnprofile = [CreateComponent CreateButtonWithFrame:CGRectMake(0, 10, 80,80) andTxt:@""];
    [btnprofile addSubview:imgview];
    btnprofile.center = CGPointMake(320/2.0, 55);

    [btnprofile addTarget:self action:@selector(btnprofileTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnprofile];
    //加阴影
    btnprofile.layer.shadowColor = [UIColor blackColor].CGColor;
    btnprofile.layer.shadowOffset = CGSizeMake(3, 3);
    btnprofile.layer.shadowOpacity = 0.5;
    btnprofile.layer.shadowRadius = CGRectGetHeight([imgview bounds]) / 2;//2.0;
    

    /*签到从这里搬家了 [self addSubview:[self QD_View]];*/
    btnlogin = [CreateComponent CreateButtonWithFrame:CGRectMake(0, 0, 100, 35) andTxt:@"登录" txtcolor:[UIColor blackColor]];
//    [btnlogin setBackgroundColor:[UIColor colorWithRed:227/255.0 green:221/255.0 blue:220/255.0 alpha:1]];
    [btnlogin setBackgroundImage:[UIImage bundleImageNamed:@"dengluaniu@2x"] forState:UIControlStateNormal];
    btnlogin.center = CGPointMake(320/2, CGRectGetMaxY(btnprofile.frame) + 40);
    btnlogin.titleLabel.font = [UIFont systemFontOfSize:15];
    KT_CORNER_RADIUS(btnlogin, 3);
    [btnlogin addTarget:self action:@selector(btnloginTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnlogin];
    
    
    
    lblname = [CreateComponent CreateLabelWithFrame:CGRectMake(20, CGRectGetMaxY(btnprofile.frame), 150, 30) andTxt:@"用户组:无名氏"];
    //移动到中部
    lblname.center = CGPointMake(CGRectGetMidX(btnprofile.frame), CGRectGetMaxY(btnprofile.frame)+15);
    lblname.textAlignment = NSTextAlignmentCenter;
    lblname.font = [UIFont systemFontOfSize:15];
    [self addSubview:lblname];

    
    btnwealth =  [CreateComponent CreateButtonWithFrame:CGRectMake(20, CGRectGetMaxY(lblname.frame), 80, 30) andTxt:@"财富"];
    [btnwealth setBackgroundImage:[UIImage bundleImageNamed:@"dengluaniu@2x"] forState:UIControlStateNormal];
    btnwealth.center = CGPointMake(320/2, CGRectGetMidY(btnwealth.frame)+5);
    btnwealth.titleLabel.font = [UIFont systemFontOfSize:15];
    KT_CORNER_RADIUS(btnlogin, 3);
    [btnwealth addTarget:self action:@selector(btnwealthTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnwealth];
    
/*
    lblcredit = [self CreateLabelWithFrame:CGRectMake(lblname.frame.origin.x + 160, 110, 150, 40) andTxt:@"积分:0"];
    lblcredit.font = [UIFont systemFontOfSize:15];
*/
//    lblcredit.textAlignment = NSTextAlignmentRight;
//    [self addSubview:lblcredit];
//    bgView = [self getbgView];// 发帖 好友 消息 回复 排列
    
    float cellheight =[D0_ProfileCell_Header heightOfProfileCell];
    bgView=[[ProfileCell_Items alloc] initWithFrame:CGRectMake(0, cellheight - 60, 320, 60)];
    bgView.seltarget = self;
    bgView.profiletype = PROFILE_SELF;
    bgView.btncollectTap = @selector(btncollectTap:);
    bgView.btnfriendTap = @selector(btnfriendTap:);
    bgView.btnReplyTap = @selector(btnReplyTap:);
    bgView.btnsenthtmTap = @selector(btnsenthtmTap:);
    bgView.btncollectTap = @selector(btncollectTap:);
    bgView.btnmessageTap = @selector(btnmessageTap:);
    [self addSubview:bgView];
    [bgView reReshButtonsSels];
    
    lblcollect = bgView.lblcollect;
    lblsendhtm = bgView.lblsendhtm;
    btnsenthtm = bgView.btnsenthtm;
    lblfriend = bgView.lblfriend;
    btnfriend = bgView.btnfriend;
    lblmessage = bgView.lblmessage;
    btnmessage = bgView.btnmessage;
    lblcollect = bgView.lblcollect;
    btncollect = bgView.btncollect;
    lblreply = bgView.lblreply;
    btnreply = bgView.btnreply;
    redpt = bgView.redpt;
    redpt_frd =bgView.redpt_frd;
    
}

+(float)heightOfProfileCell
{
    return 240.0f;
}

-(void)reloadSubViews
{
    if (self.LOGEDIN) {
        bgView.hidden       = NO;
        imgview.hidden      = NO;
        btnprofile.hidden   = NO;
        lblname.hidden      = NO;
        btnwealth.hidden    = NO;
        btnlogin.hidden     = YES;
//        lbltips.hidden      =YES;
//        lbltips.text        = @"个人资料";
        lblsendhtm.hidden   = NO;
        btnsenthtm.hidden   = NO;
        lblfriend.hidden    = NO;
        btnfriend.hidden    = NO;
        lblmessage.hidden   = NO;
        btnmessage.hidden   = NO;
        if ([RemindModel newmessagecount])
            redpt.hidden = NO;
        lblcollect.hidden   = NO;
        btncollect.hidden   = NO;
        lblcredit.hidden    = NO;
        QD_View.hidden = NO;
//        btncredit.hidden    = NO;
    }
    else
    {
        bgView.hidden       = YES;
        imgview.hidden      = NO;
        btnprofile.hidden   = NO;
        btnwealth.hidden    = NO;
        lblname.hidden      = YES;
        btnwealth.hidden    = YES;
        btnlogin.hidden     = NO;
//        lbltips.hidden      =NO;
//        lbltips.text = @"请登录";
        lblsendhtm.hidden   = YES;
        btnsenthtm.hidden   = YES;
        lblfriend.hidden    = YES;
        btnfriend.hidden    = YES;
        lblmessage.hidden   = YES;
        btnmessage.hidden   = YES;
        redpt.hidden        = YES;
        lblcollect.hidden   = YES;
        btncollect.hidden   = YES;
        lblcredit.hidden    = YES;
        QD_View.hidden = YES;
//        btncredit.hidden    = YES;
    }
    
}
-(void)newmessage:(int)count
{
    if (count) {
        redpt_frd.hidden = NO;
    }
    else
    {
        redpt_frd.hidden = YES;
    }
}

-(UIView *)QD_View
{
    if (!QD_View) {
        QD_View = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnprofile.frame)+2, CGRectGetMidY(btnprofile.frame) - 15 , 60, 30)];
        UIButton *button = [CreateComponent CreateButtonWithFrame:CGRectMake(5, 5, 50, 20) andTxt:@"签到"];
        [button addTarget:self action:@selector(qdbtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [QD_View addSubview:button];
        QD_View_BUTTON = button;
        
        QD_View.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        QD_View.layer.backgroundColor = [[UIColor clearColor] CGColor];
        QD_View.layer.borderColor = [UIColor orangeColor].CGColor; //[[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]CGColor];
        QD_View.layer.borderWidth = 1.0;
        QD_View.layer.cornerRadius = 1.0f;
    }
    return QD_View;
}
 

-(IBAction)btnwealthTap:(id)sender
{
    [self sendUISignal:self.wealth];
}
-(IBAction)qdbtnTap:(id)sender
{
    [self sendUISignal:self.gotoqiandao];
}
- (IBAction)btnsenthtmTap:(id)sender
{
    [self sendUISignal:self.gotosendhtml];
}
- (IBAction)btnReplyTap:(id)sender
{
    [self sendUISignal:self.gotoreply];
}
- (IBAction)btnloginTap:(id)sender
{
    [self sendUISignal:self.login];
//    self.LOGEDIN=YES;
//    [self reloadSubViews];
}
- (IBAction)btncollectTap:(id)sender
{
    [self sendUISignal:self.gotocollect];
}

//- (IBAction)btncreditTap:(id)sender
//{
//    [self sendUISignal:self.gotocredit];
//}

- (IBAction)btnmessageTap:(id)sender
{
    redpt.hidden = YES;
    [self sendUISignal:self.gotomessage];
}

- (IBAction)btnfriendTap:(id)sender
{
    [self sendUISignal:self.gotofriend];
}

- (IBAction)btnprofileTap:(id)sender
{
     NSLog(@"个人中心");
    [self sendUISignal:self.profileinfo];
}

- (IBAction)btnlogoutTap:(id)sender
{
    NSLog(@"注销");
    [self sendUISignal:self.logout];
//    self.LOGEDIN=NO;
//    [self reloadSubViews];
}
//
- (void)load
{
}

- (void)unload
{
    
} 

@end
