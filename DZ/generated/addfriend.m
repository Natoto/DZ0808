//
//  addfriend.m
//  DZ
//
//  Created by Nonato on 14-6-18.
//
//

#import "addfriend.h"
@implementation ADDFRIEND
@synthesize ecode=_ecode;
@synthesize emsg=_emsg;

- (BOOL)validate
{
	return YES;
}
@end

@implementation API_ADDFRIEND_SHOTS
@synthesize frdid=_frdid,uid=_uid,resp=_resp;
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
    self.frdid=nil;
	self.resp = nil;
}
- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.frdid ||  NULL == self.uid)
		{
			self.failed = YES;
			return;
		}
        
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=addfriend%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
     
        self.HTTP_POST(requestURI).PARAM(@"fuid",self.frdid).PARAM(@"uid",self.uid);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [ADDFRIEND  objectFromDictionary:(NSDictionary *)result];
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
