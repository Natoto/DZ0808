//
//  homeModel.m
//  DZ
//
//  Created by Nonato on 14-4-25.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "UserModel.h"
#import "homeModel.h"
#pragma mark -

#undef	PER_PAGE
#define PER_PAGE	(30)

#pragma mark -
@implementation homeModel
DEF_SINGLETON(homeModel)
@synthesize player_id = _player_id;
@synthesize shots = _shots;


- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
    self.player_id=@"0";
	self.shots = [[home alloc] init]; 
}

- (void)unload
{
	self.shots = nil;
	self.player_id = nil;
}

#pragma mark -

+(onoff *)readOnff
{
   onoff *of =[onoff readObjectForKey:KEY_ONOFF];
   return of;
}

- (void)loadCache
{
	self.shots =nil;
    self.shots=[home readObjectForKey:self.player_id];
    self.onoff = [onoff readObjectForKey:KEY_ONOFF];
}

- (void)saveCache
{
    [home saveObject:self.shots forKey:self.player_id];
    [onoff saveObject:self.onoff forKey:KEY_ONOFF];
    //    [NSArray userDefaultsWrite:[self.shots objectToString] forKey:@"ForumlistModel"];
}
- (void)clearCache
{
//    [HOME2TOPICSPOSITIONITEM removeObjectForKey:HOMEPOSITIONKEY];
    [home removeObjectForKey:self.player_id];
    [onoff removeObjectForKey:KEY_ONOFF];
	self.shots = nil;
    self.onoff = nil;
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
//	if ( self.shots.count )
//	{
//		[self gotoPage:(self.shots.count / PER_PAGE + 1)];
//	}
}
- (void)gotoPage:(NSUInteger)page
{
    [API_HOME_SHOTS cancel];
	API_HOME_SHOTS * api = [API_HOME_SHOTS api];
	@weakify(api);
	@weakify(self);
    
    api.fids=[self fidsstr];
    api.uid=[UserModel sharedInstance].session.uid;
	api.id = @"home2";
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
                    self.resp = api.resp;
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{
                    self.shots =api.resp.home;
                    self.onoff = api.resp.onoff;
					self.more = NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else if (api.cancelled)
            {
//                [self sendUISignal:self.CANCELLED];
                [self sendUISignal:self.FAILED withObject:@""];
                BeeLog(@"取消。。");
            }
            else if (api.failed)
            {
                [self sendUISignal:self.FAILED];
                BeeLog(@"失败。。");
            }
		}
	};
	[api send];
}

-(NSString *)fidsstr
{
    NSString *res=[[NSString alloc] init];
    NSArray * fidary=[self arrangedPositions];
    for (int i=0; i<fidary.count; i++) {
        HOME2TOPICSPOSITIONITEM *item=[fidary objectAtIndex:i];
        if (item.fid.integerValue < 0) {
            continue;
        }
        if (item) {
            if (i == 0)
               res=[res stringByAppendingFormat:@"%@",item.fid];
            else
               res=[res stringByAppendingFormat:@",%@",item.fid];
        }
    }
    return res;
}



-(NSMutableArray *)arrangedPositions
{
    if (!_arrangedPositions) {
        _arrangedPositions = [HOME2TOPICSPOSITIONITEM readObjectForKey:ARRAYPOSITIONKEY];
    }
    return _arrangedPositions;
}
/*
-(NSArray *)loadArrangedPosition
{
    NSArray *ARRAY=[HOME2TOPICSPOSITIONITEM readObjectForKey:ARRAYPOSITIONKEY];
    return ARRAY;
} 
*/
-(void)clearArrangedPosition
{
    [HOME2TOPICSPOSITIONITEM removeObjectForKey:ARRAYPOSITIONKEY];
}

- (void)saveArrangedPosition:(NSArray *)topicsAry
{
//    [HOME2TOPICSPOSITIONITEM removeObjectForKey:ARRAYPOSITIONKEY];
    _arrangedPositions = (NSMutableArray *)topicsAry;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HOME2TOPICSPOSITIONITEM saveObject:topicsAry forKey:ARRAYPOSITIONKEY];
    });
}

@end
