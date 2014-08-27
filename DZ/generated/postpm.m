//
//  postpm.m
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "postpm.h"
#import "rmbdz.h"
#import "NSData+base64.h"
@implementation POSTPM

- (BOOL)validate
{
	return YES;
}
@end


@implementation API_POSTPM_SHOTS
 

@synthesize uid = _uid;
@synthesize resp = _resp;

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
	self.resp = nil;
    //	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
        
		if ( NULL == self.uid || NULL==self.message || NULL == self.touid)
		{
			self.failed = YES;
			return;
		}
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=postpm%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        NSString *message=[NSData base64encode:self.message];
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid).PARAM(@"touid",self.touid).PARAM(@"message",message);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [POSTPM objectFromDictionary:(NSDictionary *)result];
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
