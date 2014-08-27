//
//  newOrHotlistModel.h
//  DZ
//
//  Created by Nonato on 14-4-28.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#undef	PER_PAGE
#define PER_PAGE	(30)
#define KEYWITH(type,fid) [NSString stringWithFormat:@"%@:%@",type,fid]
#import "Bee_StreamViewModel.h"
#import "Bee.h"
@interface newOrHotlistModel : BeeStreamViewModel
@property (nonatomic, retain) NSString *        fid;
@property (nonatomic, retain) NSNumber *		type;
@property (nonatomic, retain) NSMutableArray *	shots;

@end
