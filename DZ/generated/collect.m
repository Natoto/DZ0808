//
//  collect.m
//  DZ
//
//  Created by PFei_He on 14-6-24.
//
//

#import "collect.h"
#import "rmbdz.h"

@implementation COLLECT

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize favid = _favid;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_COLLECT_SHOTS

@synthesize uid = _uid;
@synthesize tid = _tid;

- (void)routine
{
    //发送请求
    if (self.sending)
    {
        if (NULL == self.uid)
        {
            self.failed = YES;
            return;
        }
//        NSData *encodingData = [self.uid dataUsingEncoding:NSUTF8StringEncoding];
//        self.uid = [encodingData base64EncodedStringWithOptions:0];
        NSString *requestURI = [NSString stringWithFormat:@"%@?action=addcollection%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid", self.uid).PARAM(@"tid", self.tid);
    }
    //请求成功
    else if (self.succeed)
    {
        //请求结果转JSON
        NSObject *result = self.responseJSON;
        NSLog(@"123收藏，收藏=================%@", result);
        //获取结果转NSDictionary
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            self.resp = [COLLECT objectFromDictionary:(NSDictionary *)result];
//            BeeLog(@"%@", self.resp);
//            NSLog(@"==============++++++++++++==================%@", self.resp);
        }
        //请求响应失败
        if (nil == self.resp || NO == [self.resp validate]) {
            self.failed = YES;
            return;
        }
    }
    //发送失败
    else if (self.failed) {
        NSLog(@"self.descripting===%@", self.description);
    }
    //发送取消
    else if (self.cancelled) {
        NSLog(@"self.description===%@", self.description);
    }
}

@end
