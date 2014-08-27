//    												
//    												
//    	 ______    ______    ______					
//    	/\  __ \  /\  ___\  /\  ___\			
//    	\ \  __<  \ \  __\_ \ \  __\_		
//    	 \ \_____\ \ \_____\ \ \_____\		
//    	  \/_____/  \/_____/  \/_____/			
//    												
//    												
//    												
// title:  
// author: unknown
// date:   2014-04-22 05:36:13 +0000
//

#import "Bee.h"

#pragma mark - models

@class TOPICLIST2;
@class topics;

@interface TOPICLIST2 : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSArray *				topics;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface topics : BeeActiveObject
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			authorname;
@property (nonatomic, retain) NSString *			digest;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			heats;
@property (nonatomic, retain) NSString *			icon;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, retain) NSString *			recommends;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSNumber *			stickreply;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			views;
@property (nonatomic, retain) NSString *			readperm;
@property (nonatomic, retain) NSString *			message;
@end


@interface REQ_TOPICLIST_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface RESP_TOPICLIST_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSArray *				shots;
@property (nonatomic, retain) NSNumber *			total;
@end


@interface API_TOPICLIST_SHOTS : BeeAPI
@property (nonatomic, retain) NSString *    type;
@property (nonatomic, retain) NSString *	fid;
@property (nonatomic, retain) REQ_TOPICLIST_SHOTS   *	req;
@property (nonatomic, retain) RESP_TOPICLIST_SHOTS  *	respthe;
@property (nonatomic, retain) TOPICLIST2 *	topics;
@end
