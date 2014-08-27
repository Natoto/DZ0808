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
// date:   2014-06-03 09:27:21 +0000
//

#import "COMMAND.h"
#import "rmbdz.h"
#pragma mark - COMMAND

@implementation COMMAND

@synthesize command = _command;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

CONVERT_PROPERTY_CLASS( topics, command );
CONVERT_RENAME_CLASS(command, topics);

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - command

@implementation command

@synthesize author = _author;
@synthesize authorid = _authorid;
@synthesize dateline = _dateline;
@synthesize img = _img;
@synthesize replies = _replies;
@synthesize subject = _subject;
@synthesize tid = _tid;
@synthesize views = _views;

- (BOOL)validate
{
	return YES;
}

@end


@implementation API_COMMAND_SHOTS

@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
    _resp=nil;
    //	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=command%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [COMMAND objectFromDictionary:(NSDictionary *)result];
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
