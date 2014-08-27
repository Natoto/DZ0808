//
//  PostlistModel.h
//  DZ
//
//  Created by Nonato on 14-4-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_OnceViewModel.h"
#import "Bee.h" 
#import "postlist.h"

@interface PostlistModel : BeeStreamViewModel

@property(nonatomic,retain)   NSString *        onlyauthorid;
@property(nonatomic,retain)   NSString *        type;
@property (nonatomic, retain) NSString *		tid;
@property(nonatomic,retain)   NSString *        uid;
@property (nonatomic, retain) NSMutableArray *	shots;
@property(nonatomic,retain)   topic     * maintopic;

-(content_vote *)analysisVoteMsg:(NSDictionary *)dic;

@end
