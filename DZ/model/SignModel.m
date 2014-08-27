//
//  SignModel.m
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//
#import "Bee.h"
#import "SignModel.h"
#import "UserModel.h"
@implementation SIGNRECORD
@end;

@implementation SignModel
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
+(BOOL)canSignCheckin
{
    NSString *uid=[UserModel sharedInstance].session.uid;
    SIGNRECORD *record = [SIGNRECORD readObjectForKey:uid];
    if ([record.signDay isEqualToString:[SignModel todayDate]]) {
        return NO;
    }
    return YES;
}
#pragma mark -
- (void)loadCache
{
    
}
+(NSString *)todayDate
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"%@",currentDateStr);
    return currentDateStr;
}

- (void)saveCache
{
    SIGNRECORD *record = [[SIGNRECORD alloc] init];
    record.todaysay = self.todaysay;
    record.qdxq = self.qdxq;
    record.signDay =[SignModel todayDate];
    [SIGNRECORD saveObject:record forKey:self.uid];
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
    
    [API_SIGN_SHOTS cancel];
	API_SIGN_SHOTS * api = [API_SIGN_SHOTS api];
	@weakify(api);
	@weakify(self);
	
    self.uid = [UserModel sharedInstance].session.uid;
    if (!self.uid || !self.todaysay || !self.qdxq) {
        BeeLog(@" 签到参数不完整。。。");
        return;
    }
    api.uid = self.uid;
    api.qdxq = self.qdxq;
    api.todaysay = self.todaysay;
    
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
