//
//  registeruser.h
//  DZ
//
//  Created by Nonato on 14-5-13.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "bee.h"
#import <Foundation/Foundation.h>

@interface REGISTERUSER : NSObject
@property (nonatomic, retain) NSString *        uid;
@property (nonatomic, retain) NSString *		ecode;
@property (nonatomic, retain) NSString *		emsg;
@property(nonatomic,retain)   NSString *        account;
@end


@interface API_REGISTERUSER_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   email;
@property (nonatomic, retain) NSString              *   account;
@property (nonatomic, retain) NSString              *   passwd;
@property (nonatomic, retain) REGISTERUSER          *   resp;
@end

