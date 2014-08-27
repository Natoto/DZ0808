//
//  ModeavatarModel.m
//  DZ
//
//  Created by Nonato on 14-5-19.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "ModeavatarModel.h"
#import "Bee.h"
@implementation ModeavatarModel
@synthesize uid=_uid,modavatar=_modavatar,imgdata=_imgdata;

- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _modavatar=nil;
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
    [self gotoPage:1];
}

- (void)gotoPage:(NSUInteger)page
{
    
    [API_MODAVATAR_SHOTS cancel];
	API_MODAVATAR_SHOTS * api = [API_MODAVATAR_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    if (NULL == self.uid || NULL == self.imgdata) {
        return;
    }
    
    api.uid=self.uid;
	api.imageData=self.imgdata;
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
					self.more = NO;
					self.loaded = YES;
                    self.modavatar=api.resp;
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