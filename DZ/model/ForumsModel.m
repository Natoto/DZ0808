//
//  ForumsModel.m
//  DZ
//
//  Created by Nonato on 14-4-8.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "ForumsModel.h"

@implementation ForumsModel
DEF_SINGLETON(ForumsModel)
DEF_NOTIFICATION(FORUMS)
//@synthesize forumlist=_forumlist;
@synthesize forums=_forums;

- (void)load
{
//    self.forumlist=[[FORUMLIST alloc] init];
    self.forums=[[NSMutableArray alloc] initWithCapacity:0];
 	[self loadCache];
}

- (void)unload
{
	[self saveCache]; 
//    self.forumlist=nil;
    [_forums removeAllObjects];
}

#pragma mark -

- (void)loadCache
{
    [_forums removeAllObjects];
    [_forums addObjectsFromArray:[FORUMS readFromUserDefaults:@"ForumsModel.forumlist"]];

    for(FORUMS *fm in _forums)
    {
        NSMutableArray *ary2=[[NSMutableArray alloc] initWithCapacity:0];
        for(NSDictionary *dic in fm.children)
          [ary2 addObject:[self decodeForums:dic]];
        fm.children=ary2;
    }
    
//	self.forumlist=nil;
//    self.forumlist=[FORUMLIST readFromUserDefaults:@"ForumsModel.forumlist"];
}

-(FORUMS *)decodeForums:(NSDictionary *)childDic
{
    FORUMS *aforum=[[FORUMS alloc] init];
    aforum.fid=[childDic valueForKey:@"fid"];
    aforum.icon=[childDic valueForKey:@"icon"];
    aforum.name=[childDic valueForKey:@"name"];
    aforum.lastpost=[childDic valueForKey:@"lastpost"];
    aforum.onlineusers=[childDic valueForKey:@"onlineusers"];
    aforum.posts=[childDic valueForKey:@"posts"];
    aforum.threads=[childDic valueForKey:@"threads"];
    aforum.todayposts=[childDic valueForKey:@"todayposts"];
    aforum.type=[childDic valueForKey:@"type"];
    return aforum;
}

- (void)saveCache
{
//    BeeLog(@"%@",[self.forumlist objectToString]);
//	[FORUMLIST userDefaultsWrite:[self.forumlist objectToString] forKey:@"ForumsModel.forumlist"];
    
    [FORUMS userDefaultsWrite:[_forums objectToString] forKey:@"ForumsModel.forumlist"];
}

- (void)clearCache
{
	[FORUMS removeFromUserDefaults:@"ForumsModel.forumlist"];
    [self.forums removeAllObjects];
	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.forumlist );
	self.MSG( API.forumlist);
}

#pragma mark -

ON_MESSAGE3( API, forumlist, msg )
{
	if ( msg.succeed )
	{
		FORUMLIST * formlist = msg.GET_OUTPUT(@"forumlistRes" );
		if ( 0 != formlist.status.ecode.integerValue )
		{
			msg.failed = YES;
			return;
		}
        [_forums removeAllObjects];
        [_forums addObjectsFromArray:formlist.forums];
//        self.forumlist=nil;
//        self.forumlist=msg.GET_OUTPUT(@"forumlistRes");
		self.loaded = YES;
		[self saveCache];
        [self postNotification:self.FORUMS];
	}
    else if (msg.failed)
    {
        BeeLog(@"failed------%@",msg.description);
    }
    
}

@end
