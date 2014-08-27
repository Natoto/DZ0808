//
//  D1_CollectionViewController.h
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base_TableviewController.h"
#import "collectionModel.h"
@interface D1_CollectionViewController_iphone : Base_TableviewController
@property(nonatomic,strong) collectionModel *collectModel;
@property(nonatomic,strong) NSString * uid;
@property(nonatomic,strong) NSString    * username;
@property(nonatomic,strong) NSString    * newtitle;
@end
