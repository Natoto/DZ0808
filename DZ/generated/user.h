//
//  user.h
//  DZ
//
//  Created by Nonato on 14-5-12.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import <Foundation/Foundation.h>

@interface LOGIN2 : BeeActiveObject
@property (nonatomic, retain) NSString *        uid;
@property (nonatomic, retain) NSString *		ecode;
@property (nonatomic, retain) NSString *		emsg;
@property(nonatomic,retain)   NSString *        account;
@end

 
@interface SESSION2 : NSObject
@property (nonatomic,retain)    NSString *        username;
@property (nonatomic,retain)    NSString *        password;
@property (nonatomic, retain)   NSString *        sid;
@property (nonatomic, retain)   NSString *        uid;
@property (nonatomic, retain)   NSString *        avatar;
@end

@interface REQ_LOGIN_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_LOGIN_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   username;
@property (nonatomic, retain) NSString              *   password;
@property (nonatomic, retain) LOGIN2                *   resp;
@property (nonatomic, retain) REQ_LOGIN_SHOTS       *	req;
@end
