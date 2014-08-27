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
// date:   2014-06-03 08:49:06 +0000
//

#import "Bee.h"

#pragma mark - models

@class ALLPM;
@class friendms;
@class allpm_public;
@class strangerms;

@interface ALLPM : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				friendms;
@property (nonatomic, retain) NSNumber *			nowdate;
@property (nonatomic, retain) NSArray *				allpm_public;
@property (nonatomic, retain) NSArray *				strangerms;
@end

@interface friendms : BeeActiveObject
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			avatar;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			delstatus;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			plid;
@property (nonatomic, retain) NSString *			pmid;
@property (nonatomic, retain) NSString *			touid;
@end

@interface allpm_public : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			touid;
@end

@interface strangerms : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			avatar;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			delstatus;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			plid;
@property (nonatomic, retain) NSString *			pmid;
@property (nonatomic, retain) NSString *			touid;
@end
 
@interface API_ALLPM_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   style;
@property (nonatomic, retain) NSString              *   uid;
@property (nonatomic, retain) ALLPM                 *   resp;
@property (nonatomic, retain) NSNumber              *   date; 
@end

