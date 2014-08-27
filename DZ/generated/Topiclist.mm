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
// date:   2014-04-22 05:36:13 +0000
//

#import "Topiclist.h"
#import "rmbdz.h"
#pragma mark - TOPICLIST

@implementation TOPICLIST2

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize topics = _topics;
@synthesize totalPage = _totalPage;

CONVERT_PROPERTY_CLASS( topics, topics );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - topics

@implementation topics

@synthesize authorid = _authorid;
@synthesize authorname = _authorname;
@synthesize digest = _digest;
@synthesize fid = _fid;
@synthesize heats = _heats;
@synthesize icon = _icon;
@synthesize img = _img;
@synthesize lastpost = _lastpost;
@synthesize message=_message;
@synthesize readperm=_readperm;
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

#pragma mark - GET /players/:id/shots

#pragma mark - REQ_FORUMLIST_SHOTS

@implementation REQ_TOPICLIST_SHOTS

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_PLAYERS_ID_SHOTS

@implementation RESP_TOPICLIST_SHOTS

@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize shots = _shots;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( shots, SHOT );

- (BOOL)validate
{
	return YES;
}
@end


@implementation API_TOPICLIST_SHOTS 
@synthesize fid = _fid;
@synthesize req = _req;
@synthesize respthe = _respthe;
@synthesize type=_type;
@synthesize topics=_topics;
- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_TOPICLIST_SHOTS alloc] init] ;
		self.respthe = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.respthe = nil;
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
        
		if ( NULL == self.fid )
		{
			self.failed = YES;
			return;
		}
        
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=topiclist&fid=%@&page=%d&pageSize=%d&cache=forumdisplay%@", [ServerConfig sharedInstance].url,self.fid,self.req.page.intValue,self.req.per_page.intValue,[ServerConfig sharedInstance].urlpostfix];
        if (_type.length>=1) {
            requestURI =[NSString stringWithFormat:@"%@?action=topiclist&fid=%@&type=%@&page=%d&pageSize=%d&cache=forumdisplay%@", [ServerConfig sharedInstance].url,self.fid,self.type,self.req.page.intValue,self.req.per_page.intValue,[ServerConfig sharedInstance].urlpostfix];
        }
        [self setCached:NO];
        [self setUseCache:NO];
        self.HTTP_POST(requestURI).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.topics = [TOPICLIST2 objectFromDictionary:(NSDictionary *)result];
		}
        
		if ( nil == self.topics || NO == [self.topics validate] )
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


