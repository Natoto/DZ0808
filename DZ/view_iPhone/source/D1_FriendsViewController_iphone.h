//
//  D1_FriendsViewController_iphone.h
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Base_TableviewController.h"
#import "FriendsModel.h"
#import "D0_Mine_iphone.h"
@class D0_Mine_iphone;
@interface D1_FriendsViewController_iphone : Base_TableviewController
@property(nonatomic,strong) FriendsModel *myfriendsModel;
@property(nonatomic,strong) NSString    * uid;
@property(nonatomic,strong) NSString    * username;
@property(nonatomic,strong) NSString    * newtitle;
@property(nonatomic,assign) D0_Mine_iphone * delegate;
@end
