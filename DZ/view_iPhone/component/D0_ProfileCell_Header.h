//
//  ProfileCell_Header.h
//  xmlaaa
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "UserModel.h"
#import "RemindModel.h"
#import "Bee_UICell.h"
//----------------------------------------------------------------- 倒圆角
//#define KT_CORNER_RADIUS(_OBJ,_RADIUS)   _OBJ.layer.masksToBounds = YES;\
//_OBJ.layer.cornerRadius = _RADIUS;
//
//#define KT_CORNER_RADIUS_VALUE_2    2.0f
//#define KT_CORNER_RADIUS_VALUE_5    5.0f
//#define KT_CORNER_RADIUS_VALUE_10   10.0f
//#define KT_CORNER_RADIUS_VALUE_15   15.0f
//#define KT_CORNER_RADIUS_VALUE_20   20.0f
//---------------------------------------------------------------- 倒圆角
#import "Bee.h"
@class RedPoint;
@class ProfileCell_Items;
@interface D0_ProfileCell_Header : UITableViewCell
{
//    UILabel     * lbltips;
    BeeUIImageView * imgview;
    UIButton    * btnprofile;
    UIButton    * btnwealth;
    UILabel     * lblname;
    UILabel     * lblcredit;
    UIButton    * btnlogin;
    UIButton    * lblsendhtm;
    UIButton    * btnsenthtm;
    UIButton    * lblfriend;
    UIButton    * btnfriend;
    UIButton    * lblmessage;
    UIButton    * btnmessage;
    UIButton    * lblcollect;
    UIButton    * btncollect;
    UIButton    * lblreply;
    UIButton    * btnreply;
    UIImageView     * backgImageView;
    CALayer     * linelayer;
//    UIButton    * lblcredit;
//    UIButton    * btncredit;
    ProfileCell_Items      * bgView;
    RedPoint    * redpt;
    RedPoint    * redpt_frd;
    UIView      * QD_View;
    UIView      * QD_View_BUTTON;
//    UIButton    *btnlogout;
}
AS_SIGNAL(wealth)
AS_SIGNAL(login)
AS_SIGNAL(logout)
AS_SIGNAL(profileinfo);
AS_SIGNAL(gotosendhtml)
AS_SIGNAL(gotofriend)
AS_SIGNAL(gotomessage)
AS_SIGNAL(gotocollect)
AS_SIGNAL(gotoreply)
AS_SIGNAL(gotocredit)
AS_SIGNAL(gotoqiandao)
@property(nonatomic,assign)BOOL LOGEDIN;
@property(nonatomic,retain)UserModel *usermodel;

-(void)dataDidChanged;
+(float)heightOfProfileCell;
-(void)newmessage:(int)count;
@end
