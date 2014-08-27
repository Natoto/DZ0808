//
//  PostmineModel.m
//  DZ
//
//  Created by Nonato on 14-7-31.
//
//

#import "PostmineModel.h"
#import "postmine.h"
@implementation PostmineModel
- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
    NSString *myclass= NSStringFromClass([self class]);
    NSString *myuid=self.uid?self.uid:@"NULL";
    key=  MODELOBJECTKEY(myclass,myuid);
}

- (void)unload
{
    _uid=nil;
    _shots=nil;
}
-(void)setUid:(NSString *)uid
{
    _uid=uid;
    NSString *myclass= NSStringFromClass([self class]);
    NSString *myuid=_uid?_uid:@"NULL";
    key=  MODELOBJECTKEY(myclass,myuid);
}

#pragma mark -

- (void)loadCache
{
    [self.shots removeAllObjects];
    self.shots=[NSMutableArray arrayWithArray:[postmine readObjectForKey:key]];
}

- (void)saveCache
{
    [postmine saveObject:self.shots forKey:key];
}

- (void)clearCache
{
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
    /*if ( self.shots.count )
	{
		[self gotoPage:(self.shots.count / PER_PAGE + 1)];
	}*/
}

- (void)gotoPage:(NSUInteger)page
{
    
    [API_POSTMINEL_SHOTS cancel];
	API_POSTMINEL_SHOTS * api = [API_POSTMINEL_SHOTS api];
	@weakify(api);
	@weakify(self);
    api.uid=_uid;
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
                    [self sendUISignal:self.FAILED];
				}
				else
				{
                    if ( page <= 1 )
					{
						[self.shots removeAllObjects];
						[self.shots addObjectsFromArray:api.resp.postmine];
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.postmine];
					}
					self.more = NO;//(api.resp.isEnd.intValue==0)?YES:NO;
					self.loaded = YES;
					[self saveCache];
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
