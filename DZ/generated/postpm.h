//
//  postpm.h
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import <Foundation/Foundation.h>

@interface POSTPM : NSObject
@property(nonatomic,retain)NSString * ecode;
@property(nonatomic,retain)NSString * emsg;
@end


@interface API_POSTPM_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *    touid;
@property (nonatomic, retain) NSString              *    uid;
@property (nonatomic, retain) POSTPM                *    resp;
@property (nonatomic, retain) NSString              *    message;
@end

