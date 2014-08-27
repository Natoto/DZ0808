//
//  D1_ModifyPersonInfoViewController_iphone.h
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "ModifyPersonalInfoModel.h"
#import "profile.h"
#import "BeeUIBoard+ViewController.h"
@interface D1_ModifyPersonInfoViewController_iphone : UIViewController

//@property(nonatomic,strong) NSString * username;
//@property(nonatomic,strong) NSNumber * gender;
//@property(nonatomic,strong) NSNumber * birthday;
//@property(nonatomic,strong) NSNumber * birthmonth;
//@property(nonatomic,strong) NSNumber * birthyear;
//@property(nonatomic,strong) NSString * resideprovince;
//@property(nonatomic,strong) NSString * residecity;
@property(nonatomic,strong)PROFILE       * profile;
@property(nonatomic,strong)NSString      * username;
@property(nonatomic,strong)REQ_MODIFYPROFILE_SHOTS *modifyreq;
@property(nonatomic,strong)BeeUITextField * txtusername;
@property(nonatomic,strong)UILabel        * lblbirthyearmonth;
@property(nonatomic,strong)UILabel        * lblyourarea;
@property(nonatomic,strong)BeeUIImageView * imgavtor;
@property(nonatomic,assign)BOOL             firstLogin;
@end
