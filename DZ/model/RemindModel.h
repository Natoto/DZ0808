//
//  RemindModel.h
//  DZ
//
//  Created by Nonato on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//



typedef enum : NSUInteger {
    MSG_ZHANNEIXIN = 1,
    MSG_GOODFREIND = 2,
    MSG_SYSTEM_REMAIND = 3,
} MSG_TYPE_REMIND;

#import "Bee_StreamViewModel.h"
#import "remind.h"

static int FRIENDSMESSAGE;
static int SYSTEMMESSAGE;
static int INNERMESSAGE;  

@interface RemindModel : BeeStreamViewModel
@property (nonatomic, retain) NSString          *    uid;
@property (nonatomic,retain)  NSMutableArray    *    shots;
@property (nonatomic, retain) NSMutableArray    *    friendsautomatic;
@property (nonatomic, retain) NSMutableArray    *    sysautomatic;
@property (nonatomic, retain) NSMutableArray    *    dialog;
@property (nonatomic, assign) MSG_TYPE_REMIND        msg_type;
- (void)clearCache:(MSG_TYPE_REMIND)msg_type;
+(int)newmessagecount;
+(int)systemmessagecount;
+(int)innermessagecount;
+(int)friendmessagecount;
@end
