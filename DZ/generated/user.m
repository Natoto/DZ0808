//
//  user.m
//  DZ
//
//  Created by Nonato on 14-5-12.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "user.h"
#import "rmbdz.h"

@implementation LOGIN2
@synthesize ecode=_ecode;
@synthesize emsg=_emsg;
@synthesize account=_account;
@synthesize uid=_uid;

- (BOOL)validate
{
	return YES;
}

@end

@implementation SESSION2
@synthesize username=_username,password=_password,sid=_sid,uid=_uid,avatar=_avatar;

- (BOOL)validate
{
	return YES;
}
@end

@implementation REQ_LOGIN_SHOTS
@synthesize page=_page,per_page=_per_page;

- (BOOL)validate
{
	return YES;
}
@end

@implementation API_LOGIN_SHOTS 
@synthesize username=_username,password=_password,req=_req,resp=_resp;
- (BOOL)validate
{
	return YES;
}


- (id)init
{
	self = [super init];
	if ( self )
	{
        self.req = [[REQ_LOGIN_SHOTS alloc] init] ;
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
    self.password=nil;
    self.username=nil;
    self.req=nil;
	self.resp = nil;
}
- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.username ||  NULL == self.password)
		{
			self.failed = YES;
			return;
		}
        
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=login%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.username=[NSData base64encode:self.username];
//        self.password=[NSData base64encode:self.password];
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).PARAM(@"username",self.username).PARAM(@"password",self.password);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [LOGIN2  objectFromDictionary:(NSDictionary *)result];
		}
        
		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
        NSLog(@"self.description===%@",self.description);
		// TODO:
	}
	else if ( self.cancelled )
	{
        NSLog(@"self.description %@",self.description);
		// TODO:
	}
}


@end

