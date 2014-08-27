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
// date:   2014-04-28 01:19:30 +0000
//

#import "Bee.h"

#pragma mark - models

@class NEWORHOTLIST;
@class topics;

@interface NEWORHOTLIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSArray *				topics;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface neworlisttopics : BeeActiveObject
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			authorname;
@property (nonatomic, retain) NSString *			digest;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			heats;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, copy)   NSString             *message;
@property (nonatomic, retain) NSString *			recommends;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSNumber *			stickreply;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			views;
@end


#pragma mark - GET /players/:id/shots

@interface REQ_NEWORHOT_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end


@interface API_NEWORHOT_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   fid;
@property (nonatomic, assign) NSNumber              *   type;
@property (nonatomic, retain) REQ_NEWORHOT_SHOTS    *	req;
@property (nonatomic, retain) NEWORHOTLIST          *   resp;
@end


