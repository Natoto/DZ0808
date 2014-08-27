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
// date:   2014-05-13 11:02:01 +0000
//

#import "profile.h"
#import "rmbdz.h"
#pragma mark - ROFILE

@implementation PROFILE

@synthesize avatar = _avatar;
@synthesize credits = _credits;
@synthesize ecode = _ecode;
@synthesize email = _email;
@synthesize emsg = _emsg;
@synthesize favorites = _favorites;
@synthesize friends = _friends;
@synthesize group = _group;
@synthesize lastactivity = _lastactivity;
@synthesize lastpost = _lastpost;
@synthesize lastvisit = _lastvisit;
@synthesize money = _money;
@synthesize oltime = _oltime;
@synthesize posts = _posts;
@synthesize regdate = _regdate;
@synthesize replys=_replys;
@synthesize threads = _threads;
@synthesize username = _username;
@synthesize residecity = _residecity;
@synthesize resideprovince =_resideprovince;
@synthesize gender = _gender;
@synthesize birthday = _birthday;
@synthesize birthmonth = _birthmonth;
@synthesize birthyear = _birthyear;
@synthesize relationship = _relationship;
- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PROFILE_SHOTS
@synthesize uid=_uid,resp=_resp,fuid=_fuid;

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
        self.resp=[[PROFILE alloc] init];
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
//		if ( NULL == self.uid)
//		{
//			self.failed = YES;
//			return;
//		}
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=profile%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid).PARAM(@"fuid",self.fuid);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
            self.resp = [PROFILE  objectFromDictionary:(NSDictionary *)result];
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

