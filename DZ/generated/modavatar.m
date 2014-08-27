//
//  modavatar.m
//  DZ
//
//  Created by Nonato on 14-5-19.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "modavatar.h"
#import "rmbdz.h"
@implementation MODAVATAR
@synthesize ecode=_ecode;
@synthesize emsg=_emsg;
@synthesize avatarurl=_avatarurl;


- (BOOL)validate
{
	return YES;
}

@end



@implementation API_MODAVATAR_SHOTS
@synthesize uid=_uid;
@synthesize imageData=_imageData;
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
    self.uid=nil;
    self.imageData=nil;
	self.resp = nil;
}

- (void)routine
{
    if (NULL==self.uid || NULL==self.imageData) {
        return;
    }   
    
	if ( self.sending )
	{
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=modavatar%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).HEADER(@"enctype", @"multipart/form-data; boundary=AaB03x").PARAM(@"uid",self.uid).FILE(@"files",self.imageData);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [MODAVATAR objectFromDictionary:(NSDictionary *)result];
            BeeLog(@"%@",self.resp.emsg);
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