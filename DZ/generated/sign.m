//
//  sign.m
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//

#import "sign.h"
#import "rmbdz.h"
@implementation SIGN

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize reward = _reward;
- (BOOL)validate
{
	return YES;
}

@end

@implementation API_SIGN_SHOTS


@synthesize uid = _uid;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = [[SIGN alloc] init] ;
        
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
        self.todaysay =[NSData base64encode:self.todaysay];
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=sign%@&cache=sign", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid).PARAM(@"todaysay",self.todaysay).PARAM(@"qdxq",self.qdxq);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [SIGN objectFromDictionary:(NSDictionary *)result];
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