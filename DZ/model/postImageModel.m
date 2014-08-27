//
//  postImageModel.m
//  DZ
//
//  Created by Nonato on 14-5-6.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "postImageModel.h"
#import "postImage.h"
@implementation postImageModel
@synthesize filedata=_filedata,filename=_filename,fid=_fid,uid=_uid;
- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _fid=nil;
    _uid=nil;
    _filename=nil;
    _filedata=nil;
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
    [API_POSTIMAGE_SHOTS cancel];
    
	API_POSTIMAGE_SHOTS * api = [API_POSTIMAGE_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    api.fid=_fid;
    api.uid=_uid;
    api.filename=_filename;
    api.filedata=_filedata;
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
                    self.postimge=api.resp;
					self.more = NO;
					self.loaded = YES;
                    [self sendUISignal:self.RELOADED];
                    //					[self saveCache];
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
