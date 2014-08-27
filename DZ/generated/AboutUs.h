//
//  AboutUs.h
//  DZ
//
//  Created by PFei_He on 14-6-23.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h"

@interface AboutUs : NSObject

@end

@interface API_ABOUTUS_SHOTS : BeeAPI

@property (nonatomic, copy)     NSString            *uid;               //用户id
@property (nonatomic, copy)     NSString            *kw;                //关键字
@property (nonatomic, strong)   NSArray             *topics;
@property (nonatomic, strong)   AboutUs              *resp;

@end
