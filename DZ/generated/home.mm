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
// date:   2014-04-25 02:20:35 +0000
//

#import "home.h"

@implementation  HOME2TOPICSPOSITIONITEM
@synthesize backgroundcolor=_backgroundcolor;
@synthesize icon=_icon;
@synthesize fid=_fid;
@synthesize title=_title;
@synthesize subject=_subject;
@synthesize count=_count;
@synthesize enableDelete=_enableDelete;


- (id)copyWithZone:(NSZone *)zone
{
	// Don't forget - this will return a retained copy!
	HOME2TOPICSPOSITIONITEM *item = [[[self class] alloc] init];
    [item setBackgroundcolor:[self backgroundcolor]];
    [item setIcon:[self icon]];
    [item setFid:[self fid]];
    [item setTitle:[self title]];
    [item setSubject:[self subject]];
    [item setCount:[self count]];
    [item setEnableDelete:[self enableDelete]];
    return item;
}
-(id)init
{
    self=[super init];
    if (self) {
        self.backgroundcolor=@"0x00acf5";
        self.title=@"";
        self.icon=@"";
        self.fid=@"";
        self.subject=@"";
        self.enableDelete=@"1";
        self.count=@"0";
    }
    return self;
}
@end


#pragma mark - HOME

@implementation HOME2

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize home = _home;
@synthesize onoff = _onoff;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - home

@implementation home

@synthesize hot = _hot;
@synthesize my = _my;
@synthesize command=_command;
@synthesize digest=_digest;
@synthesize newest = _newest;
@synthesize topics2 = _topics2;
@synthesize activity = _activity;

CONVERT_RENAME_CLASS(topics2, topics)
CONVERT_PROPERTY_CLASS(command, home_command);
CONVERT_RENAME_CLASS(home_command,command);//改名
- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - hot

@implementation hot

@synthesize img = _img;
@synthesize subject = _subject;
@synthesize title = _title;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - digest
@implementation digest

@synthesize img = _img;
@synthesize subject = _subject;
@synthesize title = _title;

- (BOOL)validate
{
	return YES;
}
@end

#pragma mark - home_activity
@implementation home_activity

@synthesize img = _img;
@synthesize subject = _subject;
@synthesize title = _title;

- (BOOL)validate
{
	return YES;
}
@end

#pragma mark - command
@implementation home_command

@synthesize img = _img;
@synthesize subject = _subject;
@synthesize title = _title;

- (BOOL)validate
{
	return YES;
}
@end


@implementation onoff
@synthesize iscommand = _iscommand;
@synthesize isregist = _isregist;
@synthesize isactivity = _isactivity;
-(BOOL)validate
{
    return YES;
}
@end
#pragma mark - my

@implementation my
@synthesize img=_img;
@synthesize title = _title;
@synthesize subject = _subject;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - newest

@implementation newest

@synthesize img = _img;
@synthesize subject = _subject;
@synthesize title = _title;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - topics

@implementation topics2

@synthesize count = _count;
@synthesize fid = _fid;
@synthesize subject = _subject;
@synthesize title = _title;
@synthesize img = _img;

- (BOOL)validate
{
	return YES;
}
@end



#pragma mark - REQ_HOME_SHOTS
@implementation REQ_HOME_SHOTS

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end



@implementation API_HOME_SHOTS
@synthesize fids=_fids;
@synthesize uid=_uid;
@synthesize id = _id;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_HOME_SHOTS alloc] init] ;
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
        
		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}
        
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=home%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"fid",self.fids).PARAM(@"uid",self.uid);   
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [HOME2 objectFromDictionary:(NSDictionary *)result];
            NSArray * topicsDicAry=[self.resp.home.topics2  copy];
            
            NSMutableArray *TopicArray=[[NSMutableArray alloc] initWithCapacity:0];
            for( int index=0 ;index < topicsDicAry.count ;index ++)
            {
                NSDictionary *dic = [topicsDicAry objectAtIndex:index];
                topics2 *atopic = [topics2 objectFromDictionary:dic];
                [TopicArray addObject:atopic];
            }
            self.resp.home.topics2= TopicArray;
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


