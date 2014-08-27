//
//  collectionModel.m
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "collectionModel.h"

@implementation collectionModel
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
    NSString  *key= COLLECTIONOBJECTKEY(self.uid);
    self.shots=[NSMutableArray arrayWithArray:[collection readObjectForKey:key]];
}

- (void)saveCache
{
    [collection saveObject:self.shots forKey:COLLECTIONOBJECTKEY(self.uid)];
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
    
    [API_COLLECTION_SHOTS cancel];
	API_COLLECTION_SHOTS * api = [API_COLLECTION_SHOTS api];
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
						[self.shots addObjectsFromArray:api.resp.collection];
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.collection];
					}
					self.more = (api.resp.isEnd.intValue==0)?YES:NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
            }
		}
	};
	
	[api send];
}

@end
