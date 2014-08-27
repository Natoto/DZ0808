//
//  modifyPersonalInfo.h
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bee.h"
//modprofile

@interface MODIFYPROFILE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end


@interface REQ_MODIFYPROFILE_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSString *    uid;
@property (nonatomic, retain) NSNumber *    gender;
@property (nonatomic, retain) NSString *    resideprovince;
@property (nonatomic, retain) NSString *    residecity;
@property (nonatomic, retain) NSNumber *    birthmonth;
@property (nonatomic, retain) NSNumber *    birthday;
@property (nonatomic, retain) NSNumber *    birthyear;
@end

@interface API_MODIFYPROFILE_SHOTS : BeeRoutine
@property (nonatomic, retain) MODIFYPROFILE             *   resp;
@property (nonatomic, retain) REQ_MODIFYPROFILE_SHOTS   *	req;
@end
