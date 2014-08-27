//
//  IDO_LogModel.m
//  DZ
//
//  Created by Nonato on 14-7-28.
//
//

#import "DZ_UIDevice_IOKit_Extensions.h"
#import "DZ_SystemSetting.h"
#import "IDO_LogModel.h"
#define IOSTYPE @"2"
@implementation IDO_LogModel
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

-(NSString *)ostype
{
    return IOSTYPE;
}

-(NSString *)appid
{
    return [DZ_SystemSetting sharedInstance].appid;
}

-(NSString *)appversion
{
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
    return [DZ_SystemSetting sharedInstance].appversion;
}
-(NSString *)imei
{
    return [UIDevice currentDevice].imei;
}

-(NSString *)mei
{
    return [UIDevice currentDevice].mei;
}

-(NSString *)ccid
{
    return nil; //[UIDevice currentDevice].ccid;
}

-(NSString *)device
{
    return [OpenUDID value];
}


- (void)nextPage
{
    [self firstPage];
}

- (void)gotoPage:(NSUInteger)page
{
    
    [API_IDO_LOG_SHOTS cancel];
	API_IDO_LOG_SHOTS * api = [API_IDO_LOG_SHOTS api];
	@weakify(api);
	@weakify(self);
	
    
    if (!self.ostype || !self.appid || !self.appversion) {
        BeeLog(@" 统计的参数不完整。。。");
        return;
    }
    
    
    api.ostype = self.ostype;
    api.appid = self.appid;
    api.appviersion = self.appversion;
    api.imei = self.imei;
    api.mei = self.mei;
    api.ccid = self.ccid;
    api.device = self.device;
    
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
                    self.shots = api.resp;
					self.more = YES; //(api.resp.i.intValue==0)?YES:NO;
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
