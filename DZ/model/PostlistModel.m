//
//  PostlistModel.m
//  DZ
//
//  Created by Nonato on 14-4-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "UserModel.h"
#import "PostlistModel.h"

#undef	PER_PAGE
#define PER_PAGE	(20)
#define OBJECTKEY(tid,type) [NSString stringWithFormat:@"PostlistModel.tid.%@.%@",tid,type]
#define OBJECTMAINTOPKEY(tid,type) [NSString stringWithFormat:@"PostlistModel.maintop.%@.%@",tid,type]

@implementation PostlistModel
@synthesize uid=_uid;
@synthesize type=_type;
@synthesize tid =_tid;
@synthesize shots = _shots;
@synthesize onlyauthorid=_onlyauthorid;

- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
	self.shots = [NSMutableArray array];
    self.type=@"0";
    self.tid=@"0";
}

- (void)unload
{
	self.shots = nil;
	self.tid = nil;
    self.type=nil;
}

#pragma mark -

- (void)loadCache
{
 	[self.shots removeAllObjects];
    NSString  *key= OBJECTKEY(self.tid,self.type);
    self.shots=[NSMutableArray arrayWithArray:[post readObjectForKey:key]];

    self.maintopic=nil;
     NSString  *tpckey= OBJECTMAINTOPKEY(self.tid,self.type);
    self.maintopic=[topic readObjectForKey:tpckey];
}

- (void)saveCache
{
     [post saveObject:self.shots forKey:OBJECTKEY(self.tid,self.type)];
     [topic saveObject:self.maintopic forKey:OBJECTMAINTOPKEY(self.tid, self.type)];
}

- (void)clearCache
{
	[self.shots removeAllObjects];
     [post removeObjectForKey:OBJECTKEY(self.tid, self.type)];

    self.maintopic=nil;
    [topic removeObjectForKey:OBJECTMAINTOPKEY(self.tid, self.type)];
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
	if ( self.shots.count )
	{
		[self gotoPage:((self.shots.count +1) / PER_PAGE + 1)];
	}
}

- (void)gotoPage:(NSUInteger)page
{
    [API_POSTLIST_SHOTS cancel];
	API_POSTLIST_SHOTS * api = [API_POSTLIST_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    
    self.uid=[UserModel sharedInstance].session.uid;
    api.uid=self.uid;
    api.onlyauthorid=self.onlyauthorid;
	api.tid = self.tid;
	api.req.page = @(page);
	api.req.per_page = @(PER_PAGE);

	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);
        
		if ( api.sending )
		{
			[self sendUISignal:self.RELOADING];
		}
		else
		{
			if ( api.succeed )
			{
				if ( nil == api.posts)
				{
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:@"ERROR!"];
				}
				else
				{
                    if (api.posts.ecode.integerValue) {
                        [self sendUISignal:self.FAILED withObject:api.posts.emsg];
                        return ;
                    }
					if ( page <= 1 )
					{
						[self.shots removeAllObjects];
						[self.shots addObjectsFromArray:api.posts.post];
                        self.maintopic = api.posts.topic;
					}
					else
					{
//                        self.maintopic = api.posts.topic;
						[self.shots addObjectsFromArray:api.posts.post];
//						[self.shots unique:^NSComparisonResult(id left, id right) {
//							return [((post *)left).tid compare:((post *)right).tid];
//						}];
					}
					self.more = !api.posts.isEnd.intValue; //(self.shots.count >= api.resp.total.intValue) ? NO : YES;;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
                [self sendUISignal:self.FAILED];
            }
		}
	};
	
	[api send];
}

-(content_vote *)analysisVoteMsg:(NSDictionary *)dic
{
    return [content_vote objectFromDictionary:(NSDictionary *)dic];
}

@end
