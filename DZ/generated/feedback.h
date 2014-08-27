//
//  feedback.h
//  DZ
//
//  Created by PFei_He on 14-6-23.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h"

@interface feedback : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@end

@interface API_FEEDBACK_SHOTS : BeeAPI

@property (nonatomic, copy)     NSString                *appId;
@property (nonatomic, assign)   float                    appVersion;
@property (nonatomic, copy)     NSString                *content;
@property (nonatomic, copy)     NSString                *QQ;
@property (nonatomic, strong)   feedback                *resp;

@end
