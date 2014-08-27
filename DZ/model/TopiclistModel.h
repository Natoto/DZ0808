//
//  TopiclistModel.h
//  DZ
//
//  Created by Nonato on 14-4-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_OnceViewModel.h"
#import "Bee.h" 
#import "Topiclist.h"
@interface TopiclistModel : BeeStreamViewModel
@property(nonatomic,retain)   NSString *        type;
@property (nonatomic, retain) NSString *		fid;
@property (nonatomic, retain) NSMutableArray *	shots;
@property(nonatomic,assign) BOOL end;
@end
