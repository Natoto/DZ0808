//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "ForumlistModel.h"
#import "UserModel.h"
#pragma mark -

#undef	PER_PAGE
#define PER_PAGE	(20)
#define player_id   @"0"
#pragma mark -

@implementation ForumlistModel

//@synthesize player_id = _player_id;
@synthesize shots = _shots;

- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
//    self.player_id=@"0";
	self.shots = [NSMutableArray array];
}

- (void)unload
{
	self.shots = nil;
//	self.player_id = nil;
}

+(NSArray *)forumsAry
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addUniqueObjectsFromArray:[forums readObjectForKey:player_id]
                                  compare:^NSComparisonResult(id left, id right) {
                                      return [((forums *)left).fid compare:((forums *)right).fid];
                                  }];
    return array;
}

+(NSArray *)readthreadtype:(NSString *)fid forum:(NSArray *)shots
{
//    threadtypes * athtype = nil;
    NSArray *array =nil;
    for (int i = 0; i<shots.count; i++) {
        forums *aforum =[shots objectAtIndex:i];
        for (int j = 0; j< aforum.child.count; j++) {
            child *achild =[aforum.child objectAtIndex:j];
            if ([achild.fid isEqualToString:fid]) {
                if (achild.isset_threadtypes.integerValue) {
//                    athtype = achild.threadtypes;
                    array = [NSArray arrayWithArray:achild.threadtypes];
                }
                else
                {
                }
                break;
            }
        }
    }
    return array;
//    return athtype;
}

#pragma mark -

- (void)loadCache
{
	[self.shots removeAllObjects];
    [self.shots addUniqueObjectsFromArray:[forums readObjectForKey:player_id]
        compare:^NSComparisonResult(id left, id right) {
            return [((forums *)left).fid compare:((forums *)right).fid];
        }];
    
}

- (void)saveCache
{
    [forums saveObject:self.shots forKey:player_id];
//    [NSArray userDefaultsWrite:[self.shots objectToString] forKey:@"ForumlistModel"];
}

- (void)clearCache
{
    [forums removeObjectForKey:player_id];
	[self.shots removeAllObjects];
    self.loaded=NO;
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
	if ( self.shots.count )
	{
		[self gotoPage:(self.shots.count / PER_PAGE + 1)];
	}
}

- (void)gotoPage:(NSUInteger)page
{
    [API_FORUMLIST_SHOTS cancel];
	API_FORUMLIST_SHOTS * api = [API_FORUMLIST_SHOTS api];
    
	@weakify(api);
	@weakify(self);
	api.uid =[UserModel sharedInstance].session.uid;
	api.req.page = @(page);
	api.req.per_page = @(PER_PAGE);
	
	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);

		if ( api.sending )
		{
			[self sendUISignal:self.RELOADING];
		}
		else
		{
			if ( api.succeed )
			{
				if ( nil == api.resp || api.resp.ecode.intValue)
				{
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{
					if ( page <= 1 )
					{
						[self.shots removeAllObjects];
						[self.shots addObjectsFromArray:api.resp.forums];
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.forums];
//						[self.shots unique:^NSComparisonResult(id left, id right) {
//							return [((FORUMLIST2 *)left).ecode compare:((FORUMLIST2 *)right).ecode];
//						}];	
					}
					self.more = NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
                 [self sendUISignal:self.FAILED withObject:@"网络异常"];
		}
	};
	
	[api send];
}

@end
