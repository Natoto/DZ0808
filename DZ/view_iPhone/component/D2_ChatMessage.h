//
//  Message.h
//  15-QQ聊天布局
//
//  Created by Nonato on 13-12-3.
//  Copyright (c) 2013年 Nonato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "allpm.h"
typedef enum {
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther = 1 //别人发得
} MessageType;

typedef enum : NSUInteger {
    STATE_SENDDING,
    STATE_SUCCESS,
    STATE_FAILED,
    STATE_OVERTIME,
} MessageState;

@interface D2_ChatMessage : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) MessageType type;
@property (nonatomic,assign) MessageState state;
@property (nonatomic, copy) friendms *dict;

@end
