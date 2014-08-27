//
//  ModifyPersonalInfoModel.h
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "modifyPersonalInfo.h"
@interface ModifyPersonalInfoModel : BeeStreamViewModel
@property(nonatomic,strong)REQ_MODIFYPROFILE_SHOTS *modifyReq;
-(void)submitModifyInfo:(REQ_MODIFYPROFILE_SHOTS *)req;
@end
