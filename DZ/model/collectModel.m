//
//  collectModel.m
//  DZ
//
//  Created by PFei_He on 14-6-24.
//
//

#import "collectModel.h"
#import "collect.h"
#import "UserModel.h"

@implementation collectModel

@synthesize uid = _uid;
@synthesize tid = _tid;
@synthesize favid = _favid;

- (void)collect
{
    [API_COLLECT_SHOTS cancel];
    API_COLLECT_SHOTS *api = [API_COLLECT_SHOTS api];

    @weakify(api);
    @weakify(self);

//    if ([UserModel sharedInstance].session.uid)
//        api.uid = [UserModel sharedInstance].session.uid;
    api.uid = self.uid;
    api.tid = self.tid;

    api.whenUpdate = ^{

        @normalize(api);
        @normalize(self);

        if (api.sending) {
            [self sendUISignal:self.RELOADING];
        }
        else
        {
            if (api.succeed)
            {
                if (nil == api.resp || api.resp.ecode.integerValue) {
                    api.failed = YES;
                    [self sendUISignal:self.FAILED];
                }
                else
                {
                    self.favid = api.resp.favid;
                    [self sendUISignal:self.RELOADED];
                }
            }
            else
            {
                [self sendUISignal:self.FAILED];
            }
        }
    };
    [api send];
}

@end
