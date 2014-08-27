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
// date:   2014-06-03 08:52:47 +0000
//

#import "myreply.h"
#import "rmbdz.h"
#pragma mark - MYREPLY

@implementation MYREPLY

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize myreply = _myreply;
@synthesize page = _page;
@synthesize totalPage = _totalPage;

CONVERT_PROPERTY_CLASS( myreply, myreply );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - myreply

@implementation myreply

@synthesize author = _author;
@synthesize authorid = _authorid;
@synthesize avatar = _avatar;
@synthesize dateline = _dateline;
@synthesize fid = _fid;
@synthesize subject = _subject;
@synthesize tid = _tid;

- (BOOL)validate
{
	return YES;
}

@end



@implementation REQ_MYREPLY_SHOTS
@synthesize page=_page,per_page=_per_page;

- (BOOL)validate
{
	return YES;
}
@end



@implementation API_MYREPLY_SHOTS

@synthesize uid = _uid;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_MYREPLY_SHOTS alloc] init] ;
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
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=myreply%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).PARAM(@"uid",self.uid);;
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [MYREPLY objectFromDictionary:(NSDictionary *)result];
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




