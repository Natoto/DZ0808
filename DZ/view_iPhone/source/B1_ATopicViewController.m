//
//  B1_ATopicViewController.m
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "ToolsFunc.h"
#import "B1_ATopicViewController.h"
#import "AppBoard_iPhone.h"
#import "TopiclistModel.h"
#import "B2_SearchViewController.h"

@interface B1_ATopicViewController () <B2_TopicViewControllerDelegate>

@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) NSArray *sections;
@property (nonatomic,retain) UITableView *list;
@end

@implementation B1_ATopicViewController

#pragma mark -

//ON_LEFT_BUTTON_TOUCHED( signal )
//{
//    [self.stack popBoardAnimated:YES];
//}

#pragma mark - BeeFramework Macro

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    BeeLog(@"搜索------");
    B2_SearchViewController *searchctr=[[B2_SearchViewController alloc] init];
    [self.navigationController pushViewController:searchctr animated:YES];
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
    self.title =self.forum_name;
    _slideSwitchView=[[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height)];
    _slideSwitchView.slideSwitchViewDelegate=self;
    [self.view addSubview:_slideSwitchView];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
     UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
    self.slideSwitchView.tabItemSelectedColor = color;//[QCSlideSwitchView colorFromHexRGB:@"139AF2"];
    UIImage *image = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
   
     self.slideSwitchView.shadowImage = [image imageWithTintColor:color];
    self.vc3 = [[B2_TopicViewController2 alloc] init];
    self.vc3.topic_type=@"1";
    self.vc3.topicvcdelegate=self;
    self.vc3.forum_fid=self.forum_fid;
    self.vc3.title = @"精华";
    
    self.vc4 = [[B2_TopicViewController2 alloc] init];
    self.vc4.topic_type=@"2";
    self.vc4.topicvcdelegate=self;
    self.vc4.forum_fid=self.forum_fid;
    self.vc4.title = @"置顶";
    
    self.vc5 = [[B2_QCListViewController alloc] init];
    self.vc5.title = @"子版块";
    self.vc5.delegate=self;
    self.vc5.childAry=self.childAry;
    
    self.vc1 = [[B2_TopicViewController2 alloc] init];
    self.vc1.topic_type = @"0";
    self.vc1.forum_fid = self.forum_fid;self.vc1.title = @"全部";
    self.vc1.topicvcdelegate = self;
    
    self.vc2 =[[B2_TopicViewController2 alloc] init];
    self.vc2.topic_type=@"3";
    self.vc2.forum_fid=self.forum_fid;
    self.vc2.title = @"热帖";
    self.vc2.topicvcdelegate=self;
    
//    self.vc6 = [[QCListViewController alloc] init];
//    self.vc6.title = @"清幽Saup";
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage bundleImageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage bundleImageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
    rightSideButton.userInteractionEnabled = NO;
    self.slideSwitchView.rigthSideButton = rightSideButton;
    [self.slideSwitchView buildUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSVscrollview];
    [BeeUINavigationBar setButtonSize:CGSizeMake(30, 30)];
//    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back"]];
    [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage bundleImageNamed:@"sousuo.jpg"]];
    self.navigationBarShown=YES;
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}

#pragma mark - 子版块
- (void)QCListViewControllerDelegateCellSelectedWithFid:(NSString *)fid name:(NSString *)name
{
    B1_ATopicViewController *board=[[B1_ATopicViewController alloc] init];
    board.forum_fid = fid;
    board.forum_name = name;
    [self.navigationController pushViewController:board animated:YES];
}

#pragma mark -
#pragma mark 接受从子模块传过来的点击事件
- (void)topicViewControllerCellSelectedWithTid:(NSString *)tid
{
    NSArray *array=[tid componentsSeparatedByString:@":"];
    if (array.count) {
        B3_PostViewController *board = [[B3_PostViewController alloc] init];
        board.tid = [array objectAtIndex:1];
        board.fid = [array objectAtIndex:0];
        [self.navigationController pushViewController:board animated:YES];
    }
}
- (void)setHaveSubForums:(BOOL)haveSubForums
{
    _haveSubForums = haveSubForums;
    [self.slideSwitchView  layoutSubviews];
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return _haveSubForums ? 5 : 4;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
    } else if (number == 2) {
        return self.vc3;
    } else if (number == 3) {
         self.slideSwitchView.rigthSideButton.hidden=YES;
        return self.vc4;
    } else if (number == 4) {
       self.slideSwitchView.rigthSideButton.hidden=NO;
        return self.vc5;
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
        B2_TopicViewController2 *vc = nil;
        vc = self.vc1;
        [vc viewDidCurrentView];
    } else if (number == 1) {
        B2_TopicViewController2 *vc = nil;
        vc = self.vc2;
        [vc viewDidCurrentView];
    } else if (number == 2) {
        B2_TopicViewController2 *vc = nil;
        vc = self.vc3;
        [vc viewDidCurrentView];
    } else if (number == 3) {
        B2_TopicViewController2 *vc = nil;
        vc = self.vc4;
        [vc viewDidCurrentView];
    } else if (number == 4) {
        B2_QCListViewController *vc=nil;
        vc = self.vc5;
        vc.childAry=self.childAry;
    }
}

@end
