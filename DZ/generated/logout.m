//
//  signout.m
//  DZ
//
//  Created by Nonato on 14-5-13.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "logout.h"
#import "rmbdz.h"
@implementation LOGOUT
@synthesize ecode=_ecode,emsg=_emsg;
- (BOOL)validate
{
	return YES;
}
@end


@implementation API_LOGOUT_SHOTS
@synthesize uid=_uid,resp=_resp;

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
	}
	return self;
}

- (void)dealloc
{
    self.uid=nil;
	self.resp = nil;
}
- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.uid)
		{
			self.failed = YES;
			return;
		}
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=logout%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];        
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [LOGOUT  objectFromDictionary:(NSDictionary *)result];
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