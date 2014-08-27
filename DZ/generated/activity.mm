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
// date:   2014-08-01 02:19:42 +0000
//

#import "activity.h"

#pragma mark - activity

@implementation activity

@synthesize author = _author;
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

#pragma mark - activity

@implementation ACTIVITY

@synthesize activity = _activity;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize totalPage = _totalPage;

CONVERT_PROPERTY_CLASS( activity, activity );

- (BOOL)validate
{
	return YES;
}

@end

