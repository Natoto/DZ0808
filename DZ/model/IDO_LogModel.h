//
//  IDO_LogModel.h
//  DZ
//
//  Created by Nonato on 14-7-28.
//
//

#import "Bee_StreamViewModel.h"
#import "ido_log.h"
@interface IDO_LogModel : BeeStreamViewModel
@property (nonatomic, copy)     NSString        * ostype;       //
@property (nonatomic, copy)     NSString        * appid;
@property (nonatomic, copy)     NSString        * appversion;
@property (nonatomic, copy)     NSString        * imei;
@property (nonatomic, copy)     NSString        * mei;
@property (nonatomic, copy)     NSString        * ccid;
@property (nonatomic, copy)     NSString        * device;
@property (nonatomic, retain)   IDO_LOG          * shots;
@end
