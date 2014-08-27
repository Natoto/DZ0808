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
// date:   2014-05-14 01:47:15 +0000
//

#import "Bee.h"

#pragma mark - models

@class MYPOST;
@class mypost;

@interface MYPOST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSArray *				mypost;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface mypost : BeeActiveObject
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			forum;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, copy)   NSString             *message;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			views;
@end

@interface REQ_MYPOST_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_MYPOST_SHOTS : BeeAPI
@property (nonatomic, retain) NSString          *   uid;
@property (nonatomic, retain) MYPOST            *   resp;
@property (nonatomic, retain) REQ_MYPOST_SHOTS  *   req;
@end



