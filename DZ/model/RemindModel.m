//
//  RemindModel.m
//  DZ
//
//  Created by Nonato on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "RemindModel.h"
#import "UserModel.h"
#import "rmbdz.h"
@implementation RemindModel
@synthesize uid=_uid,shots=_shots;
- (void)load
{
    FRIENDSMESSAGE = 0;
    SYSTEMMESSAGE = 0;
	self.autoSave = NO;
	self.autoLoad = NO;
    _friendsautomatic = [[NSMutableArray alloc] init];
    _sysautomatic = [[NSMutableArray alloc] init];
}

- (void)unload
{
    _uid = nil;
    _shots = nil;
    _dialog = nil;
    _friendsautomatic = nil;
    _sysautomatic = nil;
//    _automatic=nil;
}

+(int)newmessagecount
{
    return FRIENDSMESSAGE + INNERMESSAGE + SYSTEMMESSAGE;
}

+(int)friendmessagecount
{
    return FRIENDSMESSAGE;
}

+(int)innermessagecount
{
    return INNERMESSAGE;
}
+(int)systemmessagecount
{
    return SYSTEMMESSAGE;
}
#pragma mark -

-(void)loadCache
{
    self.uid = [UserModel sharedInstance].session.uid;
    if (!self.uid) {
      self.uid = [[UserModel sharedInstance] defaultSession].uid;
    }
    NSString * myclass= NSStringFromClass([self class]);
    NSString * myuid=self.uid;
    NSString * key=  MODELOBJECTKEY(myclass,myuid);
    
    self.dialog  =[NSMutableArray arrayWithArray:[dialog readObjectForKey:key]];
    NSString * syskey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_SYSTEM_REMAIND]);
    
    self.sysautomatic=[NSMutableArray arrayWithArray:[automatic readObjectForKey:syskey]];
    NSString * friendkey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_GOODFREIND]);
    self.friendsautomatic =[NSMutableArray arrayWithArray: [automatic readObjectForKey:friendkey]];
}
- (void)saveCache
{
    NSString * myclass= NSStringFromClass([self class]);
    NSString * myuid=self.uid;
    NSString * key=  MODELOBJECTKEY(myclass,myuid);
    
    [REMIND saveObject:self.shots forKey:key];
    [dialog saveObject:self.dialog forKey:key];
    
    if (self.sysautomatic.count) {
        NSString * syskey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_SYSTEM_REMAIND]);
        [automatic saveObject:self.sysautomatic forKey:syskey];
    }
    if (self.friendsautomatic.count) {
        NSString * friendkey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_GOODFREIND]);
        [automatic saveObject:self.friendsautomatic forKey:friendkey];
    }
    
}

- (void)clearCache:(MSG_TYPE_REMIND)msg_type
{
    if (msg_type == MSG_SYSTEM_REMAIND) {
        [self.sysautomatic removeAllObjects];
    }
    else if (msg_type == MSG_GOODFREIND)
    {
        [self.friendsautomatic removeAllObjects];
    }
    else if (msg_type == MSG_ZHANNEIXIN)
    {
        
    }
}

- (void)clearCache
{
    [self.shots removeAllObjects];
    [self.dialog removeAllObjects];
    [self.sysautomatic removeAllObjects];
    [self.friendsautomatic removeAllObjects];
     self.loaded=NO;
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
    if ( self.shots.count )
	{
		[self gotoPage:(self.shots.count / PER_PAGE + 1)];
	}
}

- (void)gotoPage:(NSUInteger)page
{
    
    [API_REMIND_SHOTS cancel];
	API_REMIND_SHOTS * api = [API_REMIND_SHOTS api];
	@weakify(api);
	@weakify(self);
    api.uid=[UserModel sharedInstance].session.uid;
	
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
                    [self sendUISignal:self.FAILED withObject:[STATUS errmessage:ERR_FRESHERROR]];
				}
				else
				{
                    if ( page <= 1 )
					{
                        [self.shots removeAllObjects];
                        [self.dialog removeAllObjects];
//                        [self.friendsautomatic removeAllObjects];
//                        [self.sysautomatic removeAllObjects];
						[self.shots addObjectsFromArray:api.resp.public2];
                        [self splitAutomotic:api.resp.automatic];
                        [self.dialog addObjectsFromArray:api.resp.dialog];
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.public2];
					}
					self.more = NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
                    [self sendUISignal:self.FAILED withObject:[STATUS errmessage:ERR_FRESHERROR]];
            }
		}
	}; 
	[api send];
}

-(void)splitAutomotic:(NSArray *)array
{
//    [self.friendsautomatic removeAllObjects];
//    [self.sysautomatic removeAllObjects];
    FRIENDSMESSAGE = 0;
    SYSTEMMESSAGE = 0;
    for ( automatic *obj in array) {
        if ([obj.interactivems isEqualToString:@"friend"]) {
            [self.friendsautomatic addObject:obj];
            FRIENDSMESSAGE ++;
            BeeLog(@"----%d 有好友消息",SYSTEMMESSAGE);
        }
        else if([obj.interactivems isEqualToString:@"system"])
        {
            [self.sysautomatic addObject:obj];
            SYSTEMMESSAGE ++;
            BeeLog(@"----%d 有系统消息",SYSTEMMESSAGE);
        }
    }
}
@end
