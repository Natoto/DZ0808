//
//  replyModel.h
//  DZ
//
//  Created by Nonato on 14-5-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#undef	PER_PAGE
#define PER_PAGE	(30)
#import "Bee_StreamViewModel.h"
#import "Bee.h"
#import "reply.h"
@interface replyModel : BeeStreamViewModel
@property (nonatomic, retain) NSString *		fid;
@property (nonatomic, retain) NSString *		tid;
@property (nonatomic, retain) NSString *		pid;
@property (nonatomic, retain) NSString *		authorid; 
@property (nonatomic, retain) NSMutableArray *	contents;
@property (nonatomic, retain) REPLY    *        shots;
@end
