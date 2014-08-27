//
//  AboutUsModel.m
//  DZ
//
//  Created by PFei_He on 14-6-23.
//
//

#import "AboutUsModel.h"

@implementation AboutUsModel

DEF_SIGNAL(ABOUTUS)

- (void)aboutUs
{
    [API_ABOUTUS_SHOTS cancel];
    API_ABOUTUS_SHOTS *api = [API_ABOUTUS_SHOTS api];

    @weakify(api);
    @weakify(self);

    api.whenUpdate = ^{

        @normalize(api);
        @normalize(self);

        if (api.sending) {
            [self sendUISignal:self.RELOADING];
        }
        else
        {
            if (api.succeed) {
                if (nil == api.resp) {
                    api.failed = YES;
                    [self sendUISignal:self.FAILED];
                }
                [self sendUISignal:self.RELOADED];
            }
            else{
                [self sendUISignal:self.FAILED];
            }
        }
    };
    [api send];
}

@end
