//
//  delfriend.m
//  DZ
//
//  Created by Nonato on 14-6-18.
//
//
#import "rmbdz.h"
#import "delfriend.h"
@implementation DELFRIEND
@synthesize ecode=_ecode;
@synthesize emsg=_emsg;

- (BOOL)validate
{
	return YES;
}
@end

@implementation API_DELFRIEND_SHOTS
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
        
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=delfriend%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        
        self.HTTP_POST(requestURI).PARAM(@"fuid",self.frdid).PARAM(@"uid",self.uid);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
        if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [DELFRIEND  objectFromDictionary:(NSDictionary *)result];
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
