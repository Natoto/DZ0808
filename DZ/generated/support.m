//
//  support.m
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//

#import "support.h"
#import "rmbdz.h"
@implementation SUPPORT

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}
@end

@implementation API_SUPPORT_SHOTS

@synthesize uid = _uid;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = [[SUPPORT alloc] init] ;
        
	}
	return self;
}

- (void)dealloc
{
	self.resp = nil;
}

- (void)routine
{
	if ( self.sending )
	{
		if ( NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
		if ( NULL == self.uid )
		{
			self.failed = YES;
			return;
		}
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=support%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid).PARAM(@"tid",self.tid).PARAM(@"pid",self.pid).PARAM(@"type",self.type);
        
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [SUPPORT objectFromDictionary:(NSDictionary *)result];
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