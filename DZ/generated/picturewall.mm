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
// date:   2014-07-23 12:00:57 +0000
//

#import "picturewall.h"
#import "rmbdz.h"
#pragma mark - pcms

@implementation pcms

@synthesize attachment = _attachment;
@synthesize height = _height;
@synthesize subject = _subject;
@synthesize tid = _tid;
@synthesize width = _width;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - picturewall

@implementation PICTUREWALL

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize pcms = _pcms;

CONVERT_PROPERTY_CLASS( pcms, pcms );

- (BOOL)validate
{
	return YES;
}

@end
@implementation REQ_PICTUREWALL_SHOTS
@synthesize page=_page,per_page = _per_page;
- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PICTUREWALL_SHOTS

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_PICTUREWALL_SHOTS alloc] init] ;
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
         
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=picturewall%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"last_tid",self.last_tid);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [PICTUREWALL objectFromDictionary:(NSDictionary *)result];
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
