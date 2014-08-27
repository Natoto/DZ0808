//
//  modifyPersonalInfo.m
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "modifyPersonalInfo.h"
#import "rmbdz.h"
@implementation MODIFYPROFILE
@synthesize ecode=_ecode,emsg=_emsg;

- (BOOL)validate
{
	return YES;
}

@end

@implementation REQ_MODIFYPROFILE_SHOTS
@synthesize uid=_uid,gender=_gender,residecity=_residecity,resideprovince=_resideprovince;
@synthesize birthday=_birthday,birthmonth=_birthmonth,birthyear=_birthyear;

- (BOOL)validate
{
	return YES;
}
-(id)init
{
    self=[super init];
    if (self) {
        _uid=nil;
        _gender=[NSNumber numberWithInt:0];
        _residecity=@"";
        _resideprovince=@"";
        _birthyear=[NSNumber numberWithInt:2014];
        _birthmonth=[NSNumber numberWithInt:2];
        _birthday=[NSNumber numberWithInt:21];
    }
    return self;
}
@end


@implementation API_MODIFYPROFILE_SHOTS
@synthesize req=_req,resp=_resp;
- (BOOL)validate
{
	return YES;
}

-(id)init
{
    self=[super init];
    if (self) {
        _req=[[REQ_MODIFYPROFILE_SHOTS alloc] init];
    }
    return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
}
-(void)routine
{
    if (self.sending) {
        if ( NULL == self.req.uid)
		{
			self.failed = YES;
			return;
		}
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=modprofile%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];

        self.req.resideprovince = [NSData base64encode:self.req.resideprovince];
        self.req.residecity = [NSData base64encode:self.req.residecity];
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).PARAM(@"uid",self.req.uid).PARAM(@"gender",self.req.gender).PARAM(@"resideprovince",self.req.resideprovince).PARAM(@"residecity",self.req.residecity).PARAM(@"birthmonth",self.req.birthmonth).PARAM(@"birthday",self.req.birthday).PARAM(@"birthyear",self.req.birthyear);
    }
    else if (self.succeed)
    {
        NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [MODIFYPROFILE  objectFromDictionary:(NSDictionary *)result];
		}
        
		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
        
    }
    else if (self.failed)
    {
        
    }
    else if (self.cancel)
    {
        
    }
}

@end