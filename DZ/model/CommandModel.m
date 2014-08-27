//
//  CommandModel.m
//  DZ
//
//  Created by Nonato on 14-6-10.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "CommandModel.h"
#import "COMMAND.h"
#define KEY_COMMAND @"command_key"
@implementation CommandModel

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
}

#pragma mark -

- (void)loadCache
{
	[self.shots removeAllObjects];
    [self.shots addUniqueObjectsFromArray:[command readObjectForKey:KEY_COMMAND]
                                  compare:^NSComparisonResult(id left, id right) {
                                      return [((command *)left).tid compare:((command *)right).tid];
                                  }];
}

- (void)saveCache
{
    [command saveObject:self.shots forKey:KEY_COMMAND];
    //    [NSArray userDefaultsWrite:[self.shots objectToString] forKey:@"ForumlistModel"];
}

- (void)clearCache
{
    [command removeObjectForKey:KEY_COMMAND];
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
    [self firstPage];
}

- (void)gotoPage:(NSUInteger)page
{
    [API_COMMAND_SHOTS cancel];
    
	API_COMMAND_SHOTS * api = [API_COMMAND_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    
	
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
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{
					 
                    [self.shots removeAllObjects];
                    [self.shots addObjectsFromArray:api.resp.command];
					 
					self.more = NO;
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
