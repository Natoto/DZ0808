//
//  AddfriendModel.m
//  DZ
//
//  Created by Nonato on 14-6-18.
//
//

#import "AddfriendModel.h"
#import "addfriend.h"
#import "rmbdz.h"
@implementation AddfriendModel
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
    
}

- (void)saveCache
{
}

- (void)clearCache
{
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
    
    [API_ADDFRIEND_SHOTS cancel];
	API_ADDFRIEND_SHOTS * api = [API_ADDFRIEND_SHOTS api];
	@weakify(api);
	@weakify(self);
    api.uid=_uid;
	api.frdid = _fid;
    
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
                    self.shots = api.resp;
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{
                    self.shots = api.resp;
                    self.more = NO;
                    self.loaded = YES;
                    [self saveCache];                    
                    [self sendUISignal:self.RELOADED];
                }
			}            
		}
	};
	
	[api send];
}
@end
