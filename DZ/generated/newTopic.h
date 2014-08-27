//
//  newTopic.h
//  DZ
//
//  Created by Nonato on 14-4-28.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import <Foundation/Foundation.h>
@class newtopicContent;

@interface NEWTOPPIC : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

#pragma mark - GET /players/:id/shots

@interface newtopicContent : BeeActiveObject
@property (nonatomic, retain) NSString *			msg;
@property (nonatomic, retain) NSNumber *			type;//内容类型
@property (nonatomic, retain) NSNumber *            aid;//附件
@end

@interface REQ_NEWTOPPIC_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end



@interface API_NEWTOPPIC_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   uid;
@property (nonatomic, retain) NSString              *   fid;
@property (nonatomic, assign) NSNumber              *   typedid;
@property (nonatomic, retain) NSString              *   subject;
@property (nonatomic, retain) NSString              *   sortid;
@property (nonatomic, retain) NSString              *   authorid;
@property (nonatomic, retain) NSString              *   author;
@property (nonatomic, retain) NSMutableArray        *   reqcontentAry;
@property (nonatomic, retain) NEWTOPPIC             *   resp;
@property (nonatomic, retain) REQ_NEWTOPPIC_SHOTS   *	req;
@end
