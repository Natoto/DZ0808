//
//  signout.h
//  DZ
//
//  Created by Nonato on 14-5-13.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import <Foundation/Foundation.h>

@interface LOGOUT : BeeActiveObject
@property (nonatomic, retain) NSString *		ecode;
@property (nonatomic, retain) NSString *		emsg;
@end
 

@interface API_LOGOUT_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   uid;//需要加密
@property (nonatomic, retain) LOGOUT               *   resp;

@end