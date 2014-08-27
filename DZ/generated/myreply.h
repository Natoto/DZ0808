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
// date:   2014-06-03 08:52:47 +0000
//

#import "Bee.h"

#pragma mark - models

@class MYREPLY;
@class myreply;

@interface MYREPLY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSArray *				myreply;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface myreply : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			avatar;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@end


@interface REQ_MYREPLY_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_MYREPLY_SHOTS : BeeAPI
@property (nonatomic, retain) NSString           *   uid;
@property (nonatomic, retain) MYREPLY            *   resp;
@property (nonatomic, retain) REQ_MYREPLY_SHOTS  *   req;
@end

