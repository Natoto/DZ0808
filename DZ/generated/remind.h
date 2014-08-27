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
// date:   2014-06-03 08:44:56 +0000
//

#import "Bee.h"

#pragma mark - models

@class REMIND;
@class automatic;
@class dialog;
@class public2;

@interface REMIND : BeeActiveObject
@property (nonatomic, retain) NSArray *				automatic;
@property (nonatomic, retain) NSArray *				dialog;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				public2;
@end

@interface automatic : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			category;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			from_id;
@property (nonatomic, retain) NSString *			from_idtype;
@property (nonatomic, retain) NSString *			from_num;
@property (nonatomic, retain) NSString *			id;
@property (nonatomic, retain) NSString *			news;
@property (nonatomic, retain) NSString *			note;
@property (nonatomic, retain) NSString *			type;
@property (nonatomic, retain) NSString *			uid;
@property (nonatomic, retain) NSString *            interactivems;

@end

@interface dialog : BeeActiveObject
@property (nonatomic, retain) NSString *			isnew;
@property (nonatomic, retain) NSString *			lastdateline;
@property (nonatomic, retain) NSString *			lastupdate;
@property (nonatomic, retain) NSString *			plid;
@property (nonatomic, retain) NSString *			pmnum;
@property (nonatomic, retain) NSString *			uid;
@end

@interface public2 : BeeActiveObject
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			gpmid;
@property (nonatomic, retain) NSString *			status;
@property (nonatomic, retain) NSString *			uid;
@end



@interface API_REMIND_SHOTS : BeeAPI
@property (nonatomic, retain) NSString           *   uid;
@property (nonatomic, retain) REMIND             *   resp;
@end


