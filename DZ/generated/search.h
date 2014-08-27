//
//  search.h
//  DZ
//
//  Created by PFei_He on 14-6-19.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h"

@class SEARCH;
@class searchlist;

@interface SEARCH : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSArray *				searchlist;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface searchlist : BeeActiveObject
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@end

@interface REQ_SEARCH_SHOTS : BeeActiveObject

@property (nonatomic, retain)   NSNumber            *page;
@property (nonatomic, retain)   NSNumber            *per_page;

@end

@interface API_SEARCH_SHOTS : BeeAPI

@property (nonatomic, copy)     NSString            *uid;               //用户id
@property (nonatomic, copy)     NSString            *kw;                //关键字
@property (nonatomic, strong)   NSArray             *topics;
@property (nonatomic, strong)   SEARCH              *resp;
@property (nonatomic, strong)   REQ_SEARCH_SHOTS    *req;               //请求的响应

@end
