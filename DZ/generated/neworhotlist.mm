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
// date:   2014-04-28 01:19:30 +0000
//

#import "neworhotlist.h"
#import "rmbdz.h"
#pragma mark - NEWORHOTLIST

@implementation NEWORHOTLIST

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize topics = _topics;
@synthesize totalPage = _totalPage;

CONVERT_PROPERTY_CLASS( topics, neworlisttopics );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - topics

@implementation neworlisttopics

@synthesize authorid = _authorid;
@synthesize authorname = _authorname;
@synthesize digest = _digest;
@synthesize fid = _fid;
@synthesize heats = _heats;
@synthesize img = _img;
@synthesize lastpost = _lastpost;
@synthesize message = _message;
@synthesize recommends = _recommends;
@synthesize replies = _replies;
@synthesize stickreply = _stickreply;
@synthesize subject = _subject;
@synthesize tid = _tid;
@synthesize views = _views;

- (BOOL)validate
{
	return YES;
}

@end



#pragma mark - REQ_FORUMLIST_SHOTS

@implementation REQ_NEWORHOT_SHOTS
@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end



@implementation API_NEWORHOT_SHOTS
@synthesize type=_type;
@synthesize fid = _fid;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_NEWORHOT_SHOTS alloc] init] ;
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
    //	[super dealloc];
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
        
		if ( NULL == self.type)
		{
			self.failed = YES;
			return;
		}
        
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=neworhotlist%@&type=%@&fid=%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix,self.type,self.fid];
        
        self.HTTP_POST(requestURI).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [NEWORHOTLIST objectFromDictionary:(NSDictionary *)result];
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
