//
//  FriendsModel.m
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "FriendsModel.h"

@implementation FriendsModel
@synthesize uid=_uid,shots=_shots;
- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _uid=nil;
    _shots=nil;
}

#pragma mark -

- (void)loadCache
{
    [self.shots removeAllObjects];
    NSString  *key= MYFRIENDOBJECTKEY(self.uid);
    self.shots=[NSMutableArray arrayWithArray:[friends readObjectForKey:key]];
}

- (void)saveCache
{
    [friends saveObject:self.shots forKey:MYFRIENDOBJECTKEY(self.uid)];
}

- (void)clearCache
{
    [self.shots removeAllObjects];
    self.loaded=NO;
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
    
    [API_FRIENDS_SHOTS cancel];
	API_FRIENDS_SHOTS * api = [API_FRIENDS_SHOTS api];
	@weakify(api);
	@weakify(self);
    api.uid=_uid;
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
				if ( nil == api.resp || api.resp.ecode.integerValue)
				{
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{
                    if ( page <= 1 )
					{
						[self.shots removeAllObjects];
						[self.shots addObjectsFromArray:api.resp.friends];
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.friends];
					}
					self.more = (api.resp.isEnd.intValue==0)?YES:NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
                    [self sendUISignal:self.FAILED withObject:api.description];
            }
		}
	};
	
	[api send];
}
@end
