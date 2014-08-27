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
// date:   2014-04-23 06:32:15 +0000
//

#import "postlist.h"
#import "rmbdz.h"
#pragma mark - POSTLIST
#pragma mark - content
@implementation content_vote

- (BOOL)validate
{
	return YES;
}
@end;

@implementation content

@synthesize isremote = _isremote;
@synthesize msg = _msg;
@synthesize type = _type;
@synthesize originimg = _originimg;
@synthesize att_isarrow = _att_isarrow;
@synthesize att_filename = _att_filename;
@synthesize isimage = _isimage;
@synthesize att_description = _att_description;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - post

@implementation post

@synthesize authorid = _authorid;
@synthesize authorname = _authorname;
@synthesize content = _content;
@synthesize pid = _pid;
@synthesize position = _position;
@synthesize postsdate = _postsdate;
@synthesize status = _status;
@synthesize subtract = _subtract;
@synthesize support = _support;
@synthesize tid = _tid;
@synthesize title = _title;
@synthesize usericon = _usericon;

CONVERT_PROPERTY_CLASS( content, content );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - postlist

@implementation POSTLIST2

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize post = _post;
@synthesize topic = _topic;
@synthesize totalPage = _totalPage;
@synthesize weburl = _weburl;

CONVERT_PROPERTY_CLASS( post, post );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - topic

@implementation topic
@synthesize authorid = _authorid;
@synthesize authorname = _authorname;
@synthesize content = _content;
@synthesize digest = _digest;
@synthesize favid = _favid;
@synthesize fid = _fid;
@synthesize heats = _heats;
@synthesize isarrow = _isarrow;
@synthesize isfavorite = _isfavorite;
@synthesize lastpost = _lastpost;
@synthesize pid = _pid;
@synthesize position = _position;
@synthesize postsdate = _postsdate;
@synthesize recommends = _recommends;
@synthesize replies = _replies;
@synthesize stickreply = _stickreply;
@synthesize tid = _tid;
@synthesize title = _title;
@synthesize usericon = _usericon;
@synthesize views = _views;

CONVERT_PROPERTY_CLASS( content, content );

- (BOOL)validate
{
	return YES;
}
@end

#pragma mark - GET /postlist/:tid/shots

#pragma mark - REQ_POSTLIST_SHOTS

@implementation REQ_POSTLIST_SHOTS

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - API_POSTLIST_SHOTS



@implementation API_POSTLIST_SHOTS

@synthesize onlyauthorid=_onlyauthorid;
@synthesize tid = _tid;
@synthesize req = _req;
@synthesize posts = _posts;
@synthesize uid=_uid;
- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_POSTLIST_SHOTS alloc] init] ;
		self.posts = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.posts = nil;
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
		if ( NULL == self.tid )
		{
			self.failed = YES;
			return;
		}
       //
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=postlist&tid=%@%@", [ServerConfig sharedInstance].url,self.tid,[ServerConfig sharedInstance].urlpostfix];
//      ASIDoNotReadFromCacheCachePolicy
        [self setCached:NO];
        [self setUseCache:NO];
//         self.DELETE(requestURI).PARAM( [self.req objectToDictionary]).PARAM(@"onlyauthorid",_onlyauthorid).PARAM(@"uid",self.uid).TIMEOUT(300);
       self.POST(requestURI).PARAM([self.req objectToDictionary]).PARAM(@"onlyauthorid",_onlyauthorid).PARAM(@"uid",self.uid).TIMEOUT(300);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.posts = [POSTLIST2 objectFromDictionary:(NSDictionary *)result];
		}
        
		if ( nil == self.posts || NO == [self.posts validate] )
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


