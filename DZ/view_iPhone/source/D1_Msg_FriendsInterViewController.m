//
//  D1_SubMessageViewController.m
//  DZ
//
//  Created by Nonato on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "D1_FriendsInteractTableViewCell.h"
#import "D1_Msg_FriendsInterViewController.h"
#import "Bee.h"
#import "ToolsFunc.h"
#import "UserModel.h"
#import "AddfriendModel.h"
#import "D3_MSG_IgnoreView.h"

@interface D1_Msg_FriendsInterViewController ()<D1_FriendsInteractTableViewCellDelegate>
@property(nonatomic,strong) D3_MSG_IgnoreView * headView;
@property(nonatomic,assign) BOOL ignoreMessage;
@property(nonatomic,strong)AddfriendModel * addfrdModel;

@end

@implementation D1_Msg_FriendsInterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

ON_SIGNAL3(RemindModel, FAILED, signal)
{
    NSString *msg = [NSString stringWithFormat:@"%@",signal.object];
    [self presentFailureTips:msg];
    [self FinishedLoadData];
}
ON_SIGNAL3(RemindModel, RELOADED, signal)
{ 
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

-(void)dealloc
{
    [self.remindmodel removeObserver:self];
    [self.addfrdModel removeObserver:self];
}
- (void)viewDidCurrentView
{
    if (!self.remindmodel.loaded) {
//        [self.remindmodel firstPage];
    }
    NSLog(@"加载为当前视图 = %@",self.title);
}
-(void)viewWillAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    self.noHeaderFreshView = YES;
    self.noFooterView=YES;
    [super viewDidLoad];
    self.addfrdModel = [AddfriendModel modelWithObserver:self];
    self.title=@"好友互动";
//    self.view.backgroundColor=[UIColor whiteColor]; 
    [self reframeTableView:TABLEVIEW_WITHSLIDSWITCH];
    self.remindmodel =[RemindModel modelWithObserver:self];
    self.remindmodel.uid=[UserModel sharedInstance].session.uid;
    self.headView.ignoreMessage=[DZ_SystemSetting readIgnoreSetting:MSG_FRIENDS];
    
    if (!self.ignoreMessage) {
        self.remindmodel.uid = [UserModel sharedInstance].session.uid;
        [self.remindmodel loadCache];
        [self viewDidCurrentView];
    }
    _headView = [[D3_MSG_IgnoreView alloc] initWithFrame:CGRectMake(0, 0, 320, 40) sel:@selector(ignoreMessages) target:self];
    _headView.recievemessage = @"需要接受好友互动吗？";
}

-(UIView *)shieldView:(CGRect)frame
{
    UIView *headView=[[UIView alloc] initWithFrame:frame];
    headView.backgroundColor=[UIColor whiteColor];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(200, 10, 80, 30);
    [button setTitle:@"点此屏蔽" forState:UIControlStateNormal];
     UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
    [button setTitleColor:color forState:UIControlStateNormal];
    [headView addSubview:button];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 30)];
    label.text=@"不希望收到此消息?";
    [headView addSubview:label];
    return headView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headView;
}

-(void)ignoreMessages
{
    if (!_headView.ignoreMessage) {
        _headView.ignoreMessage = YES;
        [_headView.ignoreButton setTitle:@"点此开启" forState:UIControlStateNormal];
        _headView.ignoreLabel.text=@"需要接受好友互动吗？";
        [self.remindmodel.friendsautomatic removeAllObjects];
        [self.tableViewList reloadData];
    }
    else
    {
        _headView.ignoreMessage=NO;
        [_headView.ignoreButton setTitle:@"点此屏蔽" forState:UIControlStateNormal];
        _headView.ignoreLabel.text=@"不希望收到此消息?";
        [self.remindmodel loadCache];
        [self.remindmodel firstPage];
    }
    self.ignoreMessage =  _headView.ignoreMessage;
    [DZ_SystemSetting saveIgnoreSetting:MSG_FRIENDS ignore:self.ignoreMessage];
}


-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [D3_MSG_IgnoreView heightOfView];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return [D1_FriendsInteractTableViewCell heightOfD1_FriendsInteractTableViewCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.remindmodel.friendsautomatic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    D1_FriendsInteractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[D1_FriendsInteractTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImage *image=[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(320, 10)];
        cell.backgroundImage = image;

    }
   automatic *atopic = [self.remindmodel.friendsautomatic objectAtIndex:indexPath.row];
   if (atopic) {
       [cell dataChange:atopic];
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - D1_FriendsInteractTableViewCellDelegate
-(void)addFriend:(D1_FriendsInteractTableViewCell *)cell
{
    self.addfrdModel.fid = cell.atopic.authorid;
    self.addfrdModel.uid= [UserModel sharedInstance].session.uid;
    [self.addfrdModel firstPage];
}

ON_SIGNAL3(AddfriendModel, RELOADED, signal)
{
    [self presentSuccessTips:@"添加成功"];
}

ON_SIGNAL3(AddfriendModel, FAILED, signal)
{
    [self presentSuccessTips:signal.object];
}

//刷新调用的方法
-(void)refreshView{
    [self FinishedLoadData];
//    [self.remindmodel firstPage];
}

//加载调用的方法
-(void)getNextPageView{
    if (self.remindmodel.more) {
        [self removeFooterView];
        [self.remindmodel nextPage];
    }
    else
    {
        [self removeFooterView];
        [self finishReloadingData];
        [self presentMessageTips:@"没有更多的了"];
    }
    [self FinishedLoadData];
}

@end
