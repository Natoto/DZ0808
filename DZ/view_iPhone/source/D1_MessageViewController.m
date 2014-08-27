//
//  B1_ATopicViewController.m
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_MessageViewController.h"
#import "AppBoard_iPhone.h"
#import "TopiclistModel.h"
#import "D1_Msg_FriendsInterViewController.h"
#import "D1_Msg_InstationViewController.h"
#import "D1_Msg_SystemViewController.h"
#import "D2_ChatViewController.h"
#import "friends.h"
#import "pinyin.h"
#import "D1_FriendsInfoViewController.h"
@interface D1_MessageViewController ()<D1_Msg_SystemViewControllerDelegate,D1_Msg_InstationViewControllerDelegate>

@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) NSArray *sections;
@property (nonatomic,retain) UITableView *list;
@end

@implementation D1_MessageViewController

#pragma mark -

//ON_LEFT_BUTTON_TOUCHED( signal )
//{
//    [self.stack popBoardAnimated:YES];
//}

#pragma mark - BeeFramework Macro

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initSVscrollview
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_6_1
#else
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    self.title =@"我的消息";
    _slideSwitchView=[[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height)];
    _slideSwitchView.slideSwitchViewDelegate=self;
    [self.view addSubview:_slideSwitchView];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
     UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
    self.slideSwitchView.tabItemSelectedColor = color; //[QCSlideSwitchView colorFromHexRGB:@"bb0b15"];
     UIImage *image = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    
     self.slideSwitchView.shadowImage = [image imageWithTintColor:color];
    
    self.vc1 = [[D1_Msg_FriendsInterViewController alloc] init];
    self.vc1.title=@"好友互动";

    self.vc2 = [[D1_Msg_InstationViewController alloc] init];
    self.vc2.delegate = self;
    self.vc2.title = @"站内信";
    
    self.vc3 =[[D1_Msg_SystemViewController alloc] init];
    self.vc3.title = @"系统消息";
 
    self.slideSwitchView.rigthSideButton = nil;
    [self.slideSwitchView buildUI];
   
    if ([RemindModel friendmessagecount]) {
        [self.slideSwitchView showRedPoint:0];
    }
    
    if ([RemindModel systemmessagecount]) {
          [self.slideSwitchView showRedPoint:2];
    }
}
-(void)dealloc
{
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initSVscrollview];
    self.navigationBarShown=YES;
    self.view.backgroundColor=[UIColor whiteColor];
//    self.allpmmodel=[AllpmModel modelWithObserver:self];
//    [self.allpmmodel firstPage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}

ON_SIGNAL3(AllpmModel, RELOADED, signal)
{
//    BeeLog(@"%@",self.allpmmodel);
}
#pragma mark - 子版块
-(void)QCListViewControllerDelegateCellSelectedWithFid:(NSString *)fid name:(NSString *)name
{
//    B1_ATopicViewController *board=[[B1_ATopicViewController alloc] init];
//    board.forum_fid=fid;
//    board.forum_name=name;
//    [self.navigationController pushViewController:board animated:YES];
}

-(CGSize)slideTabTextSize:(QCSlideSwitchView *)view
{
    return CGSizeMake((self.view.frame.size.width-20)/3, 44.);
}
#pragma mark -
#pragma mark 接受从子模块传过来的点击事件
-(void)topicViewControllerCellSelectedWithTid:(NSString *)tid
{
//    NSArray *array=[tid componentsSeparatedByString:@":"];
//    if (array.count) {
//        B3_PostViewController *board=[[B3_PostViewController alloc] init];
//        board.tid=[array objectAtIndex:1];
//        board.fid=[array objectAtIndex:0];
//        [self.navigationController pushViewController:board animated:YES];
//    }
}
-(void)setHaveSubForums:(BOOL)haveSubForums
{
//    _haveSubForums=haveSubForums;
//    [self.slideSwitchView  layoutSubviews];
}
/*
 *			author;
 @property (nonatomic, retain) NSString *			authorid;
 @property (nonatomic, retain) NSString *			avatar;
 
 
 @property (nonatomic, retain) NSString *			avatar;
 @property (nonatomic, retain) NSString *			fuid;
 @property (nonatomic, retain) NSString *			username;
 @property (nonatomic, retain) NSString *			pinyin;
 
 */
#pragma mark - 从站内信传出来的delegate
-(void)D1_Msg_InstationViewController:(D1_Msg_InstationViewController *)controller cellSelectedWithStrangerms:(strangerms *)astrangerms
{
    D2_ChatViewController *ctr=[[D2_ChatViewController alloc] init];
    friends  *afriend = [[friends alloc] init];
    afriend.avatar = astrangerms.avatar;
    afriend.fuid = astrangerms.touid;
    afriend.username = astrangerms.author;
    NSString *pinyin = [[NSString alloc] init];
    for (int i = 0; i < afriend.username.length; i++) {
        NSString *letter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([afriend.username characterAtIndex:i])] uppercaseString];
        pinyin = [pinyin stringByAppendingString:letter];
    }
    afriend.pinyin = pinyin;
    ctr.afriend = afriend;
    ctr.chattype = CHATTYPE_STRANGER;
    [self.navigationController  pushViewController:ctr animated:YES];
}

-(void)D1_Msg_InstationViewController:(D1_Msg_InstationViewController *)controller D1_FriendsTableViewCell:(D1_FriendsTableViewCell *)cell avator:(id)sender
{
    strangerms *stranger=[controller astrangersms:controller.allpmmodel.strangerms index:cell.indexPath.row];
    D1_FriendsInfoViewController *ctr=[[D1_FriendsInfoViewController alloc] init];
    ctr.uid=stranger.touid;
    [self.navigationController pushViewController:ctr animated:YES];
}
#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 3;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
    } else if (number == 2) {
        return self.vc3;
    }
    else {
        return nil;
    }
}

- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    //[self.navigationController popViewControllerAnimated:YES];
//    QCViewController *drawerController = (QCViewController *)self.navigationController.mm_drawerController;
//    [drawerController panGestureCallback:panParam];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
   
    if (number == 0) {
        D1_Msg_FriendsInterViewController *vc = nil;
        vc = self.vc1;
        [vc viewDidCurrentView];
    } else if (number == 1) {
        D1_Msg_InstationViewController *vc = nil;
        vc = self.vc2;
        [vc viewDidCurrentView];
    } else if (number == 2) {
        D1_Msg_SystemViewController *vc = nil;
        vc = self.vc3;
        vc.delegate = self;
        [vc viewDidCurrentView];
    }
}
-(void)D1_Msg_SystemViewController:(D1_Msg_SystemViewController *)ctr didSelectautomatic:(automatic *)automatic
{
//    D1_MSG_SYS_InfoViewController *msg_ctr =[[D1_MSG_SYS_InfoViewController alloc] init];
//    
//    [self.navigationController  pushViewController:msg_ctr animated:YES];
}

@end
