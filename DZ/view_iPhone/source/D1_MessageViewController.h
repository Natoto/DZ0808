//
//  B1_ATopicViewController.h
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "rmbdz.h"
#import "SubForumsModel.h"
#import "PostlistModel.h"
#import "TopiclistModel.h"
#import "Bee_UIBoard.h"
#import "forumlist.h" 

#import "QCSlideSwitchView.h"
#import "B2_QCListViewController.h"
#import "QCViewController.h" 
#import "UIImage+Tint.h"

@class D1_Msg_SystemViewController;
@class D1_Msg_FriendsInterViewController;
@class D1_Msg_InstationViewController;
@class B0_ForumPlates_iphone;
@class B2_QCListViewController;

@interface D1_MessageViewController : UIViewController <QCSlideSwitchViewDelegate,QCListViewControllerDelegate>
{
    QCSlideSwitchView *_slideSwitchView;
    D1_Msg_FriendsInterViewController  *_vc1;
    D1_Msg_InstationViewController     *_vc2;
    D1_Msg_SystemViewController *_vc3;
} 
@property (nonatomic, strong) QCSlideSwitchView    *slideSwitchView;
@property (nonatomic, strong) D1_Msg_FriendsInterViewController  * vc1;
@property (nonatomic, strong) D1_Msg_InstationViewController  * vc2;
@property (nonatomic, strong) D1_Msg_SystemViewController  * vc3;
//@property (nonatomic, strong) AllpmModel                   * allpmmodel;

@end
