//
//  D0_MINE.h
//  DZ
//
//  Created by Nonato on 14-4-1.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_UIBoard.h"
#import "Bee.h"
#import "UserModel.h" 
#import "D1_LoginBoard_iphone.h"
#import "model.h"
#import "BaseBoard_iPhone.H"
#import "D1_CollectionViewController_iphone.h"
#import "D1_MypostViewController_iphone.h"
#import "D1_FriendsViewController_iphone.h"
#import "RemindModel.h"
#import "Board_BaseTableViewCTR.h"
@interface D0_Mine_iphone : Board_BaseTableViewCTR
AS_SINGLETON(D0_Mine_iphone)
@property(nonatomic,assign)BOOL LoginSuccess;
//@property(nonatomic,retain)UITableView *list;
//AS_OUTLET( BeeUIScrollView, list )
AS_MODEL(UserModel, lginModel)
@property(nonatomic,retain)RemindModel *remindModel;
@end
