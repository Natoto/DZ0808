//
//  D1_Msg_SystemViewController.h
//  DZ
//
//  Created by Nonato on 14-6-6.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Base_TableviewController.h"
@class automatic;
@class D1_Msg_SystemViewController;
@protocol D1_Msg_SystemViewControllerDelegate <NSObject>
- (void)D1_Msg_SystemViewController:(D1_Msg_SystemViewController *)ctr  didSelectautomatic:(automatic *)automatic;
@end


@class RemindModel;
@interface D1_Msg_SystemViewController : Base_TableviewController
@property(nonatomic,strong)RemindModel  *remindmodel;
@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSNumber * nowdate;
@property(nonatomic,assign) NSObject <D1_Msg_SystemViewControllerDelegate> * delegate;
-(void)viewDidCurrentView;
@end
