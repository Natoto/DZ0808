//
//  postImage.h
//  DZ
//
//  Created by Nonato on 14-5-6.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_ActiveObject.h"
#import "Bee.h"
@class newtopicContent;

@interface POSTIMAGE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSString *			url;//内容类型
@property (nonatomic, retain) NSNumber *            aid;//附件
@end
 

//@interface postImageContent : BeeActiveObject
//@property (nonatomic, retain) NSString *			url;//内容类型
//@property (nonatomic, retain) NSNumber *            aid;//附件
//@end

@interface REQ_POSTIMAGE_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_POSTIMAGE_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   fid;
@property (nonatomic, retain) NSString              *   uid;
@property (nonatomic, retain) NSString              *   filename;
@property (nonatomic, retain) NSData                *   filedata;
@property (nonatomic, retain) POSTIMAGE             *   resp;
@property (nonatomic, retain) REQ_POSTIMAGE_SHOTS   *	req;
@end
