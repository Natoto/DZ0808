//    												
//    												
//    	 ______    ______    ______					
//    	/\  __ \  /\  ___\  /\  ___\			
//    	\ \  __<  \ \  __\_ \ \  __\_		
//    	 \ \_____\ \ \_____\ \ \_____\		
//    	  \/_____/  \/_____/  \/_____/			
//    												
//    												
//    												
// title:  
// author: unknown
// date:   2014-05-14 01:28:50 +0000
//

#import "friends.h"
#import "rmbdz.h"
#pragma mark - FRIENDS

@implementation FRIENDS

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize friends = _friends;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize totalPage = _totalPage;

CONVERT_PROPERTY_CLASS( friends, friends );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - friends

@implementation friends

@synthesize avatar = _avatar;
@synthesize fuid = _fuid;
@synthesize username = _username;

- (BOOL)validate
{
	return YES;
}

@end


@implementation REQ_FRIENDS_SHOTS
@synthesize page=_page,per_page=_per_page;

- (BOOL)validate
{
	return YES;
}
@end



@implementation API_FRIENDS_SHOTS

@synthesize uid = _uid;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_FRIENDS_SHOTS alloc] init] ;
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}        
		if ( NULL == self.uid )
		{
			self.failed = YES;
			return;
		}
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=friends%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).PARAM(@"uid",self.uid);;
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [FRIENDS objectFromDictionary:(NSDictionary *)result];
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


