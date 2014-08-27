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
// date:   2014-04-21 12:40:10 +0000
//

#import "Bee.h"

#pragma mark - models

@class FORUMLIST;
@class child;
@class forums;
//@class threadtypes;

@interface FORUMLIST2 : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				forums;
@end

@interface child : BeeActiveObject
@property (nonatomic, retain) NSObject *			child;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			icon;
@property (nonatomic, retain) NSNumber *			isset_threadtypes;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSNumber *			onlineusers;
@property (nonatomic, retain) NSString *			posts;
@property (nonatomic, retain) NSString *			threads;
@property (nonatomic, retain) NSArray  *			threadtypes;
@property (nonatomic, retain) NSString *			todayposts;
@property (nonatomic, retain) NSString *			type;
@end

@interface selectPlatesChild : child
@property(nonatomic,retain) NSString                * mark;
@end


@interface forums : BeeActiveObject
@property (nonatomic, retain) NSArray *				child;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			icon;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSNumber *			onlineusers;
@property (nonatomic, retain) NSString *			posts;
@property (nonatomic, retain) NSString *			threads;
@property (nonatomic, retain) NSString *			todayposts;
@property (nonatomic, retain) NSString *			type;
@end


//@interface threadtypes : BeeActiveObject
//@property (nonatomic, retain) NSString *			one;
//@property (nonatomic, retain) NSString *			two;
//@property (nonatomic, retain) NSString *			three;
//@property (nonatomic, retain) NSString *			four;
//@property (nonatomic, retain) NSString *			five;
//@end

#pragma mark - GET /players/:id/shots

@interface REQ_FORUMLIST_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface RESP_FORUMLIST_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			pages;
@property (nonatomic, retain) NSNumber *			per_page;
@property (nonatomic, retain) NSArray *				shots;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface API_FORUMLIST_SHOTS : BeeAPI
@property (nonatomic,retain)  NSString *    uid; 
@property (nonatomic, retain) REQ_FORUMLIST_SHOTS *	req;
@property (nonatomic, retain) FORUMLIST2 *	resp;
@end


@interface API_SUBFORUMLIST_SHOTS : BeeAPI
@property (nonatomic, retain) NSString *	fid;
@property (nonatomic, retain) REQ_FORUMLIST_SHOTS *	req;
@property (nonatomic, retain) FORUMLIST2 *	resp;
@end

