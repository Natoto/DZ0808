//
//  A2_PlatesSelectBoard_iphone.h
//  DZ
//
//  Created by Nonato on 14-4-18.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_UIBoard.h"
#import "Bee_UIBoard.h" 
#import "ForumlistModel.h"
#import "A0_HomePage1_iphone.h"
#import "home.h"
@interface A2_PlatesSelectBoard_iphone : BeeUIBoard
AS_MODEL(ForumlistModel, fmModel)
@property(nonatomic,assign)A0_HomePage1_iphone *delegate;
@property(nonatomic,strong)NSMutableArray * ModeleBlocks;
@property(nonatomic,retain)NSMutableDictionary * selectedFiddic;
 
@end
