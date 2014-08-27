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
// date:   2014-05-14 01:51:04 +0000
//

#import "Bee.h"

#pragma mark - models

@class COLLECTION;
@class collection;

@interface COLLECTION : BeeActiveObject
@property (nonatomic, retain) NSArray *				collection;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface collection : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			favid;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, copy)   NSString             *message;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			views;
@end

@interface REQ_COLLECTION_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_COLLECTION_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   uid;
@property (nonatomic, retain) COLLECTION            *   resp;
@property (nonatomic, retain) REQ_COLLECTION_SHOTS  *   req;
@end
