//
//  ModifyPersonalInfoModel.m
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "ModifyPersonalInfoModel.h"

@implementation ModifyPersonalInfoModel
@synthesize modifyReq=_modifyReq;


- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _modifyReq=nil;
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

-(void)submitModifyInfo:(REQ_MODIFYPROFILE_SHOTS *)req
{
    [self gotoPage:1];
}
#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
    [self gotoPage:1];
}

- (void)gotoPage:(NSUInteger)page
{

    [API_MODIFYPROFILE_SHOTS cancel];
	API_MODIFYPROFILE_SHOTS * api = [API_MODIFYPROFILE_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    if (NULL == self.modifyReq.uid) {
        return;
    }
    
    api.req=self.modifyReq;
	
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
                    [self sendUISignal:self.FAILED];
				}
				else
				{
					self.more = NO;
					self.loaded = YES;
                    [self sendUISignal:self.RELOADED];
				}
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
