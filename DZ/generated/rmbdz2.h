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
// date:   2014-04-10 09:36:11 +0000
//

#import "Bee.h"

#pragma mark - models

@class FORUMLIST;
@class HOMEPAGE;
@class LOGIN;
@class LOGOUT;
@class POSTLIST;
@class REGISTER;
@class SUBFORUMLIST;
@class TOPICLIST;
@class child;
@class content;
@class forums;
@class home;
@class my;
@class newest;
@class post;
@class topic;
@class topics;

@interface FORUMLIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				forums;
@end

@interface HOMEPAGE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) home *			home;
@end

@interface LOGIN : BeeActiveObject
@property (nonatomic, retain) NSString *			account;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

@interface LOGOUT : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

@interface POSTLIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSString *			page;
@property (nonatomic, retain) NSArray *				post;
@property (nonatomic, retain) topic *			topic;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface REGISTER : BeeActiveObject
@property (nonatomic, retain) NSString *			account;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

@interface SUBFORUMLIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				forums;
@end

@interface TOPICLIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSArray *				topics;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface child : BeeActiveObject
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			icon;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSNumber *			onlineusers;
@property (nonatomic, retain) NSString *			posts;
@property (nonatomic, retain) NSString *			threads;
@property (nonatomic, retain) NSString *			todayposts;
@property (nonatomic, retain) NSString *			type;
@end

@interface content : BeeActiveObject
@property (nonatomic, retain) NSNumber *			isremote;
@property (nonatomic, retain) NSString *			msg;
@property (nonatomic, retain) NSNumber *			type;
@end

@interface forums : BeeActiveObject
@property (nonatomic, retain) NSArray *				child;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			icon;
@property (nonatomic, retain) NSObject *			lastpost;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSNumber *			onlineusers;
@property (nonatomic, retain) NSString *			posts;
@property (nonatomic, retain) NSString *			threads;
@property (nonatomic, retain) NSString *			todayposts;
@property (nonatomic, retain) NSString *			type;
@property (nonatomic, retain) NSString *			children;
@end

@interface home : BeeActiveObject
@property (nonatomic, retain) my *			my;
@property (nonatomic, retain) newest *			newest;
@property (nonatomic, retain) NSArray *				topics;
@end

@interface my : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSObject *			message;
@property (nonatomic, retain) NSObject *			subject;
@end

@interface newest : BeeActiveObject
@property (nonatomic, retain) NSString *			count;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			title;
@end

@interface post : BeeActiveObject
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			authorname;
@property (nonatomic, retain) NSArray *				content;
@property (nonatomic, retain) NSString *			pid;
@property (nonatomic, retain) NSString *			position;
@property (nonatomic, retain) NSString *			postsdate;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSString *			usericon;
@end

@interface topic : BeeActiveObject
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			authorname;
@property (nonatomic, retain) NSArray *				content;
@property (nonatomic, retain) NSString *			digest;
@property (nonatomic, retain) NSString *			heats;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, retain) NSString *			pid;
@property (nonatomic, retain) NSString *			position;
@property (nonatomic, retain) NSString *			postsdate;
@property (nonatomic, retain) NSString *			recommends;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSString *			stickreply;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSString *			usericon;
@property (nonatomic, retain) NSString *			views;
@end

@interface topics : BeeActiveObject
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			authorname;
@property (nonatomic, retain) NSString *			digest;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *			heats;
@property (nonatomic, retain) NSString *			icon;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, retain) NSString *			recommends;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSNumber *			stickreply;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			views;
@end


#pragma mark - config

@interface ServerConfig : NSObject

AS_SINGLETON( ServerConfig )

AS_INT( CONFIG_DEVELOPMENT )
AS_INT( CONFIG_TEST )
AS_INT( CONFIG_PRODUCTION )

@property (nonatomic, assign) NSUInteger			config;

@property (nonatomic, readonly) NSString *			url;
@property (nonatomic, readonly) NSString *			testUrl;
@property (nonatomic, readonly) NSString *			productionUrl;
@property (nonatomic, readonly) NSString *			developmentUrl;
@end
