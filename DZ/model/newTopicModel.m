                    //
//  newTopicModel.m
//  DZ
//
//  Created by Nonato on 14-4-28.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "UserModel.h"
#import "newTopicModel.h"
#define DRAFTS @"drafts.content"
@implementation newTopicModel
DEF_SINGLETON(newTopicModel)
@synthesize fid=_fid,subject=_subject, sortid=_sortid,typedid=_typedid,authorid=_authorid,author=_author,contents=_contents;

//将编辑内容保存到数据库
-(void)savedraft:(NSArray *)array
{
    [newtopicContent saveObject:array forKey:DRAFTS];
}

-(NSMutableArray *)loaddratfs
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [array addUniqueObjectsFromArray:[newtopicContent readObjectForKey:DRAFTS]
                                  compare:^NSComparisonResult(id left, id right) {
                                      return [((newtopicContent *)left).msg compare:((newtopicContent *)right).msg];
                                  }];
    return array;
}
-(void)clearDrafts
{
    [newtopicContent removeObjectForKey:DRAFTS];
}

- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _fid=nil;
    _subject=nil;
    _sortid=nil;
    _typedid=nil;
    _authorid=nil;
    _author=nil;
    [_contents removeAllObjects];
    _contents=nil;
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
    self.loaded=NO;
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
    [API_NEWTOPPIC_SHOTS cancel];
    
	API_NEWTOPPIC_SHOTS * api = [API_NEWTOPPIC_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    api.uid=[UserModel sharedInstance].session.uid;
    api.fid=_fid;
    api.subject=_subject;
    api.sortid=_sortid;
    api.typedid=_typedid;
    api.authorid=_authorid;
    api.author=_author;
    api.reqcontentAry=_contents;
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
				if ( nil == api.resp || api.resp.ecode.integerValue)
				{
					api.failed = YES;
                    [self sendUISignal:self.FAILED];
				}
				else
				{ 
					self.more = NO;
					self.loaded = YES;
                    [self sendUISignal:self.RELOADED];
//					[self saveCache];
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
