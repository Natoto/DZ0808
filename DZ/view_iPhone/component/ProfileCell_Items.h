//
//  ProfileCell_Items.h
//  DZ
//
//  Created by Nonato on 14-8-6.
//
//
typedef NS_ENUM(NSUInteger, PROFILE_TYPE)
{
    PROFILE_OTHER,
    PROFILE_SELF,
};
#import <UIKit/UIKit.h>
@class RedPoint;
@interface ProfileCell_Items : UIView
@property(nonatomic,retain)UIView      * bgView;
@property(nonatomic,retain)UIButton    * lblsendhtm;
@property(nonatomic,retain)UIButton    * btnsenthtm;
@property(nonatomic,retain)UIButton    * lblfriend;
@property(nonatomic,retain)UIButton    * btnfriend;
@property(nonatomic,retain)UIButton    * lblmessage;
@property(nonatomic,retain)UIButton    * btnmessage;
@property(nonatomic,retain)UIButton    * lblcollect;
@property(nonatomic,retain)UIButton    * btncollect;
@property(nonatomic,retain)UIButton    * lblreply;
@property(nonatomic,retain)UIButton    * btnreply;
@property(nonatomic,retain)RedPoint    * redpt;
@property(nonatomic,retain)RedPoint    * redpt_frd;
@property(nonatomic,assign)SEL btnsenthtmTap;
@property(nonatomic,assign)SEL btnfriendTap;
@property(nonatomic,assign)SEL btnmessageTap;
@property(nonatomic,assign)SEL btnReplyTap;
@property(nonatomic,assign)SEL btncollectTap;
@property(nonatomic,assign)id  seltarget;

@property(nonatomic,assign)PROFILE_TYPE profiletype;
-(void)reReshButtonsSels;
@end
