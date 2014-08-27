//
//  delcollection.m
//  DZ
//
//  Created by PFei_He on 14-7-3.
//
//

#import "delcollection.h"
#import "rmbdz.h"

@implementation DELCOLLECTION

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_DELCOLLECTION_SHOTS

@synthesize uid = _uid;
@synthesize favid = _favid;

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
        NSString *requestURI = [NSString stringWithFormat:@"%@?action=delcollction%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid", self.uid).PARAM(@"favid", self.favid);
    }
    //请求成功
    else if (self.succeed)
    {
        //请求结果转JSON
        NSObject *result = self.responseJSON;
        NSLog(@"aaabbbccc%@", result);
        //获取结果转NSDictionary
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            self.resp = [DELCOLLECTION objectFromDictionary:(NSDictionary *)result];
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
