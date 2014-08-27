//
//  newOrHotlistModel.m
//  DZ
//
//  Created by Nonato on 14-4-28.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "newOrHotlistModel.h"
#import "neworhotlist.h"
@implementation newOrHotlistModel
@synthesize fid=_fid;
@synthesize type = _type;
@synthesize shots = _shots;

- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
    self.fid=@"";
//    self.type=[NSNumber numberWithInt:1];
	self.shots = [NSMutableArray array];
}

- (void)unload
{
	self.shots = nil;
	self.fid = nil;
    self.type=nil;
}

#pragma mark -

- (void)loadCache
{
	[self.shots removeAllObjects];
    [self.shots addUniqueObjectsFromArray:[neworlisttopics readObjectForKey:KEYWITH( self.type,self.fid)]
                                  compare:^NSComparisonResult(id left, id right) {
                                      return [((neworlisttopics *)left).fid compare:((neworlisttopics *)right).fid];
                                  }];
}

- (void)saveCache
{
    [neworlisttopics saveObject:self.shots forKey:KEYWITH( self.type,self.fid)];
    //    [NSArray userDefaultsWrite:[self.shots objectToString] forKey:@"ForumlistModel"];
}

- (void)clearCache
{
    [neworlisttopics removeObjectForKey:KEYWITH(self.type, self.fid)];
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
    [API_NEWORHOT_SHOTS cancel];
    
	API_NEWORHOT_SHOTS * api = [API_NEWORHOT_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    api.fid=self.fid;
    api.type = self.type;
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
						[self.shots addObjectsFromArray:api.resp.topics];
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.topics];
						[self.shots unique:^NSComparisonResult(id left, id right) {
							return [((neworlisttopics *)left).fid compare:((neworlisttopics *)right).fid];
						}];
					}
					self.more = NO;
					self.loaded = YES;
					[self saveCache];
				}
			   [self sendUISignal:self.RELOADED];
			}
            else
            {
                [self sendUISignal:self.FAILED];
            }
		}
	};
	
	[api send];
}
@end
