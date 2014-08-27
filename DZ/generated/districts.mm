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
// date:   2014-05-16 06:08:12 +0000
//

#import "districts.h"
#import "rmbdz.h"
#pragma mark - DISTRICTS

@implementation DISTRICTS

@synthesize districts = _districts;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

CONVERT_PROPERTY_CLASS( districts, districts );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - child

@implementation dis_child

@synthesize displayorder = _displayorder;
@synthesize id = _id;
@synthesize level = _level;
@synthesize name = _name;
@synthesize upid = _upid;
@synthesize usetype = _usetype;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - districts

@implementation districts

@synthesize child = _child;
@synthesize displayorder = _displayorder;
@synthesize id = _id;
@synthesize level = _level;
@synthesize name = _name;
@synthesize upid = _upid;
@synthesize usetype = _usetype;

CONVERT_PROPERTY_CLASS( child, dis_child );

- (BOOL)validate
{
	return YES;
}

@end



@implementation API_DISTRICTS_SHOTS

@synthesize resp = _resp;

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
}

- (void)routine
{
	if ( self.sending )
	{
        
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=districts%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [DISTRICTS objectFromDictionary:(NSDictionary *)result];
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

