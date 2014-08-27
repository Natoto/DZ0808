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
// date:   2014-07-31 07:42:17 +0000
//
#import "rmbdz.h"
#import "postmine.h"
#import "UserModel.h"
#pragma mark - postmine

@implementation postmine

@synthesize dateline = _dateline;
@synthesize subject = _subject;
@synthesize tid = _tid;
@synthesize fid = _fid;
@synthesize replies = _replies;
@synthesize img = _img;
- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - postmine

@implementation POSTMINE

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize postmine = _postmine;

CONVERT_PROPERTY_CLASS( postmine, postmine );

- (BOOL)validate
{
	return YES;
}
@end


@implementation REQ_POSTMINE_SHOTS
@synthesize page=_page,per_page=_per_page;

- (BOOL)validate
{
	return YES;
}
@end

@implementation API_POSTMINEL_SHOTS

@synthesize uid = _uid;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = nil;
        self.req =[[REQ_POSTMINE_SHOTS alloc] init];
	}
	return self;
}

- (void)dealloc
{
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
        if (NULL == self.uid) {
            return;
        }
        
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=postmine%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).PARAM(@"uid",self.uid);
	
    }    
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [POSTMINE objectFromDictionary:(NSDictionary *)result];
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


