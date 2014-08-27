//
//  SignModel.h
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//

#import "Bee_StreamViewModel.h"
#import "sign.h"
@interface SIGNRECORD : NSObject //记录签到
@property (nonatomic, strong)     NSString        * uid;       //用户id
@property (nonatomic, strong)     NSString        * todaysay;
@property (nonatomic, strong)     NSString        * qdxq;
@property (nonatomic, strong)     NSString        * signDay;
@end

@interface SignModel : BeeStreamViewModel
@property (nonatomic, copy)     NSString        * uid;       //用户id
@property (nonatomic, copy)     NSString        * todaysay;
@property (nonatomic, copy)     NSString        * qdxq;
@property (nonatomic, retain)     SIGN            * shots;
+(BOOL)canSignCheckin;
@end
