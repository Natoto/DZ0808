//
//  B0_ForumPlates.h
//  DZ
//
//  Created by Nonato on 14-4-1.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import "Bee_UIBoard.h"
//#import "ForumsModel.h"
#import "ForumlistModel.h"
#import "BaseBoard_iPhone.h"
#import "B1_ATopicViewController.h" 
#import "QCSlideViewController.h"
//#import "EGORefreshTableHeaderView.h"
//#import "EGOViewCommon.h"
#import "UIImage+Tint.h"
#import "Board_BaseTableViewCTR.h"
#define MARK @"1"
#define UNMARK @"0"
@class A0_HomePage1_iphone;
@interface B0_ForumPlates_iphone : Board_BaseTableViewCTR<UITableViewDataSource,UITableViewDelegate>
{
//    EGORefreshTableHeaderView * _refreshHeaderView;
	BOOL _reloading;
}
@property(nonatomic,retain)NSMutableDictionary * selectedFiddic;
//@property(nonatomic,strong)NSMutableArray * ModeleBlocks;
AS_MODEL(ForumlistModel, fmModel)
AS_NOTIFICATION(FORUMADDTOHOME)
AS_NOTIFICATION(FORUMREMOVEFROMEHOME)
@end
