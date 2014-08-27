//
//  ForumsModel.h
//  DZ
//
//  Created by Nonato on 14-4-8.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import "Bee_OnceViewModel.h"
#import "rmbdz.h"
@interface ForumsModel : BeeOnceViewModel
AS_SINGLETON( ForumsModel )
AS_NOTIFICATION(FORUMS)
//@property (nonatomic, retain) FORUMLIST *	forumlist;
@property(nonatomic,retain)NSMutableArray *forums;
@end
