//
//  SubForumsModel.m
//  DZ
//
//  Created by Nonato on 14-4-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#undef	PER_PAGE
#define PER_PAGE	(30)

#import "SubForumsModel.h"
@implementation SubForumsModel

@synthesize forum_fid = _forum_fid;
@synthesize shots = _shots;

- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
    
	self.shots = [NSMutableArray array];
}

- (void)unload
{
	self.shots = nil;
	self.forum_fid = nil;
}

#pragma mark -

- (void)loadCache
{
	[self.shots removeAllObjects];
}

- (void)saveCache
{
}

- (void)clearCache
{
	[self.shots removeAllObjects];
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
		[self gotoPage:(self.shots.count / PER_PAGE + 1)];
	}
}

- (void)gotoPage:(NSUInteger)page
{
    [API_SUBFORUMLIST_SHOTS cancel];
    
	API_SUBFORUMLIST_SHOTS * api = [API_SUBFORUMLIST_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    
	api.fid =self.forum_fid;
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
				if ( nil == api.resp)
				{
					api.failed = YES;
				}
				else
				{
					if ( page <= 1 )
					{
						[self.shots removeAllObjects];
						[self.shots addObjectsFromArray:api.resp.forums];
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.forums];
						[self.shots unique:^NSComparisonResult(id left, id right) {
							return [((FORUMLIST2 *)left).ecode compare:((FORUMLIST2 *)right).ecode];
						}];
					}
					self.more = NO;
					self.loaded = YES;
					[self saveCache];
				}
			}
			[self sendUISignal:self.RELOADED];
		}
	};
	
	[api send];
}

@end
