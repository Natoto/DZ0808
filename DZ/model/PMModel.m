//
//  PMModel.m
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "PMModel.h"
#import "pm.h"
@implementation PMModel
- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _uid=nil;
    _filter=nil;
    _strangerms=nil;
    _grouppms=nil;
}

#pragma mark -

-(void)loadCache:(MSG_TYPE_FILTE)msg_type
{
    NSString *key=MODELOBJECTKEY(NSStringFromClass([self class]),[NSString stringWithFormat:@"%d",msg_type]);
    self.filter=[NSString stringWithFormat:@"%d",msg_type];
    self.strangerms = [pm_strangerms readObjectForKey:key];
    self.grouppms=[pm_grouppms readObjectForKey:key];
}

- (void)saveCache
{
    NSString *key=MODELOBJECTKEY(NSStringFromClass([self class]),self.filter);
    [pm_strangerms saveObject:self.strangerms forKey:key];
    [pm_grouppms saveObject:self.grouppms forKey:key];
    
}

- (void)clearCache:(MSG_TYPE_FILTE)msg_type
{
      NSString *key=MODELOBJECTKEY(NSStringFromClass([self class]),[NSString stringWithFormat:@"%d",msg_type]);
    [pm_strangerms removeObjectForKey:key];
    [pm_grouppms readObjectForKey:key];
    
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
    [API_PM_SHOTS cancel];
	API_PM_SHOTS * api = [API_PM_SHOTS api];
 	@weakify(api);
 	@weakify(self);
    
    if (NULL == _uid || NULL == _filter ) {
        return;
    }
    api.uid=_uid;
    api.filter=_filter;
	
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
                    self.strangerms=api.resp.strangerms;
                    self.grouppms=api.resp.grouppms;
 					self.more = NO;
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
