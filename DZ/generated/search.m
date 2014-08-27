//
//  search.m
//  DZ
//
//  Created by PFei_He on 14-6-19.
//
//

#import "search.h"
#import "rmbdz.h"

@implementation SEARCH

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize searchlist = _searchlist;
@synthesize totalPage = _totalPage;

CONVERT_PROPERTY_CLASS( searchlist, searchlist );

- (BOOL)validate
{
    return YES;
}

@end

#pragma mark - searchlist

@implementation searchlist

@synthesize fid = _fid;
@synthesize subject = _subject;
@synthesize tid = _tid;

- (BOOL)validate
{
    return YES;
}

@end


@implementation REQ_SEARCH_SHOTS

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_SEARCH_SHOTS

@synthesize uid = _uid;
@synthesize kw = _kw;
@synthesize topics = _topics;
@synthesize resp = _resp;
@synthesize req = _req;

- (BOOL)validate
{
    return YES;
}

- (void)dealloc
{
    self.uid = nil;
    self.kw = nil;
}

- (void)routine
{
    //发送请求
    if (self.sending)
    { 
        if (NULL == self.kw)
        {
            self.failed = YES;
            return;
        } 
        //清除关键字空格
        self.kw = self.kw.trim;

        //接口地址
//        NSData *data = [(NSString *)self.kw dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//        NSString *requestURI = [NSString stringWithFormat:@"%@?action=search&kw=%@&uid=%@", [ServerConfig sharedInstance].url, data, self.uid ? self.uid : @""];

        NSString *requestURI = [NSString stringWithFormat:@"%@?action=search%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];

        //发送POST请求
        self.HTTP_POST(requestURI).PARAM(@"kw", self.kw).PARAM(@"uid", self.uid ? self.uid : @"");
    }
    //请求成功
    else if (self.succeed)
    {
        //请求结果转JSON
        NSObject *result = self.responseJSON;
        NSLog(@"123=================%@", result);
        //获取结果转NSDictionary
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            self.resp = [SEARCH objectFromDictionary:(NSDictionary *)result];
            BeeLog(@"%@", self.resp);
            NSLog(@"==============++++++++++++==================%@", self.resp);
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
