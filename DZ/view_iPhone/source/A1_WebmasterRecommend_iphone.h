//
//  A1_WebmasterRecommend_iphone.h
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "BaseBoard_iPhone.h"
#import "Bee_UIBoard.h"
#import "Bee.h"  
#import "Board_BaseTableViewCTR.h"
@class CommandModel;
@interface A1_WebmasterRecommend_iphone : Board_BaseTableViewCTR <UITableViewDataSource,UITableViewDelegate>
//@property(nonatomic,strong)UITableView *list;
@property(nonatomic,strong)CommandModel * commandmodel;
@end
