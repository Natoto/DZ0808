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
// date:   2014-04-21 12:40:10 +0000
//

#import "forumlist.h"
#import "rmbdz.h"
#pragma mark - FORUMLIST

@implementation FORUMLIST2

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize forums = _forums;

CONVERT_PROPERTY_CLASS( forums, forums );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - child

@implementation child

@synthesize child = _child;
@synthesize fid = _fid;
@synthesize icon = _icon;
@synthesize isset_threadtypes = _isset_threadtypes;
@synthesize lastpost = _lastpost;
@synthesize name = _name;
@synthesize onlineusers = _onlineusers;
@synthesize posts = _posts;
@synthesize threads = _threads;
@synthesize threadtypes = _threadtypes;
@synthesize todayposts = _todayposts;
@synthesize type = _type;

- (BOOL)validate
{
	return YES;
}

@end

@implementation selectPlatesChild
@synthesize mark=_mark;

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

CONVERT_PROPERTY_CLASS( child, child );

- (BOOL)validate
{
	return YES;
}

@end

//#pragma mark - threadtypes
//
//@implementation threadtypes
//
//@synthesize one = _one;
//@synthesize two = _two;
//@synthesize three = _three;
//@synthesize four = _four;
//@synthesize five = _five;
////重命名之后才能解析 1 2 3 4 是json那边传过来的
//CONVERT_RENAME_CLASS(one,1);
//CONVERT_RENAME_CLASS(two,2);
//CONVERT_RENAME_CLASS(three,3);
//CONVERT_RENAME_CLASS(four,4);
//CONVERT_RENAME_CLASS(five,5);
//
//- (BOOL)validate
//{
//	return YES;
//}
//
//@end

#pragma mark - REQ_FORUMLIST_SHOTS

@implementation REQ_FORUMLIST_SHOTS

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_PLAYERS_ID_SHOTS

@implementation RESP_FORUMLIST_SHOTS

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


@implementation API_FORUMLIST_SHOTS

@synthesize uid = _uid;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_FORUMLIST_SHOTS alloc] init] ;
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
		 
        
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=forumlist%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM( [self.req objectToDictionary] ).PARAM(@"uid",self.uid);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [FORUMLIST2 objectFromDictionary:(NSDictionary *)result];
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


@implementation API_SUBFORUMLIST_SHOTS

@synthesize fid = _fid;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_FORUMLIST_SHOTS alloc] init] ;
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
        
		if ( NULL == self.fid )
		{
			self.failed = YES;
			return;
		}
        
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=subforumlist%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        
       	requestURI =[requestURI stringByAppendingString:[NSString stringWithFormat:@"&fid=%@",self.fid]]; //[requestURI stringByReplacingOccurrencesOfString:@":fid=" withString:self.id];
        
        self.HTTP_POST(requestURI).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [FORUMLIST2 objectFromDictionary:(NSDictionary *)result];
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
