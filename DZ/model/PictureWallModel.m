//
//  PictureWallModel.m
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//
#define KEY_PICTUREWALL @"PICTUREWALL"
#import "PictureWallModel.h"
//#import "Constants.h"
@implementation PictureWallModel
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
    [self.shots removeAllObjects];
    NSString  *key= KEY_PICTUREWALL; //MYFRIENDOBJECTKEY(@"PICTUREWALL");
    self.shots=[NSMutableArray arrayWithArray:[pcms readObjectForKey:key]];
}

- (void)saveCache
{
    [pcms saveObject:self.shots forKey:KEY_PICTUREWALL];
}

- (void)clearCache
{
    [self.shots removeAllObjects];
    self.loaded=NO;
}

#pragma mark -

- (void)firstPage
{
    self.last_tid  = @"";
	[self gotoPage:1];
}

- (void)nextPage
{
    if ( self.shots.count )
	{
        if (self.shots.count) {
            pcms *apcms = [self.shots objectAtIndex:self.shots.count -1];
            self.last_tid = apcms.tid;
        }
		[self gotoPage:(self.shots.count / 10 + 1)];
	}
}

- (void)gotoPage:(NSUInteger)page
{
    
    [API_PICTUREWALL_SHOTS cancel];
	API_PICTUREWALL_SHOTS * api = [API_PICTUREWALL_SHOTS api];
	@weakify(api);
	@weakify(self);
	api.req.page = @(page);
	api.req.per_page = @(PER_PAGE);
	api.last_tid = self.last_tid;
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
                    if ( page <= 1 )
					{
						[self.shots removeAllObjects];
						[self.shots addObjectsFromArray:api.resp.pcms];
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.pcms];
					}
					self.more = YES; //(api.resp.i.intValue==0)?YES:NO;
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
