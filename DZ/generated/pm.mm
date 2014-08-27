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
// date:   2014-06-09 05:31:08 +0000
//

#import "pm.h"
#import "rmbdz.h"
#pragma mark - PM

@implementation PM

@synthesize grouppms = _grouppms;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize strangerms = _strangerms;

CONVERT_PROPERTY_CLASS( grouppms, grouppms );
CONVERT_RENAME_CLASS(grouppms, pm_grouppms);
CONVERT_RENAME_CLASS(strangerms, pm_strangerms);

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - grouppms

@implementation pm_grouppms

@synthesize message = _message;
@synthesize touid = _touid;
@synthesize author = _author;
@synthesize dateline = _dateline;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - strangerms

@implementation pm_strangerms

@synthesize author = _author;
@synthesize authorid = _authorid;
@synthesize dateline = _dateline;
@synthesize message = _message;
@synthesize touid = _touid;

- (BOOL)validate
{
	return YES;
}
@end


@implementation API_PM_SHOTS

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = nil;
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
        
		if ( NULL == self.uid || NULL == self.filter)
		{
			self.failed = YES;
			return;
		}
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=pm%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid).PARAM(@"filter",self.filter);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [PM objectFromDictionary:(NSDictionary *)result];
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
