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
// date:   2014-06-03 09:27:21 +0000
//

#import "Bee.h"

#pragma mark - models

@class COMMAND;
@class command;

@interface COMMAND : BeeActiveObject
@property (nonatomic, retain) NSArray *				command;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

@interface command : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			views;
@end

@interface API_COMMAND_SHOTS : BeeAPI
@property (nonatomic, retain) COMMAND               *   resp;
@end

