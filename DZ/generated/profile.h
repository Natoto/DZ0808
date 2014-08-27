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
// date:   2014-05-13 11:02:01 +0000
//

#import "Bee.h"
/*
 avatar = "http://114.215.178.111/amanmanceshi/uc_server/data/avatar/000/00/00/24_avatar_middle.jpg";
 birthday = 1;
 birthmonth = 5;
 birthyear = 2014;
 contribution = 0;
 credits = 390;
 ecode = 0;
 email = "Trd@qww.com";
 emsg = "";
 favorites = 10;
 friends = 8;
 gender = 1;
 group = "\U4e2d\U7ea7\U4f1a\U5458";
 hassignplugin = 1;
 issign = 0;
 lastactivity = 1407235479;
 lastpost = 1407120263;
 lastvisit = 1407235479;
 money = 251;
 oltime = 46;
 posts = 139;
 prestige = 0;
 regdate = 1402917063;
 relationship = "";
 replys = 96;
 residecity = "\U9102\U5c14\U591a\U65af\U5e02";
 resideprovince = "\U5185\U8499\U53e4\U81ea\U6cbb\U533a";
 threads = 43;
 username = Test;
 */
#pragma mark - models

@class PROFILE;

@interface PROFILE : BeeActiveObject
@property (nonatomic, retain) NSString *            contribution;//贡献
@property (nonatomic, retain) NSString *            credits;//积分
@property (nonatomic, retain) NSString *            prestige;//威望
@property (nonatomic, retain) NSString *			avatar;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			email;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSString *            favorites;
@property (nonatomic, retain) NSString *			friends;
@property (nonatomic, retain) NSString *			group;
@property (nonatomic, retain) NSString *			lastactivity;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, retain) NSString *			lastvisit;
@property (nonatomic, retain) NSString *			money;//金钱
@property (nonatomic, retain) NSString *			oltime;
@property (nonatomic, retain) NSString *			posts;
@property (nonatomic, retain) NSString *            replys;
@property (nonatomic, retain) NSString *			regdate;
@property (nonatomic, retain) NSString *			threads;
@property (nonatomic, retain) NSString *			username;
@property (nonatomic, retain) NSNumber *            gender;
@property (nonatomic, retain) NSString *            resideprovince;
@property (nonatomic, retain) NSString *            residecity;
@property (nonatomic, retain) NSString *            birthmonth;
@property (nonatomic, retain) NSString *            birthday;
@property (nonatomic, retain) NSString *            birthyear;
@property (nonatomic, retain) NSNumber *            relationship;
@property (nonatomic, retain) NSNumber *            issign;
@property (nonatomic, retain) NSNumber *            hassignplugin;

@end

@interface API_PROFILE_SHOTS : BeeAPI

@property (nonatomic, retain) NSString               *   fuid;
@property (nonatomic, retain) NSString               *   uid;
@property (nonatomic, retain) PROFILE                *   resp;

@end



