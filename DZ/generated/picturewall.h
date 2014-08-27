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
// date:   2014-07-23 12:00:56 +0000
//

#import "Bee.h"

#pragma mark - models

@class pcms;
@class PICTUREWALL;

@interface pcms : BeeActiveObject
@property (nonatomic, retain) NSString *			attachment;
@property (nonatomic, retain) NSNumber *			height;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSNumber *			width;
@end

@interface PICTUREWALL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				pcms;
@end


@interface REQ_PICTUREWALL_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_PICTUREWALL_SHOTS : BeeAPI
//@property (nonatomic, retain) NSString              *   uid;
@property(nonatomic,retain) NSString *last_tid;
@property (nonatomic, retain) REQ_PICTUREWALL_SHOTS *   req;
@property (nonatomic, retain) PICTUREWALL           *   resp;
@end
