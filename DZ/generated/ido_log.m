//
//  ido_log.m
//  DZ
//
//  Created by Nonato on 14-7-28.
//
//

#import "ido_log.h"
#import "rmbdz.h"
@implementation IDO_LOG

@end



@implementation API_IDO_LOG_SHOTS


- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = [[IDO_LOG alloc] init] ;
        
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
		if ( NULL == self.ostype || NULL == self.appid || NULL == self.appviersion || self.device ==NULL )
		{
			self.failed = YES;
			return;
		}
		NSString * requestURI =[NSString stringWithFormat:@"%@?", [ServerConfig sharedInstance].idowebsiteurl];
        self.HTTP_POST(requestURI).PARAM(@"ostype",self.ostype).PARAM(@"appid",self.appid).PARAM(@"appviersion",self.appviersion).PARAM(@"device",self.device).PARAM(@"imei",self.imei).PARAM(@"mei",self.mei).PARAM(@"ccid",self.ccid);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [IDO_LOG objectFromDictionary:(NSDictionary *)result];
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