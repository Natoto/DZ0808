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
// date:   2014-05-14 01:28:50 +0000
//

#import "Bee.h"

#pragma mark - models

@class FRIENDS;
@class friends;

@interface FRIENDS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				friends;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface friends : BeeActiveObject
@property (nonatomic, retain) NSString *			avatar;
@property (nonatomic, retain) NSString *			fuid;
@property (nonatomic, retain) NSString *			username;
@property (nonatomic, retain) NSString *			pinyin;
@end


@interface REQ_FRIENDS_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_FRIENDS_SHOTS : BeeAPI
@property (nonatomic, retain) NSString           *   uid;
@property (nonatomic, retain) FRIENDS            *   resp;
@property (nonatomic, retain) REQ_FRIENDS_SHOTS  *   req;
@end

