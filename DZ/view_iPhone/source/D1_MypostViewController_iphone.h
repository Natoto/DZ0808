//
//  D1_MypostViewController_iphone.h
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Base_TableviewController.h"
#import "myPostModel.h"
@interface D1_MypostViewController_iphone : Base_TableviewController
@property(nonatomic,strong) myPostModel *postModel;
@property(nonatomic,strong) NSString    * uid;
@property(nonatomic,strong) NSString    * username;
@property(nonatomic,strong) NSString    * newtitle;
@end
