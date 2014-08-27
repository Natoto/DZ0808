//
//  delcollection.h
//  DZ
//
//  Created by PFei_He on 14-7-3.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h"

@interface DELCOLLECTION : BeeActiveObject
@property (nonatomic, retain) NSNumber          *ecode;
@property (nonatomic, retain) NSString          *emsg;
@end

@interface API_DELCOLLECTION_SHOTS : BeeAPI

@property (nonatomic, copy)     NSString        *uid;       //用户id
@property (nonatomic, strong)   NSNumber        *favid;     //收藏id
@property (nonatomic, strong)   DELCOLLECTION   *resp;

@end
