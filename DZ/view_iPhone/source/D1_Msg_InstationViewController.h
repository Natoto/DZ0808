//
//  D1_Msg_InstationViewController.h
//  DZ
//
//  Created by Nonato on 14-6-5.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Base_TableviewController.h"
#import "AllpmModel.h"
#import "D1_FriendsTableViewCell.h"

@class D1_Msg_InstationViewController;
@protocol D1_Msg_InstationViewControllerDelegate <NSObject>
- (void)D1_Msg_InstationViewController:(D1_Msg_InstationViewController *)controller cellSelectedWithStrangerms:(strangerms *)astrangerms;

-(void)D1_Msg_InstationViewController:(D1_Msg_InstationViewController *)controller D1_FriendsTableViewCell:(D1_FriendsTableViewCell *)cell avator:(id)sender;
@end

@interface D1_Msg_InstationViewController : Base_TableviewController

@property(nonatomic,assign)NSObject <D1_Msg_InstationViewControllerDelegate> *delegate;
@property(nonatomic,strong)AllpmModel *allpmmodel;
@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSNumber * nowdate;
-(void)viewDidCurrentView;
-(strangerms *)astrangersms:(NSArray *)array index:(NSInteger )index;
@end
