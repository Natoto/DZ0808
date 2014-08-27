//
//  D1_LoginBoard.h
//  DZ
//
//  Created by Nonato on 14-4-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_UIBoard.h"
#import "rmbdz.h"
#import "UserModel.h"
#import "Bee.h"
#import "UIViewController+ErrorTips.h"
#import "UserModel.h"
#import "BaseBoard_iPhone.h"
#define  USERNAMETAG 140929
#define  PASSWORDTAG 140930
@interface D1_LoginBoard_iphone : BaseBoard_iPhone
AS_SINGLETON(D1_LoginBoard_iphone)
AS_MODEL( UserModel, userModel)
@property(nonatomic,strong)BeeUITextField * username;
@property(nonatomic,strong)BeeUITextField * password;
 
@end
