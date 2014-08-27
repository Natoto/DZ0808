//
//  modavatar.h
//  DZ
//
//  Created by Nonato on 14-5-19.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bee.h"
@interface MODAVATAR : NSObject
@property(nonatomic,strong)NSNumber * ecode;
@property(nonatomic,strong)NSString * emsg;
@property(nonatomic,strong)NSString * avatarurl;
@end

@interface API_MODAVATAR_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   uid;
@property(nonatomic,retain)   NSData                *   imageData;
@property (nonatomic, retain) MODAVATAR             *   resp;
@end


