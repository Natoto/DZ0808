//
//  SubForumsModel.h
//  DZ
//
//  Created by Nonato on 14-4-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#define OBJECTKEY(fid,type) [NSString stringWithFormat:@"%@:%@",fid,type]
#import "Bee_OnceViewModel.h"
#import "Bee.h" 
#import "forumlist.h"
@interface SubForumsModel : BeeStreamViewModel

@property (nonatomic, retain) NSString   	 * forum_fid;
@property (nonatomic, retain) NSMutableArray * shots;

@end
