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
// date:   2014-06-03 08:49:06 +0000
//

#import "allpm.h"
#import "rmbdz.h"

#pragma mark - ALLPM

@implementation ALLPM

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize friendms = _friendms;
@synthesize nowdate = _nowdate;
@synthesize allpm_public = _allpm_public;
@synthesize strangerms = _strangerms;

/*一般连着用，是讲json里面的public 转换为现有的 allpm_public类*/
CONVERT_RENAME_CLASS(allpm_public,public)
CONVERT_PROPERTY_CLASS(public, allpm_public)

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - friendms

@implementation friendms

@synthesize authorid = _authorid;
@synthesize avatar = _avatar;
@synthesize dateline = _dateline;
@synthesize delstatus = _delstatus;
@synthesize message = _message;
@synthesize plid = _plid;
@synthesize pmid = _pmid;
@synthesize touid = _touid;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - public

@implementation allpm_public

@synthesize author = _author;
@synthesize dateline = _dateline;
@synthesize message = _message;
@synthesize touid = _touid;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - strangerms

@implementation strangerms

@synthesize author = _author;
@synthesize authorid = _authorid;
@synthesize avatar = _avatar;
@synthesize dateline = _dateline;
@synthesize delstatus = _delstatus;
@synthesize message = _message;
@synthesize plid = _plid;
@synthesize pmid = _pmid;
@synthesize touid = _touid;

- (BOOL)validate
{
	return YES;
}

@end


@implementation API_ALLPM_SHOTS

@synthesize uid = _uid;
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
    //	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		 
		if ( NULL == self.uid || NULL==self.date || NULL == self.style)
		{
			self.failed = YES;
			return;
		}        
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=allpm%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid).PARAM(@"date",self.date).PARAM(@"style",self.style);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [ALLPM objectFromDictionary:(NSDictionary *)result];
            self.resp.strangerms =[self analysisstrangersms:self.resp.strangerms];
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


-(NSMutableArray *)analysisstrangersms:(NSArray *)selfstrangersms
{
    NSMutableArray *myfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSArray *array in selfstrangersms) {
        NSMutableArray *subfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
        for ( NSDictionary *afriend in array) {
            strangerms *friendmscls=[strangerms objectFromDictionary:afriend];
            [subfriendsms addObject:friendmscls];
        }
        if (subfriendsms.count) {
            [myfriendsms addObject:subfriendsms];
        }
    }
    return myfriendsms;
}


@end

