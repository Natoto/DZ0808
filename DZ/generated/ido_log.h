//
//  ido_log.h
//  DZ
//
//  Created by Nonato on 14-7-28.
//
//
/*
 http://iquapp.com/web/log.php?ostype=1&appid=000000&appversion=V1.01.01&imei=864323020491222&mei=&ccid=&device=864323020491222
 
 {"emsg":"","ecode":0,"online":1}
 */
#import "Bee.h"
#import <Foundation/Foundation.h>

@interface IDO_LOG : BeeActiveObject
@property(nonatomic,retain)NSString * emsg;
@property(nonatomic,retain)NSString * ecode;
@property(nonatomic,retain)NSNumber * online;
@end

@interface API_IDO_LOG_SHOTS : BeeAPI
@property (nonatomic, copy)     NSString        * ostype;       //用户id
@property (nonatomic, copy)     NSString        * appid;
@property (nonatomic, copy)     NSString        * appviersion;
@property (nonatomic, copy)     NSString        * imei;
@property (nonatomic, copy)     NSString        * mei;
@property (nonatomic, copy)     NSString        * ccid;
@property (nonatomic, copy)     NSString        * device;
@property (nonatomic, strong)   IDO_LOG         * resp;
@end