//
//  D1_ReplyViewController_iphone.m
//  DZ
//
//  Created by Nonato on 14-7-31.
//
//
#import "D1_MessageViewController.h"
#import "AppBoard_iPhone.h"
#import "D1_ReplyViewController_iphone.h"
#import "B3_PostViewController.h"
@interface D1_ReplyViewController_iphone ()<D1_Reply_MyViewControllerDelegate,D1_Reply_OtherViewControllerDelegate>

@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) NSArray *sections;
@property (nonatomic,retain) UITableView *list;

@end

@implementation D1_ReplyViewController_iphone

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
    self.title =@"回复";
    _slideSwitchView=[[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height)];
    _slideSwitchView.slideSwitchViewDelegate=self;
    [self.view addSubview:_slideSwitchView];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [DZ_SystemSetting sharedInstance].navigationBarColor;// FORUMCELLDIDADDHOMECOLOR; //[QCSlideSwitchView colorFromHexRGB:@"bb0b15"];
    UIImage *image = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                      stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    
    self.slideSwitchView.shadowImage = [image imageWithTintColor:[DZ_SystemSetting sharedInstance].navigationBarColor];
    
    self.vc1 = [[D1_Reply_MyViewController alloc] init];
    self.vc1.uid = self.uid;
    self.vc1.delegate = self;
    self.vc1.title=@"我的回复";
    
    self.vc2 = [[D1_Reply_OtherViewController alloc] init];
    self.vc2.uid = self.uid;
    self.vc2.delegate = self;
    self.vc2.title = @"别人的回复";

    self.slideSwitchView.rigthSideButton = nil;
    [self.slideSwitchView buildUI];
    
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
    return CGSizeMake((self.view.frame.size.width-20)/2, 44.);
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
#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 2;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
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
        D1_Reply_MyViewController *vc = nil;
        vc = self.vc1;
        vc.uid = self.uid;
        [vc viewDidCurrentView];
    } else if (number == 1) {
        D1_Reply_OtherViewController *vc = nil;
        vc = self.vc2;
        vc.uid = self.uid;
        [vc viewDidCurrentView];
    }
}
-(void)D1_Reply_MyViewController:(D1_Reply_MyViewController *)controller cellSelectedWithTid:(NSString *)tid
{
    B3_PostViewController *board=[[B3_PostViewController alloc] init];
    board.tid=tid;
    [self.navigationController pushViewController:board animated:YES];
}
-(void)D1_Reply_OtherViewController:(D1_Reply_OtherViewController *)controller cellSelectedWithTid:(NSString *)tid
{
    B3_PostViewController *board=[[B3_PostViewController alloc] init];
    board.tid=tid; //[array objectAtIndex:1];
    [self.navigationController pushViewController:board animated:YES];
}

//-(void)D1_Msg_SystemViewController:(D1_Msg_SystemViewController *)ctr didSelectautomatic:(automatic *)automatic
//{
//    D1_MSG_SYS_InfoViewController *msg_ctr =[[D1_MSG_SYS_InfoViewController alloc] init];
//    
//    [self.navigationController  pushViewController:msg_ctr animated:YES];
//}


@end
