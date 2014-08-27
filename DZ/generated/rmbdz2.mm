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
// date:   2014-04-10 09:36:11 +0000
//

#import "rmbdz2.h"

#pragma mark - FORUMLIST

@implementation FORUMLIST

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize forums = _forums;

CONVERT_PROPERTY_CLASS( forums, forums );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - HOMEPAGE

@implementation HOMEPAGE

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize home = _home;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - LOGIN

@implementation LOGIN

@synthesize account = _account;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - LOGOUT

@implementation LOGOUT

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - POSTLIST

@implementation POSTLIST

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize post = _post;
@synthesize topic = _topic;
@synthesize totalPage = _totalPage;

CONVERT_PROPERTY_CLASS( post, post );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - REGISTER

@implementation REGISTER

@synthesize account = _account;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - SUBFORUMLIST

@implementation SUBFORUMLIST

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize forums = _forums;

CONVERT_PROPERTY_CLASS( forums, forums );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - TOPICLIST

@implementation TOPICLIST

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

#pragma mark - child

@implementation child

@synthesize fid = _fid;
@synthesize icon = _icon;
@synthesize lastpost = _lastpost;
@synthesize name = _name;
@synthesize onlineusers = _onlineusers;
@synthesize posts = _posts;
@synthesize threads = _threads;
@synthesize todayposts = _todayposts;
@synthesize type = _type;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - content

@implementation content

@synthesize isremote = _isremote;
@synthesize msg = _msg;
@synthesize type = _type;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - forums

@implementation forums

@synthesize child = _child;
@synthesize fid = _fid;
@synthesize icon = _icon;
@synthesize lastpost = _lastpost;
@synthesize name = _name;
@synthesize onlineusers = _onlineusers;
@synthesize posts = _posts;
@synthesize threads = _threads;
@synthesize todayposts = _todayposts;
@synthesize type = _type;
@synthesize children = _children;

CONVERT_PROPERTY_CLASS( child, child );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - home

@implementation home

@synthesize my = _my;
@synthesize newest = _newest;
@synthesize topics = _topics;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - my

@implementation my

@synthesize count = _count;
@synthesize message = _message;
@synthesize subject = _subject;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - newest

@implementation newest

@synthesize count = _count;
@synthesize subject = _subject;
@synthesize title = _title;

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
@synthesize tid = _tid;
@synthesize title = _title;
@synthesize usericon = _usericon;

CONVERT_PROPERTY_CLASS( content, content );

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
@synthesize heats = _heats;
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





#pragma mark - config

@implementation ServerConfig

DEF_SINGLETON( ServerConfig )

DEF_INT( CONFIG_DEVELOPMENT,	0 )
DEF_INT( CONFIG_TEST,			1 )
DEF_INT( CONFIG_PRODUCTION,	2 )

@synthesize config = _config;
@dynamic url;
@dynamic testUrl;
@dynamic productionUrl;
@dynamic developmentUrl;

- (NSString *)url
{
	NSString * host = nil;
    
	if ( self.CONFIG_DEVELOPMENT == self.config )
	{
		host = self.developmentUrl;
	}
	else if ( self.CONFIG_TEST == self.config )
	{
		host = self.testUrl;
	}
	else
	{
		host = self.productionUrl;
	}
    
	if ( NO == [host hasPrefix:@"http://"] && NO == [host hasPrefix:@"https://"] )
	{
		host = [@"http://" stringByAppendingString:host];
	}
    
	return host;
}

- (NSString *)developmentUrl
{
	return @"api.dribbble.com";
}

- (NSString *)testUrl
{
	return @"api.dribbble.com";
}

- (NSString *)productionUrl
{
	return @"api.dribbble.com";
}
@end
