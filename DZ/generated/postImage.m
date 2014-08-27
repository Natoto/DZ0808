//
//  postImage.m
//  DZ
//
//  Created by Nonato on 14-5-6.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "postImage.h"
#import "rmbdz.h"
@implementation POSTIMAGE
@synthesize ecode=_ecode;
@synthesize emsg=_emsg;
@synthesize url=_url;
@synthesize aid=_aid;

- (BOOL)validate
{
	return YES;
}
@end

@implementation REQ_POSTIMAGE_SHOTS
@synthesize page=_page;
@synthesize per_page=_per_page;

- (BOOL)validate
{
	return YES;
}
@end

@implementation API_POSTIMAGE_SHOTS
@synthesize  fid=_fid;
@synthesize uid=_uid;
@synthesize req=_req;
@synthesize resp=_resp;
@synthesize filename=_filename;
@synthesize filedata=_filedata;
- (BOOL)validate
{
	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
        self.req = [[REQ_POSTIMAGE_SHOTS alloc] init] ;
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
    self.filedata=nil;
    self.filename=nil;
    self.fid=nil;
    self.uid=nil;
	self.resp = nil;
}
- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.fid ||  NULL == self.uid)
		{
			self.failed = YES;
			return;
		} 
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=postimage%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
//        requestURI=[requestURI stringByAppendingFormat:@"&fid=%@&uid=%@&%@=%@",self.fid,self.uid,self.filename,self.filedata];
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).HEADER(@"enctype", @"multipart/form-data; boundary=AaB03x").PARAM(@"uid",self.uid).PARAM(@"fid",self.fid).FILE(@"files",self.filedata)
        
        .TIMEOUT(180);
        
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [POSTIMAGE  objectFromDictionary:(NSDictionary *)result];
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