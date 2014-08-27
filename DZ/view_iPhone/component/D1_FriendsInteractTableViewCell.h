//
//  D1_FriendsInteractTableViewCell.h
//  DZ
//
//  Created by Nonato on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "remind.h"
#import "DZ_BASETableViewCell.h"
@class D1_FriendsInteractTableViewCell;
@protocol D1_FriendsInteractTableViewCellDelegate <NSObject>
-(void)addFriend:(D1_FriendsInteractTableViewCell *)cell;
@end

@interface D1_FriendsInteractTableViewCell : UITableViewCell
{ 
}
@property(nonatomic,strong)automatic *atopic;
@property(nonatomic,assign)NSObject<D1_FriendsInteractTableViewCellDelegate> *delegate;
@property(nonatomic,strong)UILabel  *message;
//@property(nonatomic,strong)BeeUIImageView *cellicon;
@property(nonatomic,strong)UILabel * lbltitle;
//@property(nonatomic,strong)UILabel * lbllandlord;
@property(nonatomic,strong)UILabel * lbltime;
+(float)heightOfD1_FriendsInteractTableViewCell;
-(void)dataChange:(automatic *)matic;
@end
