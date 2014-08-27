//
//  FeedbackModel.m
//  DZ
//
//  Created by PFei_He on 14-6-23.
//
//

#import "FeedbackModel.h"

@implementation FeedbackModel

DEF_SIGNAL(FEEDBACK_RELOADING)
DEF_SIGNAL(FEEDBACK_RELOADED)
DEF_SIGNAL(FEEDBACK_FAILED)

@synthesize appId = _appId;
@synthesize appVersion = _appVersion;
@synthesize content = _content;
@synthesize QQ = _QQ;

- (void)feedback
{
    [API_FEEDBACK_SHOTS cancel];
    API_FEEDBACK_SHOTS *api = [API_FEEDBACK_SHOTS api];

    @weakify(api);
    @weakify(self);

    api.content = self.content;
    api.QQ = self.QQ;

    api.whenUpdate = ^{

        @normalize(api);
        @normalize(self);

        if (api.sending) {
            [self sendUISignal:self.FEEDBACK_RELOADING];
        }
        else
        {
            if (api.succeed)
            {
                if (nil == api.resp) {
                    api.failed = YES;
                    [self sendUISignal:self.FEEDBACK_FAILED];
                }
                else
                {
                    [self sendUISignal:self.FEEDBACK_RELOADED];
                }
            }
            else if (api.failed)
            {
                [self sendUISignal:self.FEEDBACK_FAILED];
            }
        }
    };
    [api send];
}

@end
