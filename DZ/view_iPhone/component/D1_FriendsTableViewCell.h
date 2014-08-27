//
//  D1_FriendsTableViewCell.h
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "DZ_BASETableViewCell.h"
#import "RedPoint.h"
@class D1_FriendsTableViewCell;
@protocol D1_FriendsTableViewCellDelegate <NSObject>
-(void)D1_FriendsTableViewCell:(D1_FriendsTableViewCell *)cell avator:(id)sender;
@end


@class friends;
@interface D1_FriendsTableViewCell : UITableViewCell
{
    BeeUIImageView * avatar;
    UILabel        * name;
    UILabel        * message;
    UILabel        * time;
    RedPoint       * redpt;
}
@property(nonatomic,strong) NSIndexPath * indexPath;
@property(nonatomic,assign) NSObject<D1_FriendsTableViewCellDelegate> *delegate;
@property(nonatomic,strong) UILabel    * message;
@property(nonatomic,strong)friends     * thisfriend;
@property(nonatomic,assign) BOOL        havenewmessage;
-(void)setcellData:(friends *)myfriends;
-(void)avatarTap:(UIGestureRecognizer *)gesture;
+(float)heightOfFriendsCell; 
@end
