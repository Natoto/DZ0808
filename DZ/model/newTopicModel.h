//
//  newTopicModel.h
//  DZ
//
//  Created by Nonato on 14-4-28.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#undef	PER_PAGE
#define PER_PAGE	(30)
#import "Bee.h"
#import "Bee_StreamViewModel.h"
#import "newTopic.h"
@interface newTopicModel : BeeStreamViewModel
@property (nonatomic, retain) NSString *		fid;
@property (nonatomic, retain) NSString *		subject;
@property (nonatomic, retain) NSString *		sortid;
@property (nonatomic, retain) NSNumber *		typedid;
@property (nonatomic, retain) NSString *		authorid;
@property (nonatomic, retain) NSString *		author;
@property (nonatomic, retain) NSMutableArray *	contents;
AS_SINGLETON(newTopicModel)
-(void)savedraft:(NSArray *)array;
-(NSMutableArray *)loaddratfs;
-(void)clearDrafts;
@end
