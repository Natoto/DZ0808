//
//  D1_FriendsInfoCell.h
//  DZ
//
//  Created by Nonato on 14-6-17.
//
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "DZ_BASETableViewCell.h"
@class PROFILE;

@class D1_FriendsInfo_HeaderCell;
@protocol D1_FriendsInfo_HeaderCellDelegate <NSObject>
-(void)D1_FriendsInfo_HeaderCell_gotosendhtml:(D1_FriendsInfo_HeaderCell *)cell;
-(void)D1_FriendsInfo_HeaderCell_gotofriend:(D1_FriendsInfo_HeaderCell *)cell;
-(void)D1_FriendsInfo_HeaderCell_gotocollect:(D1_FriendsInfo_HeaderCell *)cell;
-(void)D1_FriendsInfo_HeaderCell_gotoreply:(D1_FriendsInfo_HeaderCell *)cell;
-(void)D1_FriendsInfo_HeaderCell_gotorwealth:(D1_FriendsInfo_HeaderCell *)cell;

@optional
-(void)B3_HeadCellProfileBtnTapped:(D1_FriendsInfo_HeaderCell *)obj;
@end

@class ProfileCell_Items;
@interface D1_FriendsInfo_HeaderCell : UITableViewCell
{
    UILabel     * lbltips;
    BeeUIImageView * imgview;
    UIButton    * btnprofile;
    UILabel     * lblname;
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
    UIButton   * btnwealth;
    ProfileCell_Items      * bgView;
    UIImageView * backgImageView;
}

@property(nonatomic,assign)NSObject <D1_FriendsInfo_HeaderCellDelegate> *delegate;
@property(nonatomic,retain)PROFILE *profile;

-(void)dataDidChanged;
+(float)heightOfProfileCell;
@end
