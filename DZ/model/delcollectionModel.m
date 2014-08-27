//
//  delcollectionModel.m
//  DZ
//
//  Created by PFei_He on 14-7-3.
//
//

#import "delcollectionModel.h"
#import "delcollection.h"
#import "UserModel.h"

@implementation delcollectionModel

@synthesize uid = _uid;

- (void)delcollection
{
    [API_DELCOLLECTION_SHOTS cancel];
    API_DELCOLLECTION_SHOTS *api = [API_DELCOLLECTION_SHOTS api];

    @weakify(api);
    @weakify(self);

    api.uid = self.uid;
    api.favid = self.favid;

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
