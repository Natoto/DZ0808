//
//  replyModel.m
//  DZ
//
//  Created by Nonato on 14-5-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "replyModel.h"

@implementation replyModel
@synthesize fid=_fid,tid=_tid, authorid=_authorid,contents=_contents;

- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _fid=nil;
    _tid=nil;
    _authorid=nil;
    [_contents removeAllObjects];
    _contents=nil;
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
    [API_REPLAY_SHOTS cancel];
    
	API_REPLAY_SHOTS * api = [API_REPLAY_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    api.pid = _pid.length?_pid:@"";
    api.fid=_fid;
    api.tid=_tid;
    api.authorid=_authorid;
    api.reqcontentAry=_contents;
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
                    self.shots = api.resp;
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{
					self.more = NO;
					self.loaded = YES;
                    [self sendUISignal:self.RELOADED];
                    //					[self saveCache];
				}
			}
            else
            {
                [self sendUISignal:self.FAILED];
            }
            _pid=@"";
		}
	};
	
	[api send];
}
@end
