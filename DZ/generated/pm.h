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
// date:   2014-06-09 05:31:08 +0000
//

#import "Bee.h"

#pragma mark - models

@class PM;
@class grouppms;
@class strangerms;

@interface PM : BeeActiveObject
@property (nonatomic, retain) NSArray *				grouppms;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				strangerms;
@end

@interface pm_grouppms : BeeActiveObject
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			touid;
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			dateline;
@end

@interface pm_strangerms : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			touid;
@end


@interface API_PM_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *    filter;
@property (nonatomic, retain) NSString              *    uid;
@property (nonatomic, retain) PM                    *    resp; 
@end

