//
//  collect.h
//  DZ
//
//  Created by PFei_He on 14-6-24.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h"

@interface COLLECT : BeeActiveObject
@property (nonatomic, retain) NSNumber      *ecode;
@property (nonatomic, retain) NSString      *emsg;
@property (nonatomic, retain) NSNumber      *favid;
@end

@interface API_COLLECT_SHOTS : BeeAPI

@property (nonatomic, copy)     NSString    *uid;               //用户id
@property (nonatomic, copy)     NSString    *tid;               //帖子id
@property (nonatomic, strong)   COLLECT     *resp;

@end
