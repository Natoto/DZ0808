//
//  LoginModel.m
//  DZ
//
//  Created by Nonato on 14-4-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "rmbdz.h"
#import "UserModel.h"
#define DEFAULTNAME @"lastTimeLoggedUser"
@implementation UserModel
DEF_SINGLETON(UserModel)

DEF_SIGNAL(LOGIN_RELOADED)
DEF_SIGNAL(LOGIN_FAILED)
DEF_SIGNAL(LOGIN_LOADING)

DEF_SIGNAL(LOGOUT_RELOADED)
DEF_SIGNAL(LOGOUT_FAILED)
DEF_SIGNAL(LOGOUT_LOADING)

DEF_SIGNAL(REGIST_RELOADED)
DEF_SIGNAL(REGIST_FAILED)
DEF_SIGNAL(REGIST_LOADING)

DEF_SIGNAL(PROFILE_RELOADED)
DEF_SIGNAL(PROFILE_FAILED)
DEF_SIGNAL(PROFILE_LOADING)

@synthesize firstUse=_firstUse;
@synthesize login=_login;
@synthesize regist=_regist;
@synthesize username=_username;
@synthesize password=_password;

- (void)load
{
    self.firstUse = NO;
    self.session=[[SESSION2 alloc] init];
//    self.session
    SESSION2 *defaultSession =[SESSION2 readObjectForKey:DEFAULTNAME];
    self.username=defaultSession.username;
    self.password=defaultSession.password;
	[self loadCache];
}
-(SESSION2 *)defaultSession
{
    SESSION2 *defaultSessions =[SESSION2 readObjectForKey:DEFAULTNAME];
    return defaultSessions;
}

- (void)unload
{
	[self saveCache];
    self.login=nil;
    self.session=nil;
    self.messageCount=nil;
    [self removeAllObservers];
}

#pragma mark -

- (void)loadCache
{
//	self.login=nil;
//    if (self.login) {
//        [self setOnline:YES];
//    }
}

- (void)saveCache
{
//	[LOGIN userDefaultsWrite:[self.login objectToString] forKey:@"UserModel.login"];
}

- (void)clearCache
{
    [SESSION2 removeObjectForKey:DEFAULTNAME]; 
//	[LOGIN removeFromUserDefaults:@"UserModel.login"];
//    self.login =nil;
//	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
    [self signinWithUser:self.username password:self.password];
    
}
-(void)saveSecret:(BOOL)save
{
    if (save) {
        [SESSION2 saveObject:self.session forKey:self.username];
        [SESSION2 saveObject:self.session forKey:DEFAULTNAME];
    }
    else
    {
        [SESSION2 removeObjectForKey:DEFAULTNAME];
        [SESSION2 removeObjectForKey:self.username];
    }
}
-(SESSION2 *)readsession:(NSString *)key
{
    if (0 == key.length) {
        SESSION2 *session= [SESSION2 readObjectForKey:DEFAULTNAME];
        return session;
    }
    else
    {
        SESSION2 *session= [SESSION2 readObjectForKey:key];
        return session;
    }
}

-(NSString *)readsessionForKey:(NSString *)key
{
    if (0 == key.length) {
//        SESSION2 *session= [SESSION2 readObjectForKey:DEFAULTNAME];
        return @""; //session.password;
    }
    else
    {
        SESSION2 *session= [SESSION2 readObjectForKey:key];
        return session.password;
    }

}

- (void)setOffline:(BOOL)notify
{
//	[LOGIN removeFromUserDefaults:@"UserModel.login"];
//	[SESSION removeFromUserDefaults:@"UserModel.session"];
//	self.login = nil;
//	if ( notify )
//	{
//		[self postNotification:self.LOGOUT];
//	}
}

+ (BOOL)online
{
	if ([UserModel sharedInstance].session.uid)
		return YES;
	return NO;
} 

#pragma mark 登录
- (void)signinWithUser:(NSString *)username
			  password:(NSString *)password
{
    if (!username || !password) {
        return;
    }    
    [API_LOGIN_SHOTS cancel];
	API_LOGIN_SHOTS * api = [API_LOGIN_SHOTS api];
	@weakify(api);
	@weakify(self);
    self.username=username;
    self.password=password;
    api.username=self.username;
	api.password = self.password;
	api.req.page = [NSNumber numberWithInt:1];
	api.req.per_page = @(PER_PAGE);
	
	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);        
		if ( api.sending )
		{
 			[self sendUISignal:self.LOGIN_LOADING];
		}
		else
		{
			if ( api.succeed )
			{
				if ( nil == api.resp)
				{
					api.failed = YES;
                    [self sendUISignal:self.LOGIN_FAILED withObject:[STATUS errmessage:ERR_LOGIN]];
				}
				else
				{
                    if (!api.resp.ecode.integerValue) {
                        self.login =api.resp;
                        SESSION2  *session=[[SESSION2 alloc] init];
                        session.username=self.username;
                        session.password=self.password;
                        session.uid=self.login.uid;
                        session.sid=@"";//TODO: 在此添加设备的唯一标识
                        self.session=session;
                        self.more = NO;
                        self.loaded = YES;
                        [SESSION2 saveObject:self.session forKey:self.session.username];
                        [self saveSecret:self.saveUser];
                        [self sendUISignal:self.LOGIN_RELOADED];
                    }
                    else
                    {
                        [self sendUISignal:self.LOGIN_FAILED withObject:api.resp.emsg];
                    }
				}
			}
            else
            {
                  [self sendUISignal:self.LOGIN_FAILED withObject:[STATUS errmessage:ERR_LOGIN]];
            }
		}
	};	
	[api send];
}

#pragma mark 注册~~
- (void)signupWithUser:(NSString *)username
			  password:(NSString *)password
				 email:(NSString *)email
{
    
    if (!username || !password || !email) {
        return;
    }
    [API_REGISTERUSER_SHOTS cancel];
	API_REGISTERUSER_SHOTS * api = [API_REGISTERUSER_SHOTS api];
	@weakify(api);
	@weakify(self);
    api.account=username;
	api.passwd = password;
    api.email=email;
    
	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);
		if ( api.sending )
		{
			[self sendUISignal:self.REGIST_LOADING];
		}
		else
		{
			if ( api.succeed )
			{
				if ( nil == api.resp || !(api.resp.ecode.integerValue == 0))
				{
                    self.regist =api.resp;
                    api.failed = YES;
                    [self sendUISignal:self.REGIST_FAILED withObject:api.resp.emsg];
				}
				else
				{
                    self.regist =api.resp;
					self.more = NO;
					self.loaded = YES;
                    [self sendUISignal:self.REGIST_RELOADED];
				}
			} 
		}
	};
	[api send];
    
}

- (void)signout:(NSString *)uid//退出登录
{
    [self kickout]; 
}


- (void)updateProfile
{
    if (!self.session.uid) {
        return;
    }
    [API_PROFILE_SHOTS cancel];
	API_PROFILE_SHOTS * api = [API_PROFILE_SHOTS api];
    
    api.uid=self.session.uid;
    BeeLog(@"----------self.uid = %@----------",self.session.uid);
	@weakify(api);
	@weakify(self);
//    [self cancelMessages];
	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);
		if ( api.sending )
		{
 			[self sendUISignal:self.PROFILE_LOADING];
		}
		else
		{
			if ( api.succeed )
			{
				if ( nil == api.resp)
				{
					api.failed = YES;
                    [self sendUISignal:self.PROFILE_FAILED];
				}
				else
				{
                    self.profile =api.resp;
					self.more = NO;
					self.loaded = YES;
                    [self saveProfileInfo];
                    [self sendUISignal:self.PROFILE_RELOADED];
				}
			}
            else
            {
                [self sendUISignal:self.PROFILE_FAILED];
            }
		}
	};
	[api send];
}



- (void)updateFriendProfile:(NSString *)frienduid
{
    if (!frienduid) {
        return;
    }
    [API_PROFILE_SHOTS cancel];
	API_PROFILE_SHOTS * api = [API_PROFILE_SHOTS api];
    api.uid = self.session.uid;
    api.fuid=frienduid;
	@weakify(api);
	@weakify(self);
    
	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);
		if ( api.sending )
		{
 			[self sendUISignal:self.PROFILE_LOADING];
		}
		else
		{
			if ( api.succeed )
			{
				if ( nil == api.resp)
				{
					api.failed = YES;
                    [self sendUISignal:self.PROFILE_FAILED];
				}
				else
				{
                    if (!api.resp.ecode.integerValue) {
                        self.friendProfile =api.resp;
                        self.more = NO;
                        self.loaded = YES;
                        [self sendUISignal:self.PROFILE_RELOADED];
                    }
                    else
                    {
                        [self sendUISignal:self.PROFILE_FAILED withObject:api.resp.emsg];
                    }
				}
			}
            else
            {
                [self sendUISignal:self.PROFILE_FAILED];
            }
		}
	};
	[api send];
}

-(void)saveProfileInfo
{
    self.session.avatar=self.profile.avatar;
    [PROFILE saveObject:self.profile forKey:self.session.username];
}

#pragma mark - 退出
- (void)kickout//提出
{
    [API_LOGOUT_SHOTS cancel];
	API_LOGOUT_SHOTS * api = [API_LOGOUT_SHOTS api];
	@weakify(api);
	@weakify(self);
    if (!self.session) {
        [self sendUISignal:self.LOGOUT_FAILED];
        return;
    }
	api.uid=self.session.uid;
	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);
		if ( api.sending )
		{
			[self sendUISignal:self.LOGOUT_LOADING];
		}
		else
		{
			if ( api.succeed )
			{
				if ( nil == api.resp)
				{
					api.failed = YES;
                    [self sendUISignal:self.LOGOUT_FAILED];
				}
				else
				{
                    self.username=nil;
                    self.password=nil;
                    self.session=nil;
                    self.more = NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.LOGOUT_RELOADED];
				}
			}
            else
            {
                [self sendUISignal:self.LOGOUT_FAILED];
            }
		}
	};
	[api send];
}


- (void)updateFields//
{
//	self.CANCEL_MSG( API.user_signupFields );
//	self.MSG( API.user_signupFields );
}

/*
ON_MESSAGE3(API, logout, msg)//登出
{
    if ( msg.succeed )
	{
        [self postNotification:self.LOGOUT];
        [self setOffline:YES];
	}
    else if (msg.failed)
    {
        BeeLog(@"failed------%@",msg.description);
    }
}

ON_MESSAGE3(API, regist, msg)
{
    if ( msg.succeed )
	{
		LOGIN * loginres = msg.GET_OUTPUT(@"registRes" );
		if ( 0 != loginres.status.ecode.integerValue )
		{
			msg.failed = YES;
			return;
		}
        self.regist =nil;
        self.regist=msg.GET_OUTPUT(@"registRes");
		self.loaded = YES;
		[self saveCache];
        [self postNotification:self.REGIST];
	}
    else if (msg.failed)
    {
        BeeLog(@"failed------%@",msg.description);
    }    
}

#pragma mark -

ON_MESSAGE3( API, login, msg )
{
	if ( msg.succeed )
	{
		LOGIN * loginres = msg.GET_OUTPUT(@"loginRes" );
		if ( 0 != loginres.status.ecode.integerValue )
		{
			msg.failed = YES;
			return;
		}
        self.login=nil;
        self.login=msg.GET_OUTPUT(@"loginRes");
        self.session=msg.GET_OUTPUT(@"session");
		self.loaded = YES;
		[self saveCache];
        [self setOnline:YES];
        
        [self postNotification:self.LOGIN];
       
	}
    else if (msg.failed)
    {
        BeeLog(@"failed------%@",msg.description);
    }
    
}*/

@end
