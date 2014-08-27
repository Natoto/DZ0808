//
//  registeruser.m
//  DZ
//
//  Created by Nonato on 14-5-13.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "registeruser.h"
#import "rmbdz.h"

@implementation REGISTERUSER

@synthesize uid=_uid,account=_account,ecode=_ecode,emsg=_emsg;
- (BOOL)validate
{
	return YES;
}
@end


@implementation API_REGISTERUSER_SHOTS
@synthesize email=_email,account=_account,passwd=_passwd,resp=_resp;

- (BOOL)validate
{
	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = nil;
        self.resp=[[REGISTERUSER alloc] init];
	}
	return self;
}

- (void)dealloc
{
    self.email=nil;
	self.resp = nil;
    self.account=nil;
    self.passwd=nil;
}
- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.email || NULL == self.resp || NULL == self.account || NULL == self.passwd)
		{
			self.failed = YES;
			return;
		}
        self.account=[NSData base64encode:self.account];
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=register%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"account",self.account).PARAM(@"email",self.email).PARAM(@"passwd",self.passwd);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [REGISTERUSER  objectFromDictionary:(NSDictionary *)result];
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