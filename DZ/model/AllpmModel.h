//
//  AllpmModel.h
//  DZ
//
//  Created by Nonato on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

typedef enum : NSInteger {
    MSG_PUBLIC=1, // 公共消息
    MSG_HAOYOU = 2, //好友消息
    MSG_ALL=3, //所有消息
} MSG_TYPE;

typedef enum : NSInteger {
    DATE_ALLDATE=1,     //所有时间
    DATA_RECENTDATE=0, //最近
} DATE_TYPE;

@interface LASFLASHDATA : NSObject
@property(nonatomic,strong)NSNumber       * nowdate;
@end

@interface ALLPMMODEFRIENDSLIST : NSObject
@property(nonatomic,strong)NSString * fromid;
@end

@interface ALLPMSTRANGERLIST : NSObject
@property(nonatomic,strong)NSString * authorid;
@end

#import "Bee_StreamViewModel.h"
#import "allpm.h"
#import "UserModel.h"

#define FRDNAMEKEY @"friendNamekey"
@interface AllpmModel : BeeStreamViewModel
{
    NSString *key;
}
-(void)loadCache:(MSG_TYPE)msgtype;
@property(nonatomic,strong)NSMutableArray * agoodfriendms;
@property(nonatomic,strong)NSMutableArray * friendms;
//@property(nonatomic,strong)NSMutableArray * grouppms;
//@property(nonatomic,strong)NSMutableArray * interactivems;
@property(nonatomic,strong)NSMutableArray * strangerms;
@property(nonatomic,strong)NSMutableArray * astrangermessages;
@property(nonatomic,strong)NSMutableArray * systemms;
@property(nonatomic,strong)NSMutableDictionary *friendmsDic;
@property(nonatomic,strong)NSString       * uid;
@property(nonatomic,strong)LASFLASHDATA   * nowdate;
@property(nonatomic,strong)NSString       * msgtype;
@property(nonatomic,strong)NSString       * frienduid;
@property(nonatomic,assign)BOOL             loading;
-(void)getALLMessageWithtype:(MSG_TYPE)style;
-(void )getMessageWithtype:(NSString *)type date:(NSNumber *)date;
-(void)getNewMessage;
-(void)loadFriendmsCashe:(NSString *)frienduid;
-(NSMutableArray *)loadfriendmsCache:(MSG_TYPE) msgtype frienduid:(NSString *)frienduid agoodfriendms:(NSMutableArray *)onegoodfriendms; 
-(void)clearStrangersms;
+(NSInteger)strangermsCount;
@end
