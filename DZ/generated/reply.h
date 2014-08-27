//
//  reply.h
//  DZ
//
//  Created by Nonato on 14-5-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import <Foundation/Foundation.h>
@class replyContent;

@interface REPLY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

#pragma mark - GET /players/:id/shots

@interface replyContent : BeeActiveObject
@property (nonatomic, retain) NSString *			msg;
@property (nonatomic, retain) NSNumber *			type;//内容类型
@property (nonatomic, retain) NSNumber *            aid;//附件
@end

@interface REQ_REPLAY_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end



@interface API_REPLAY_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   pid;
@property (nonatomic, retain) NSString              *   tid;
@property (nonatomic, assign) NSString              *   fid;
@property (nonatomic, retain) NSString              *   authorid;
@property (nonatomic, retain) NSMutableArray        *   reqcontentAry;
@property (nonatomic, retain) REPLY                 *   resp;
@property (nonatomic, retain) REQ_REPLAY_SHOTS      *	req;
@end
