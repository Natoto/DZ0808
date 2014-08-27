//
//  feedback.m
//  DZ
//
//  Created by PFei_He on 14-6-23.
//
//

#import "feedback.h"
#import "rmbdz.h"

@implementation feedback

@synthesize ecode = _ecode;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_FEEDBACK_SHOTS

@synthesize appId       = _appId;
@synthesize appVersion  = _appVersion;
@synthesize content     = _content;
@synthesize QQ          = _QQ;
@synthesize resp        = _resp;

- (BOOL)validate
{
    return YES;
}

- (void)routine
{
    if (self.sending) {
        
        if (NULL == self.content) {
            self.failed = YES;
            return;
        }
        NSString *requestURI = [NSString stringWithFormat:@"%@", [ServerConfig sharedInstance].feedbackUrl];
        self.HTTP_POST(requestURI).PARAM(@"content", self.content).PARAM(@"appid", self.appId).PARAM(@"appversion", self.appVersion).PARAM(@"qq", self.QQ ? self.QQ : @"");
 
    }
    else if (self.succeed)
    {
        NSObject *result = self.responseJSON;
        NSLog(@"反馈结果是：%@", result);
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            self.resp = [feedback objectFromDictionary:(NSDictionary *)result];
        }
        if (nil == self.resp || NO == [self.resp validate]) {
            self.failed = YES;
            return;
        }
    }
    else if (self.failed) {
        NSLog(@"self.descripting===%@", self.description);
    }
    else if (self.cancelled)
    {
        NSLog(@"self.descripting===%@", self.description);
    }
}

@end
