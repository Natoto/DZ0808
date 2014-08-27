//
//  SupportModel.m
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//

#import "SupportModel.h"
#import "UserModel.h"
@implementation SupportModel
@synthesize  shots=_shots;
- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
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
    
    [API_SUPPORT_SHOTS cancel];
	API_SUPPORT_SHOTS * api = [API_SUPPORT_SHOTS api];
	@weakify(api);
	@weakify(self);
	
    self.uid = [UserModel sharedInstance].session.uid;
    if (!self.type || !self.uid || !self.pid || !self.tid) {
        BeeLog(@"点赞参数不完整。。。");
        return;
    }
    api.tid = self.tid;
    api.uid = self.uid;
    api.type = self.type;
    api.pid = self.pid;
    
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
					self.more = YES; //(api.resp.i.intValue==0)?YES:NO;
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
