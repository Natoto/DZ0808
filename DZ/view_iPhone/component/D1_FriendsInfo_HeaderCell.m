//
//  D1_FriendsInfoCell.m
//  DZ
//
//  Created by Nonato on 14-6-17.
//
//

#import "D1_FriendsInfo_HeaderCell.h"
#import "ToolsFunc.h"
#import "profile.h"
#import "UIImage+Tint.h"
#import "ProfileCell_Items.h"
#import "CreateComponent.h"
@implementation D1_FriendsInfo_HeaderCell
//DEF_SIGNAL(login)
//DEF_SIGNAL(logout)
//DEF_SIGNAL(profileinfo);
//DEF_SIGNAL(gotosendhtml)
//DEF_SIGNAL(gotofriend)
//DEF_SIGNAL(gotomessage)
//DEF_SIGNAL(gotocollect)
//DEF_SIGNAL(gotoreply)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        backgImageView = [[UIImageView alloc] init];
        float height=self.frame.size.height-1.0f;
        float width=self.frame.size.width;
        backgImageView.frame = CGRectMake(0, 0, width, height);
        backgImageView.image = [UIImage bundleImageNamed:@"beijingdi"];
        [self addSubview:backgImageView];
        [self layoutHeaderViews];
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    backgImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


-(void)layoutHeaderViews
{
    imgview=(BeeUIImageView *)[ToolsFunc CreateImageViewWithFrame:CGRectMake(0, 0, 80,80) andImgName:@"profile_no_avatar_icon"];
    KT_CORNER_PROFILE(imgview);
    btnprofile=[ToolsFunc CreateButtonWithFrame:CGRectMake(0, 10, 80,80) andTxt:@""];
    [btnprofile addSubview:imgview];
    btnprofile.center=CGPointMake(320/2.0, 60);    
    [self addSubview:btnprofile];
    
    /*
    lblname=[ToolsFunc CreateLabelWithFrame:CGRectMake(20, 110, 150, 40) andTxt:@"用户组:无名氏"];
    lblname.center=CGPointMake( 320/2.0, 110);
    [self addSubview:lblname];*/
    
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
     
    float cellheight =[D1_FriendsInfo_HeaderCell heightOfProfileCell];
    bgView=[[ProfileCell_Items alloc] initWithFrame:CGRectMake(0, cellheight - 60, 320, 60)];
    bgView.seltarget = self;
    bgView.profiletype = PROFILE_OTHER;
    /*
      暂时屏蔽从别人进去看ta的帖子好友等
     */
/*    bgView.btncollectTap = @selector(btncollectTap:);
    bgView.btnfriendTap = @selector(btnfriendTap:);
    bgView.btnReplyTap = @selector(btnReplyTap:);
    bgView.btnsenthtmTap = @selector(btnsenthtmTap:);
    bgView.btncollectTap = @selector(btncollectTap:);*/
    [self addSubview:bgView];
    [bgView reReshButtonsSels];
//    CGRect rect = bgView.bgView.frame;
//    bgView.bgView.center =CGPointMake(320.0/2, CGRectGetMinY(rect));
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
}

+(float)heightOfProfileCell
{
    return 240.0f;
}


-(void)dataDidChanged
{
    //    self.usermodel=(UserModel *)self.data;
    if (self.profile) {
        PROFILE *profile = self.profile;
        [imgview GET:profile.avatar useCache:NO];
        [btnsenthtm setTitle:profile.threads forState:UIControlStateNormal];
        [btnfriend setTitle:profile.friends forState:UIControlStateNormal];
        [btnreply setTitle:profile.replys forState:UIControlStateNormal];
        [btncollect setTitle:profile.favorites forState:UIControlStateNormal];
        lblname.text=[NSString stringWithFormat:@"%@:%@",profile.group,profile.username];
   }
}

-(IBAction)btnsenthtmTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_FriendsInfo_HeaderCell_gotosendhtml:)]) {
        [self.delegate D1_FriendsInfo_HeaderCell_gotosendhtml:self];
    }
}

-(IBAction)btnwealthTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_FriendsInfo_HeaderCell_gotorwealth:)]) {
        [self.delegate D1_FriendsInfo_HeaderCell_gotorwealth:self];
    }
}

-(IBAction)btnReplyTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_FriendsInfo_HeaderCell_gotoreply:)]) {
        [self.delegate D1_FriendsInfo_HeaderCell_gotoreply:self];
    }
}

-(IBAction)btncollectTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_FriendsInfo_HeaderCell_gotocollect:)]) {
        [self.delegate D1_FriendsInfo_HeaderCell_gotocollect:self];
    }
}

-(IBAction)btnfriendTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_FriendsInfo_HeaderCell_gotofriend:)]) {
        [self.delegate D1_FriendsInfo_HeaderCell_gotofriend:self];
    }
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

@end
