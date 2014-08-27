//
//  PostpmModel.m
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "PostpmModel.h"
#import "postpm.h"
#import "rmbdz.h"
@implementation PostpmModel
@synthesize uid=_uid,touid=_touid,message=_message;
- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _uid=nil;
    _touid=nil;
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
    
}

- (void)clearCache
{
    
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
    
    [API_POSTPM_SHOTS cancel];
	API_POSTPM_SHOTS * api = [API_POSTPM_SHOTS api];
 	@weakify(api);
 	@weakify(self);
    
    if (NULL == _uid || NULL == _touid || NULL == _message) {
        return;
    }
    api.uid=_uid;
    api.touid=_touid;
    api.message=_message;
	
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
                    self.resp=api.resp;
 					self.more = NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
//                     [self sendUISignal:self.FAILED withObject:[STATUS errmessage:ERR_MSGSENDERROR]];
            }
		}
	};
	
	[api send];
}

@end
