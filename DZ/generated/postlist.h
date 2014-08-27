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
// date:   2014-04-23 06:32:15 +0000
//
/*
 1：本地图片
 2：表情
 4：投票
 5: 没登录看不见图片
 3:引用回复
 6:隐藏
 7：免费信息
 8：活动
 9：辩论
 10：出售商品
 */

#import "Bee.h"
typedef enum : NSUInteger {
    CONTENTTYPE_TEXT = 0,
    CONTENTTYPE_IMG = 1,
    CONTENTTYPE_FACIAL = 2,
    CONTENTTYPE_QUOTEREPLY = 3,
    CONTENTTYPE_VOTE = 4,
    CONTENTTYPE_NOLOGNOSEE = 5,
    CONTENTTYPE_HIDE = 6,
    CONTENTTYPE_FREEMSG = 7,
    CONTENTTYPE_ACTIVE = 8,
    CONTENTTYPE_DEBUTE = 9,
    CONTENTTYPE_SELLS = 10,
} CONTENTTYPE;
#pragma mark - models
@class content;
@class post;
@class postlist;
@class topic;

@interface content : BeeActiveObject
@property (nonatomic, retain) NSNumber *			isremote;
@property (nonatomic, retain) NSString *			msg;
@property (nonatomic, retain) NSNumber *			type;
@property (nonatomic, retain) NSString *            originimg;
@property (nonatomic, retain) NSNumber *            att_isarrow;
@property (nonatomic, retain) NSString *            att_filename;
@property (nonatomic, retain) NSString *            isimage;
@property (nonatomic, retain) NSString *            att_description;
@property (nonatomic, retain) NSString *            signmod;

@end

@interface content_vote : BeeActiveObject
@property (nonatomic, retain) NSString *  polloptionid;
@property (nonatomic, retain) NSString *  polloption;
@property (nonatomic, retain) NSString *  votes;
@property (nonatomic, retain) NSString *  width;
@property (nonatomic, retain) NSString *  percent;
@property (nonatomic, retain) NSString *  color;
@property (nonatomic, retain) NSString *  imginfo;
@end


@interface post : BeeActiveObject
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			authorname;
@property (nonatomic, retain) NSArray *				content;
@property (nonatomic, retain) NSString *			pid;
@property (nonatomic, retain) NSString *			position;
@property (nonatomic, retain) NSString *			postsdate;
@property (nonatomic, strong) NSNumber             *status;
@property (nonatomic, strong) NSNumber             *subtract;
@property (nonatomic, strong) NSNumber             *support;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSString *			usericon;
@end

@interface POSTLIST2 : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSArray *				post;
@property (nonatomic, retain) topic *			    topic;
@property (nonatomic, retain) NSNumber *			totalPage;
@property (nonatomic, retain) NSString *			weburl;
@end

@interface topic : BeeActiveObject
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			authorname;
@property (nonatomic, retain) NSArray *				content;
@property (nonatomic, retain) NSObject *			digest;
@property (nonatomic, retain) NSObject *			favid;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSObject *			heats;
@property (nonatomic, retain) NSNumber *			isarrow;
@property (nonatomic, retain) NSNumber *			isfavorite;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, retain) NSString *			pid;
@property (nonatomic, retain) NSString *			position;
@property (nonatomic, retain) NSString *			postsdate;
@property (nonatomic, retain) NSObject *			recommends;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, strong) NSNumber              * status;
@property (nonatomic, retain) NSObject *			stickreply;
@property (nonatomic, strong) NSString             *subtract;
@property (nonatomic, strong) NSNumber             *support;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSString *			usericon;
@property (nonatomic, retain) NSString *			views;
@end



#pragma mark - GET /players/:id/shots

@interface REQ_POSTLIST_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

//@interface RESP_POSTLIST_SHOTS : BeeActiveObject
//@property (nonatomic, retain) NSNumber *			page;
//@property (nonatomic, retain) NSNumber *			pages;
//@property (nonatomic, retain) NSNumber *			per_page;
//@property (nonatomic, retain) NSArray *				shots;
//@property (nonatomic, retain) NSNumber *			total;
//@end

@interface API_POSTLIST_SHOTS : BeeAPI
@property (nonatomic, retain) NSString *    uid;
@property (nonatomic, retain) NSString *    onlyauthorid;
@property (nonatomic, retain) NSString *	tid;
@property (nonatomic, retain) REQ_POSTLIST_SHOTS *	req;
@property (nonatomic, retain) POSTLIST2 *	posts;
@end

