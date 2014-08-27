//
//  D1_Msg_SystemViewController.m
//  DZ
//
//  Created by Nonato on 14-6-6.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_Msg_SystemViewController.h"
#import "D1_Msg_InstationTableViewCell.h"
#import "UserModel.h"
#import "RemindModel.h"
#import "D3_MSG_IgnoreView.h"
@interface D1_Msg_SystemViewController ()
@property(nonatomic,strong) D3_MSG_IgnoreView * headView;
@property(nonatomic,assign)BOOL ignoreMessage; 
@end

@implementation D1_Msg_SystemViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

ON_SIGNAL3(RemindModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(RemindModel, FAILED, signal)
{
    [self FinishedLoadData];
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
    self.title=@"系统消息";
    [self reframeTableView:TABLEVIEW_WITHSLIDSWITCH];
//    self.view.backgroundColor=[UIColor whiteColor];
    [self reframeTableView:TABLEVIEW_WITHSLIDSWITCH];
    self.remindmodel =[RemindModel modelWithObserver:self];
    self.remindmodel.uid=[UserModel sharedInstance].session.uid;
    
    self.ignoreMessage=[DZ_SystemSetting readIgnoreSetting:MSG_SYSTEM];
    if (!self.ignoreMessage) {
        [self.remindmodel loadCache];
        [self viewDidCurrentView];
    }
    _headView = [[D3_MSG_IgnoreView alloc] initWithFrame:CGRectMake(0, 0, 320, 40) sel:@selector(ignoreMessages) target:self];
    _headView.recievemessage = @"需要接受系统消息吗？";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
        _headView.ignoreLabel.text=@"需要接受系统消息吗？";
        [self.remindmodel.sysautomatic removeAllObjects];
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
    self.ignoreMessage = _headView.ignoreMessage;
    [DZ_SystemSetting saveIgnoreSetting:MSG_SYSTEM ignore:self.ignoreMessage];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    automatic *atopic=[self.remindmodel.sysautomatic objectAtIndex:indexPath.row];
    float height = [D1_Msg_InstationTableViewCell heightOfCell:atopic.note];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.remindmodel.sysautomatic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"ListViewCellId";
    D1_Msg_InstationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[D1_Msg_InstationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    automatic *atopic=[self.remindmodel.sysautomatic objectAtIndex:indexPath.row];
    if (atopic)
    {
         cell.txtMessage = [NSString stringWithFormat:@"%@",atopic.note];
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*automatic *atopic=[self.remindmodel.sysautomatic objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_Msg_SystemViewController:didSelectautomatic:)]) {
        [self.delegate D1_Msg_SystemViewController:self didSelectautomatic:atopic];
    }*/
}

//刷新调用的方法
-(void)refreshView{
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
