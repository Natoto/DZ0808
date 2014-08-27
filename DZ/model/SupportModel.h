//
//  SupportModel.h
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//

#import "Bee_StreamViewModel.h"
#import "support.h"
@interface SupportModel : BeeStreamViewModel
@property (nonatomic, copy)     NSString        *uid;       //用户id
@property (nonatomic, copy)     NSString        * tid;
@property (nonatomic, copy)     NSString        * pid;
@property (nonatomic, copy)     NSString        * type;
@property (nonatomic, retain)   SUPPORT         * shots;
@end
