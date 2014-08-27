//
//  ModeavatarModel.h
//  DZ
//
//  Created by Nonato on 14-5-19.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "modavatar.h"
@interface ModeavatarModel : BeeStreamViewModel
@property(nonatomic,strong)NSString  * uid;
@property(nonatomic,strong)NSData    * imgdata;
@property(nonatomic,strong)MODAVATAR * modavatar;
@end
