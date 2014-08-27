//
//  collectionModel.h
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#undef	PER_PAGE
#define PER_PAGE	(20)
#define COLLECTIONOBJECTKEY(uid) [NSString stringWithFormat:@"collectionModel.%@",uid]

#import "Bee_StreamViewModel.h"
#import "collection.h"
@interface collectionModel : BeeStreamViewModel
@property (nonatomic, retain) NSString          *    uid;
@property (nonatomic,retain)  NSMutableArray    *    shots;
 
@end
