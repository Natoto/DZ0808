//
//  PMModel.h
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//


typedef enum : NSInteger {
    MSG_ZHANNEI = 1,
    MSG_FRIENDS = 2,
    MSG_SYSTEM = 3,
} MSG_TYPE_FILTE;


#import "Bee_StreamViewModel.h"
@class PM;
@interface PMModel : BeeStreamViewModel
@property(nonatomic, retain) NSString           *   filter;
@property(nonatomic, retain) NSString           *    uid;
@property(nonatomic,retain)   NSArray           *    grouppms;
@property(nonatomic,retain)   NSArray           *    strangerms;

-(void)loadCache:(MSG_TYPE_FILTE)msg_type;
@end
