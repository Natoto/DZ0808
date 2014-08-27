//
//  SearchModel.m
//  DZ
//
//  Created by PFei_He on 14-6-19.
//
//

#import "SearchModel.h"
#import "UserModel.h"

@implementation SearchModel

//DEF_SIGNAL(SEARCH_RELOADED)
//DEF_SIGNAL(SEARCH_FAILED)
//DEF_SIGNAL(SEARCH_LOADING)

//@synthesize session;
@synthesize uid = _uid;
@synthesize kw = _kw;
@synthesize tid = _tid;
@synthesize fid = _fid;
@synthesize shots = _shots;

- (void)load
{
    self.shots = [NSMutableArray array];
}

- (void)unload
{
    self.tid = nil;
    self.fid = nil;
    self.shots = nil;
}

#pragma mark - cache

- (void)loadCache
{

}

- (void)saveCache
{

}

- (void)clearCache
{
    self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
    [self gotoPage:1];
}

- (void)gotoPage:(NSUInteger)page
{
    [API_SEARCH_SHOTS cancel];
    API_SEARCH_SHOTS *api = [API_SEARCH_SHOTS api];

    @weakify(api);
    @weakify(self);

    //    api.uid = [UserModel sharedInstance].session.uid;
    if ([UserModel sharedInstance].session.uid)
        api.uid = [UserModel sharedInstance].session.uid;
    else
        api.uid = nil;
    api.kw = self.kw;
    api.topics = self.shots;
    api.req.page = @(page);
    api.req.per_page = @(PER_PAGE);

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
                    if (page <= 1) {
                        [self.shots removeAllObjects];
                        [self.shots addObjectsFromArray:api.resp.searchlist];
                    }
                    else
                    {
                        [self.shots addObjectsFromArray:api.resp.searchlist];
                    }
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
