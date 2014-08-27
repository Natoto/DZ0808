//
//  sign.h
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//
//签到
#import <Foundation/Foundation.h>
#import "Bee.h"

@interface SIGN : BeeActiveObject
@property (nonatomic, retain) NSNumber          *ecode;
@property (nonatomic, retain) NSString          *emsg;
@property (nonatomic, retain) NSString          *reward;
@end

@interface API_SIGN_SHOTS : BeeAPI
@property (nonatomic, copy)     NSString        *uid;       //用户id
@property (nonatomic, copy)     NSString        * todaysay;
@property (nonatomic, copy)     NSString        * qdxq;
@property (nonatomic, strong)   SIGN            *resp;
@end

/*
 开心					kx
 难过					ng
 郁闷					ym
 无聊					wl
 怒					nu
 擦汗					ch
 奋斗					fd
 慵懒					yl
 衰					shuai
 */