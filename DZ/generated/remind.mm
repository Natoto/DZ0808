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
// date:   2014-06-03 08:44:56 +0000
//

#import "remind.h"
#import "rmbdz.h"
#pragma mark - REMIND

@implementation REMIND

@synthesize automatic = _automatic;
@synthesize dialog = _dialog;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize public2 = _public2;

CONVERT_PROPERTY_CLASS( automatic, automatic );
CONVERT_PROPERTY_CLASS( dialog, dialog );

CONVERT_RENAME_CLASS(public, public2);

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - automatic

@implementation automatic

@synthesize author = _author;
@synthesize authorid = _authorid;
@synthesize category = _category;
@synthesize dateline = _dateline;
@synthesize from_id = _from_id;
@synthesize from_idtype = _from_idtype;
@synthesize from_num = _from_num;
@synthesize id = _id;
@synthesize news = _news;
@synthesize note = _note;
@synthesize uid = _uid;
@synthesize interactivems = _interactivems;

CONVERT_RENAME_CLASS(news,new)

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - dialog

@implementation dialog

@synthesize isnew = _isnew;
@synthesize lastdateline = _lastdateline;
@synthesize lastupdate = _lastupdate;
@synthesize plid = _plid;
@synthesize pmnum = _pmnum;
@synthesize uid = _uid;

CONVERT_PROPERTY( isnew, isnew);
- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - public

@implementation public2

@synthesize dateline = _dateline;
@synthesize gpmid = _gpmid;
@synthesize status = _status;
@synthesize uid = _uid;

- (BOOL)validate
{
	return YES;
}

@end



@implementation API_REMIND_SHOTS

@synthesize uid = _uid;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = [[REMIND alloc] init] ;
 
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
		if ( NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
		if ( NULL == self.uid )
		{
			self.failed = YES;
			return;
		}
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=remind%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid);;
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [REMIND objectFromDictionary:(NSDictionary *)result];
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
