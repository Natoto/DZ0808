//
//  support.h
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h"
@interface SUPPORT : BeeActiveObject
@property (nonatomic, retain) NSNumber          *ecode;
@property (nonatomic, retain) NSString          *emsg;
@end

@interface API_SUPPORT_SHOTS : BeeAPI
@property (nonatomic, copy)     NSString        *uid;       //用户id
@property (nonatomic, copy)     NSString        * tid;
@property (nonatomic, copy)     NSString        * pid;
@property (nonatomic, copy)     NSString        * type;
@property (nonatomic, strong)   SUPPORT         * resp;
@end