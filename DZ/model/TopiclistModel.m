//
//  TopiclistModel.m
//  DZ
//
//  Created by Nonato on 14-4-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "TopiclistModel.h"
#undef	PER_PAGE
#define PER_PAGE	(20)
#define OBJECTKEY(fid,type) [NSString stringWithFormat:@"TopiclistModel.fid.%@.%@",fid,type]
@implementation TopiclistModel
@synthesize type=_type;
@synthesize fid = fid;
@synthesize shots = _shots;
@synthesize end = _end;
- (void)load
{
	self.autoSave = NO;
	self.autoLoad = YES;
	self.shots = [NSMutableArray array];
    self.type=@"0";
    self.fid=@"0";
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
    NSString  *key= OBJECTKEY(self.fid,self.type);
    self.shots=[NSMutableArray arrayWithArray:[topics readObjectForKey:key]];
//    [self.shots addUniqueObjectsFromArray:[topics readObjectForKey:key]
//                                  compare:^NSComparisonResult(id left, id right) {
//                                      return [((topics *)left).fid compare:((topics *)right).fid];
//                                  }];
//   NSLog(@"%@",self.shots);
}

- (void)saveCache
{
    [topics saveObject:self.shots forKey:OBJECTKEY(self.fid,self.type)];
}

- (void)clearCache
{
	[self.shots removeAllObjects];
    [topics removeObjectForKey:OBJECTKEY(self.fid,self.type)];
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
        int page=self.shots.count / PER_PAGE + 1;
		[self gotoPage:page];
	}
}

- (void)gotoPage:(NSUInteger)page
{
    [API_TOPICLIST_SHOTS cancel];
	API_TOPICLIST_SHOTS * api = [API_TOPICLIST_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    
    api.type=self.type;
	api.fid = self.fid;
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
				if ( nil == api.topics)
				{
					api.failed = YES;
				}
				else
				{
					if ( page <= 1 )
					{
						[self.shots removeAllObjects];
						[self.shots addObjectsFromArray:api.topics.topics];
					}
					else
					{
						[self.shots addObjectsFromArray:api.topics.topics];
//						[self.shots unique:^NSComparisonResult(id left, id right) {
//							return [((topics *)left).fid compare:((topics *)right).fid];
//						}];
					}
                    BeeLog(@"page =%d api.topics.isEnd = %d",page,api.topics.isEnd);
					self.end = api.topics.isEnd.boolValue; //(self.shots.count >= api.resp.total.intValue) ? NO : YES;;
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
