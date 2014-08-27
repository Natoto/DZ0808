//
//  A1_Newest_iphone.h
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_UIBoard.h"
#import "Bee.h"
#import "BaseBoard_iPhone.h"
#import "newOrHotlistModel.h"
#import "Constants.h"
#import "B3_PostViewController.h"
#import "Base_TableviewController.h"
#import "testViewController.h"
@interface A1_Newest_iphone : Base_TableviewController
//@property(nonatomic,retain) UITableView       * list;
@property(nonatomic,strong) newOrHotlistModel * newhotModel;
@end
