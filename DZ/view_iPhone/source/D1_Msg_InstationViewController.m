//
//  D1_Msg_InstationViewController.m
//  DZ
//
//  Created by Nonato on 14-6-5.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "QCSlideSwitchView.h"
#import "D1_Msg_InstationViewController.h" 
#import "D1_Msg_StrangerTableViewCell.h"
#import "ToolsFunc.h"
#import "bee.h"
#import "RCLabel.h"
#import "AppBoard_iPhone.h"
#import "D3_MSG_IgnoreView.h"
#import "D1_FriendsTableViewCell.h"
#import "friends.h"
#import "D1_FriendsInfoViewController.h"
@interface D1_Msg_InstationViewController ()<D1_FriendsTableViewCellDelegate>
@property(nonatomic,assign)BOOL ignoreMessage;
@property(nonatomic,strong) D3_MSG_IgnoreView * headView;
@end

@implementation D1_Msg_InstationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

ON_SIGNAL3(AllpmModel, RELOADED, signal)
{
    BeeLog(@"%@",self.allpmmodel.systemms);
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(AllpmModel, FAILED, signal)
{
    [self FinishedLoadData];
}

- (void)viewDidCurrentView
{
   
}
-(void)dealloc
{
    [self.allpmmodel removeObserver:self];
}
-(void)viewWillLayoutSubviews//重新layout界面 针对越狱手机
{
//    self.tableViewList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);
//    [self relayoutSubviews];
}
- (void)viewDidLoad
{
    self.noFooterView=YES;
    [super viewDidLoad];
    [self reframeTableView:TABLEVIEW_WITHSLIDSWITCH]; 
    [self relayoutSubviews];
    self.title=@"站内信";
//    self.view.backgroundColor=[UIColor blueColor];
    self.ignoreMessage=[DZ_SystemSetting readIgnoreSetting:MSG_ZHANNEI];
    self.allpmmodel =[AllpmModel modelWithObserver:self];
    self.allpmmodel.uid=[UserModel sharedInstance].session.uid;
    self.allpmmodel.nowdate.nowdate=[NSNumber numberWithInt:1];
    
    if (!self.ignoreMessage)
    {
        [self.allpmmodel loadCache:MSG_HAOYOU];
        self.nowdate=nil;
        if (!self.allpmmodel.loaded) {
            [self.allpmmodel getALLMessageWithtype:MSG_ALL];
        }
        NSLog(@"加载为当前视图 = %@",self.title);
    }
    _headView = [[D3_MSG_IgnoreView alloc] initWithFrame:CGRectMake(0, 0, 320, 40) sel:@selector(ignoreMessages) target:self];
    _headView.recievemessage = @"需要接受站内信吗？";
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [D3_MSG_IgnoreView heightOfView];
}
-(IBAction)clearmessage:(id)sender
{
    [self.allpmmodel clearStrangersms];
    [self.allpmmodel getALLMessageWithtype:MSG_ALL];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    return [self shieldView:CGRectMake(0, 0, 320, 50)];
    
    return _headView;
}

-(void)ignoreMessages
{
    if (!_headView.ignoreMessage) {
        _headView.ignoreMessage = YES;
        [_headView.ignoreButton setTitle:@"点此开启" forState:UIControlStateNormal];
        _headView.ignoreLabel.text=@"需要接受站内信吗？";
        [self.allpmmodel.strangerms removeAllObjects];
    }
    else
    {
        _headView.ignoreMessage=NO;
        [_headView.ignoreButton setTitle:@"点此屏蔽" forState:UIControlStateNormal];
         _headView.ignoreLabel.text=@"不希望收到此消息?";
        [self.allpmmodel loadCache];
        [self.allpmmodel getALLMessageWithtype:MSG_ALL];
    }
    self.ignoreMessage = _headView.ignoreMessage;
    [self.tableViewList reloadData];
    [DZ_SystemSetting saveIgnoreSetting:MSG_ZHANNEI ignore:self.ignoreMessage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.allpmmodel.strangerms;
    int numberofrows = array.count;
    /*for ( int index = 0; index < array.count; index ++) {
        NSArray *array2 =[array objectAtIndex:index];
        for (int j = 0; j < array2.count; j++) {
            numberofrows ++;
        }
    }*/
    return numberofrows;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId2";
    D1_FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[D1_FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.havenewmessage =NO;
    }
    strangerms *stranger=[self astrangersms:self.allpmmodel.strangerms index:indexPath.row]; 
    friends *frd =[[friends alloc] init];
    frd.avatar = stranger.avatar;
    frd.username = stranger.author;
    frd.fuid = stranger.touid;
    cell.message.text = stranger.message;
 
    [cell setcellData:frd];
    return  cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [D1_FriendsTableViewCell heightOfFriendsCell];
}

-(strangerms *)astrangersms:(NSArray *)array index:(NSInteger )index
{
//    int numberofrows = 0;
    strangerms *ams= nil; //[[strangerms alloc] init];
    NSArray *array2 = [array objectAtIndex:index];
    if (array2.count) {
        ams = [array2 objectAtIndex:0];        
    }
    /*for (int i = 0; i < array.count; i ++) {
        NSArray *array2 =[array objectAtIndex:i];
        for (int j = 0; j < array2.count; j++) {
            if (index == numberofrows) {
                ams = [array2 objectAtIndex:j];
                return ams;
            }
            numberofrows ++;
        }
    }*/
    return ams;
}

/*
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    strangerms *apublic=[self astrangersms:self.allpmmodel.strangerms index:indexPath.row];
    return [D1_Msg_StrangerTableViewCell heightOfCell:apublic.message];
  
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_Msg_InstationViewController:cellSelectedWithStrangerms:)]) {
        strangerms *apublic=[self astrangersms:self.allpmmodel.strangerms index:indexPath.row];
        [self.delegate D1_Msg_InstationViewController:self cellSelectedWithStrangerms:apublic];
    }
}
#pragma mark - D1_FriendsTableViewCell delegate
-(void)D1_FriendsTableViewCell:(D1_FriendsTableViewCell *)cell avator:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_Msg_InstationViewController:D1_FriendsTableViewCell:avator:)]) {
        [self.delegate D1_Msg_InstationViewController:self D1_FriendsTableViewCell:cell avator:sender];
    }
}
//刷新调用的方法
-(void)refreshView
{
    if (!self.ignoreMessage)
    {
        [self.allpmmodel getALLMessageWithtype:MSG_ALL];
    }
    else
    {
        [self FinishedLoadData];
    }
}

//加载调用的方法
-(void)getNextPageView{
    if (self.allpmmodel.more) {
        [self removeFooterView];
        [self.allpmmodel nextPage];
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
