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
// date:   2014-04-25 02:20:35 +0000
//

#import "Bee.h"
#import "rmbdz.h"
#pragma mark - models

@class HOME2;
@class home;
@class hot;
@class my;
@class newest;
@class topics2;
@class digest;
@class home_command;
@class onoff;
@class home_activity;

@interface HOME2TOPICSPOSITIONITEM : NSObject<NSCopying>
@property (nonatomic, retain) NSString *        backgroundcolor;
@property (nonatomic, retain) NSString *        title;
@property (nonatomic, retain) NSString *        icon;
@property (nonatomic, retain) NSString *		fid;
@property (nonatomic, retain) NSString *		subject;
@property (nonatomic, retain) NSString *		count;
@property (nonatomic, retain) NSString * 		enableDelete;
@end

@interface HOME2 : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) home *		    	home;
@property (nonatomic, retain) onoff *               onoff;
@end

@interface home : BeeActiveObject
@property (nonatomic, retain) home_activity * 	activity;
@property (nonatomic, retain) hot *			hot;
@property (nonatomic, retain) digest *      digest;
@property (nonatomic, retain) home_command *     command;
@property (nonatomic, retain) my *			my;
@property (nonatomic, retain) newest *		newest;
@property (nonatomic, retain) NSArray *		topics2;

@end

@interface hot : BeeActiveObject
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			title;

@end

@interface my : BeeActiveObject

@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *            img;
@property (nonatomic, retain) NSString *            title;
@end

@interface newest : BeeActiveObject
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			title;
@end

@interface home_command : BeeActiveObject
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			title;
@end


@interface home_activity : BeeActiveObject
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			title;
@end

@interface digest : BeeActiveObject
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			title;
@end

@interface topics2 : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			fid;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *            title;
@property (nonatomic, retain) NSString *            img; 
@end

@interface onoff : BeeActiveObject
@property (nonatomic, retain) NSNumber *            isactivity;
@property (nonatomic, retain) NSNumber *			iscommand;
@property (nonatomic, retain) NSNumber *			isregist;
@end

#pragma mark - GET /players/:id/shots

@interface REQ_HOME_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end


@interface API_HOME_SHOTS : BeeAPI
@property (nonatomic, retain) NSString *    uid;
@property (nonatomic, retain) NSString *    fids;
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_HOME_SHOTS *	req;
@property (nonatomic, retain) HOME2 *	resp;
@end
 
