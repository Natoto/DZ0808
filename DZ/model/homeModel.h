//
//  homeModel.h
//  DZ
//
//  Created by Nonato on 14-4-25.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import "home.h"

#define KEY_ONOFF @"home.onoff"
#define HOMEPOSITIONKEY @"HOMEPOSITIONKEY4"
#define ARRAYPOSITIONKEY  @"HOME.ArrangedPosition"
#define ArrangedPositionSaved  @"ArrangedPositionSaved"
@interface homeModel : BeeStreamViewModel
AS_SINGLETON(homeModel)
@property (nonatomic, retain) NSArray  *        fids;
@property (nonatomic, retain) NSString *        uid;
@property (nonatomic, retain) NSString *		player_id;
@property (nonatomic, retain) home *	shots;
@property (nonatomic, retain) HOME2 * resp;
@property (nonatomic, retain) onoff *	onoff;
@property(nonatomic,retain)   NSMutableArray * arrangedPositions;

-(void)clearArrangedPosition;
- (void)saveArrangedPosition:(NSArray *)topicsAry;
+(onoff *)readOnff;
@end
