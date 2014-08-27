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
// date:   2014-07-31 07:42:17 +0000
//

#import "Bee.h"

#pragma mark - models

@class postmine;
@class POSTMINE;

@interface postmine: BeeActiveObject
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *            fid;
@property (nonatomic, retain) NSString *            img;
@property (nonatomic, retain) NSString *            replies;
@end

@interface POSTMINE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				postmine;
@end

@interface REQ_POSTMINE_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_POSTMINEL_SHOTS : BeeAPI
@property (nonatomic, retain) NSString           *   uid;
@property (nonatomic, retain) REQ_POSTMINE_SHOTS  *   req;
@property (nonatomic, retain) POSTMINE           *   resp;
@end
