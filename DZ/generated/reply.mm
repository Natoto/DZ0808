//
//  reply.m
//  DZ
//
//  Created by Nonato on 14-5-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "rmbdz.h"
#import "reply.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+base64.h"

@implementation REPLY
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}
@end

@implementation replyContent
@synthesize msg = _msg;
@synthesize type = _type;
@synthesize aid=_aid;
- (BOOL)validate
{
	return YES;
}
@end


@implementation REQ_REPLAY_SHOTS
@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}
@end

@implementation API_REPLAY_SHOTS
@synthesize tid=_tid;
@synthesize fid=_fid;
@synthesize authorid=_authorid;
@synthesize req;
@synthesize resp;
@synthesize reqcontentAry;
- (BOOL)validate
{
	return YES;
}


-(NSString *)base64OfContentAry:(NSArray *)contarray
{
    NSString *contentary2str=[NSString stringWithFormat:@"["];
    for(int i=0;i<contarray.count;i++)
    {
        replyContent *atopic=[contarray objectAtIndex:i];
        if (i==contarray.count-1) {
            contentary2str=[contentary2str stringByAppendingString:[NSString stringWithFormat:@"{\"msg\":\"%@\",\"type\":\"%@\",\"aid\":\"%@\"}",atopic.msg,atopic.type,atopic.aid]];
        }
        else
        {
            contentary2str=[contentary2str stringByAppendingString:[NSString stringWithFormat:@"{\"msg\":\"%@\",\"type\":\"%@\",\"aid\":\"%@\"},",atopic.msg,atopic.type,atopic.aid]];
            
        }
    }
    contentary2str=[contentary2str stringByAppendingString:[NSString stringWithFormat:@"]"]];
    contentary2str=[contentary2str stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, contentary2str.length)];
    NSString *base64str=[NSData base64encode:contentary2str];
    
    return base64str;
}
- (id)init
{
	self = [super init];
	if ( self )
	{
        self.req = [[REQ_REPLAY_SHOTS alloc] init] ;
		self.reqcontentAry = [[NSMutableArray alloc] init] ;
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.reqcontentAry = nil;
	self.resp = nil;
    //	[super dealloc];
}
- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.fid ||  NULL == self.tid ||  NULL == self.authorid)
		{
			self.failed = YES;
			return;
		}
        if ([self.tid isEqual:self.pid]) {
            self.pid = nil;
        }
        
        NSString *contentbase64=[self base64OfContentAry:self.reqcontentAry];
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=reply%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        requestURI= [requestURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).HEADER(@"ContentType", @"application/x-www-form-urlencoded; charset=utf-8").PARAM(@"content",contentbase64).PARAM(@"fid",self.fid).PARAM(@"authorid",self.authorid).PARAM(@"tid",self.tid).PARAM(@"pid",self.pid);
        
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [REPLY  objectFromDictionary:(NSDictionary *)result];
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