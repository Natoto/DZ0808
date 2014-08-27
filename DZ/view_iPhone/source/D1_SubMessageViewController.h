//
//  D1_SubMessageViewController.h
//  DZ
//
//  Created by Nonato on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Base_TableviewController.h"
#import "AllpmModel.h"
@interface D1_SubMessageViewController : Base_TableviewController
@property(nonatomic,strong)AllpmModel *allpmmodel;

@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSNumber * nowdate;
-(void)viewDidCurrentView;

@end
