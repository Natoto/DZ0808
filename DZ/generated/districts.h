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
// date:   2014-05-16 06:08:12 +0000
//

#import "Bee.h"

#pragma mark - models

@class DISTRICTS;
@class child;
@class districts;

@interface DISTRICTS : BeeActiveObject
@property (nonatomic, retain) NSArray *				districts;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

@interface dis_child : BeeActiveObject
@property (nonatomic, retain) NSString *			displayorder;
@property (nonatomic, retain) NSString *			id;
@property (nonatomic, retain) NSString *			level;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			upid;
@property (nonatomic, retain) NSString *			usetype;
@end

@interface districts : BeeActiveObject
@property (nonatomic, retain) NSArray *				child;
@property (nonatomic, retain) NSString *			displayorder;
@property (nonatomic, retain) NSString *			id;
@property (nonatomic, retain) NSString *			level;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			upid;
@property (nonatomic, retain) NSString *			usetype;
@end

 

@interface API_DISTRICTS_SHOTS : BeeAPI 
@property (nonatomic, retain) DISTRICTS         *   resp;
@end

