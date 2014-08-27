//
//  newTopic.m
//  DZ
//
//  Created by Nonato on 14-4-28.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "rmbdz.h"
#import "newTopic.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+base64.h"
@implementation NEWTOPPIC
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}
@end



#pragma mark -  

@implementation newtopicContent
@synthesize  msg = _msg;
@synthesize  type = _type;
@synthesize  aid=_aid;
-(id)init
{
    self=[super init];
    if (self) {
        _msg=@"";
        _type=[NSNumber numberWithInt:0];
         _aid=[NSNumber numberWithInt:0];
    }
    return self;
}
- (BOOL)validate
{
	return YES;
}

@end

@implementation REQ_NEWTOPPIC_SHOTS
@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end


@implementation API_NEWTOPPIC_SHOTS
@synthesize fid,typedid,subject,sortid,authorid,author,reqcontentAry,resp,uid;
@synthesize req;

-(NSString *)base64OfContentAry:(NSArray *)contarray
{
    NSString *contentary2str=[NSString stringWithFormat:@"["];
    for(int i=0;i<contarray.count;i++)
    {
        newtopicContent *atopic=[contarray objectAtIndex:i];
        if (i==contarray.count-1) {
//         NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);//解决中文编码的问题
//         NSString *atopicmsg =  [[NSString  alloc] initWithData:atopic.msg.data encoding:enc];
        contentary2str=[contentary2str stringByAppendingString:[NSString stringWithFormat:@"{\"msg\":\"%@\",\"type\":\"%@\",\"aid\":\"%@\"}",atopic.msg,atopic.type,atopic.aid]];
        }
        else
        {
//             NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);//解决中文编码的问题
//             NSString *atopicmsg =  [[NSString  alloc] initWithData:atopic.msg.data encoding:enc];
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
        self.req = [[REQ_NEWTOPPIC_SHOTS alloc] init] ;
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
		if ( NULL == self.fid ||  NULL == self.subject ||  NULL == self.authorid)
		{
			self.failed = YES;
			return;
		}
        NSString *title=[NSData base64encode:self.subject];        
        NSString *contentbase64=[self base64OfContentAry:self.reqcontentAry];
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=newtopic%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        requestURI= [requestURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).HEADER(@"ContentType", @"application/x-www-form-urlencoded; charset=utf-8").PARAM(@"content",contentbase64).PARAM(@"fid",self.fid).PARAM(@"subject",title).PARAM(@"authorid",self.authorid).PARAM(@"author",self.author).PARAM(@"uid",self.uid).PARAM(@"typeid",self.typedid);
        
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [NEWTOPPIC  objectFromDictionary:(NSDictionary *)result];
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
