//
//  D0_MINE.m
//  DZ
//
//  Created by Nonato on 14-4-1.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "AppBoardTab_iPhone.h"
#import "D0_Mine_iphone.h"
#import "PullLoader.h"
#import "D0_ProfileCell_Header.h"
#import "D0_Mine_iphone.h"
#import "D0_Minetools_iphone.h"
#import "UserModel.h"
#import "D2_SettingBoard_iphone.h"
#import "D1_ModifyPersonInfoViewController_iphone.h"
#import "D2_Feedback.h"
#import "D2_Share.h"
//#import "D1_Reply_MyViewController.h"
#import "D1_ReplyViewController_iphone.h"
#import "D1_MessageViewController.h"
#import "AllpmModel.h"
#import "D0_CheckinsView.h"
#import "SignModel.h"
#import "DZ_PopupBox.h"
//#import "DZ_Timer.h"
@interface D0_Mine_iphone ()<UITableViewDataSource,UITableViewDelegate,D0_CheckinsViewDelegate,DZ_PopupBoxDelegate>
{
    NSArray *Toolsarray;
    NSArray *ToolsIcon; 
}
@property(nonatomic,retain)D0_CheckinsView * qiandaoview;
@property(nonatomic,retain)DZ_PopupBox     * wealthBox;
@property(nonatomic,assign)BOOL              reloading;
@property(nonatomic,retain)UIButton        * qiandaoBtn;
@end

@implementation D0_Mine_iphone
DEF_SINGLETON(D0_Mine_iphone)

DEF_MODEL(UserModel,  lginModel);

-(void)load
{
    self.lginModel	= [UserModel modelWithObserver:self];
    self.lginModel.saveUser = YES;
    [self.lginModel load]; 
    [self observeNotification:BeeReachability.CHANGED];
    self.noFooterView = YES;
}


- (void)unload
{
    [self unobserveAllNotifications];
    [self.lginModel removeObserver:self];
    [self.remindModel removeObserver:self];
	self.lginModel	= nil;
    self.remindModel=nil;
}

ON_WILL_APPEAR(signal)
{

}

ON_DID_APPEAR( signal )
{
    [bee.ui.appBoard showTabbar];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    if (!self.LoginSuccess) {
//        [[UserModel sharedInstance] reload];
//        [bee.ui.appBoard showTabbar];
//    }
//}

#pragma mark - 去签到

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    if (![UserModel sharedInstance].profile.hassignplugin.intValue) {
        return ;
    }
    if (![UserModel sharedInstance].profile.issign.intValue) {
        if (!self.qiandaoview) {
            CGRect rect = [UIScreen mainScreen].bounds;
            D0_CheckinsView *qiandaoview = [[D0_CheckinsView alloc] initWithFrame:rect];
            qiandaoview.delegate = self;
            self.qiandaoview = qiandaoview;
        }
        [self.qiandaoview show];
   }
    else
    {
         [self presentMessageTips:@"今日已签到，明天再来吧!"];
    }
}
-(void)toEditPage
{
    if (self.lginModel.session)
    {
        SESSION2 *session=[self.lginModel session];
        if (session.uid) {
            D1_ModifyPersonInfoViewController_iphone *ctr=[[D1_ModifyPersonInfoViewController_iphone alloc] init];
            ctr.username=[UserModel sharedInstance].session.username;
            ctr.profile=self.lginModel.profile;
            ctr.navigationBarTitle = @"个人资料";
            [self.navigationController  pushViewController:ctr animated:YES];
        }
    }
}


ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        
        [self.remindModel loadCache];
        Toolsarray = [NSArray arrayWithObjects:@"设置", @"分享应用", @"用户反馈", nil];
        ToolsIcon = [NSArray arrayWithObjects:@"shezi", @"fenxiang", @"yonghufankui@2x.jpg", nil];
       
        [self.list setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        if (!self.LoginSuccess) {
            [[UserModel sharedInstance] reload];
        }
        [self refreshView];
    }
    else if ([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
        BeeLog(@"%f %f", self.bounds.size.height - bee.ui.tabbar.height);
        self.list.frame = CGRectMake(0, 0, self.bounds.size.width, self.frame.size.height - TAB_HEIGHT); 
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.LoginSuccess)
        return Toolsarray.count + 2;
    else
        return Toolsarray.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 240;
    }
    else if(indexPath.row >= 1 && indexPath.row <= Toolsarray.count)
    {
        return 50;
    }
    else
        return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *Identifier = @"headerCell";
        D0_ProfileCell_Header *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (!cell) {
            cell=[[D0_ProfileCell_Header alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.lginModel.session) {
            cell.usermodel = self.lginModel;
            [cell newmessage:self.remindModel.dialog.count];
            
        }
        else
        {
            cell.usermodel = nil;
        }
        [cell dataDidChanged];
        return cell;
    }
    else if(indexPath.row >= 1 && indexPath.row <= Toolsarray.count)
    {
        static NSString *Identifier = @"Cell";
        D0_MineTools_iphone *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        
        if (!cell) {
            cell=[[D0_MineTools_iphone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.data = [Toolsarray objectAtIndex:indexPath.row - 1];
        cell.name.text = [Toolsarray objectAtIndex:indexPath.row - 1];
        cell.name.font = [UIFont systemFontOfSize:15];
        cell.avatar.image = [UIImage bundleImageNamed:[ToolsIcon objectAtIndex:indexPath.row - 1]];
        return cell;
    }
    else
    {
        static NSString *Identifier=@"loggoutCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];        
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIButton *logoutBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//            logoutBtn.frame=CGRectMake(15, 10, self.bounds.size.width-30, 35);
            logoutBtn.frame = CGRectMake(20, 15, 280, 45);
            [cell.contentView addSubview:logoutBtn];
            [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
            logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [logoutBtn addTarget:self action:@selector(logoutBtnTap:) forControlEvents:UIControlEventTouchUpInside];
            [logoutBtn setBackgroundColor:[UIColor colorWithRed:227/255.0 green:221/255.0 blue:220/255.0 alpha:1]];
            [logoutBtn setTitleColor:KT_HEXCOLOR(0x0) forState:UIControlStateNormal];
            KT_CORNER_RADIUS(logoutBtn, 3);
        }    
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0 && indexPath.row <= Toolsarray.count) {
        D0_MineTools_iphone *cell = (D0_MineTools_iphone *)[tableView cellForRowAtIndexPath:indexPath];
//        cell.avatar.image = [UIImage bundleImageNamed:[ToolsSelectIcon objectAtIndex:indexPath.row - 1]];
//        cell.name.textColor = KT_HEXCOLOR(0x00acf5);
        cell.name.font = [UIFont systemFontOfSize:15];
        
        NSString *sometype=cell.name.text;
        if ([sometype isEqualToString:@"设置"]) {
            BeeLog(@"cell BUTTON 点击 设置");
             D2_SettingBoard_iphone *board = [[D2_SettingBoard_iphone alloc] init];
           [self.navigationController pushViewController:board animated:YES]; 
        }
        else if ([sometype isEqualToString:@"分享应用"])
        {
            BeeLog(@"cell BUTTON 点击 分享应用");
            
            D2_Share *share = [[D2_Share alloc] init];
            [self.navigationController pushViewController:share animated:YES];
//            [self presentMessageTips:@"该功能暂未开放"];
        }
        else if ([sometype isEqualToString:@"用户反馈"])
        {
            BeeLog(@"cell BUTTON 点击 用户反馈");
            
            D2_Feedback *feedback = [[D2_Feedback alloc] init];
            [self.navigationController pushViewController:feedback animated:YES];
        }
        else if ([sometype isEqualToString:@"版本升级"])
        {
            BeeLog(@"cell BUTTON 点击 版本升级");
        }
        else if ([sometype isEqualToString:@"注销"])
        {
            BeeLog(@"cell BUTTON 点击 注销");
            
        }

    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0 && indexPath.row<=Toolsarray.count)
    {
        D0_MineTools_iphone *cell=(D0_MineTools_iphone *)[tableView cellForRowAtIndexPath:indexPath];
        cell.avatar.image=[UIImage bundleImageNamed:[ToolsIcon objectAtIndex:indexPath.row-1]];
        cell.name.textColor=KT_HEXCOLOR(0x0);
        
    }
}


- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark - 登录注销
ON_SIGNAL3(D0_ProfileCell_Header, login, signal)//登录
{
      [bee.ui.appBoard showLogin];
}

#pragma mark - 注销
-(IBAction)logoutBtnTap:(id)sender
{
    self.lginModel	= [UserModel modelWithObserver:self];
    [self.lginModel  kickout];
    [self presentLoadingTips:__TEXT(@"signout")];
    
}
ON_SIGNAL3(D0_ProfileCell_Header, profileinfo, signal)
{
    if (!self.lginModel.session) {
        SESSION2 *session=[self.lginModel readsession:nil];
        if (session.username) {            
//            [self.lginModel signinWithUser:session.username password:session.password];
//            [self presentLoadingTips:@"登录中..."];
        }
    }
    else
    {
        [self toEditPage];
    }
}

-(void)DZ_PopupBox:(DZ_PopupBox *)view MaskViewDidTaped:(id)object
{
    [self.wealthBox hide];
}
#pragma mark - goto goto

/*
 财富
 */

ON_SIGNAL3(D0_ProfileCell_Header, wealth, signal)
{
    CGRect rect = [UIScreen mainScreen].bounds;
    DZ_PopupBox *PopupBox = [[DZ_PopupBox alloc] initWithFrame:rect];
    PopupBox.ppboxdelegate = self;
    PopupBox.title = @"我的财富";
    [PopupBox show];
    self.wealthBox = PopupBox;
    
    PROFILE *profile =[UserModel sharedInstance].profile;
    /*
     contribution
     ;
     prestige
     credits",@"money",@"prestige",@"contribution
     */
    NSArray * keys =[NSArray arrayWithObjects:@"积分",@"金钱",@"威望",@"贡献", nil];
    NSString * credits= [NSString stringWithFormat:@"%@",profile.credits];
    NSString * contribution = [NSString stringWithFormat:@"%@",profile.contribution];
    NSString * prestige = [NSString stringWithFormat:@"%@",profile.contribution];
    NSString * money = [NSString stringWithFormat:@"%@",profile.money];
    NSArray * values = [NSArray arrayWithObjects:credits,money,prestige,contribution, nil];
    
    NSMutableDictionary *diction=[[NSMutableDictionary  alloc] initWithCapacity:0];
    [diction setObject:values[0] forKey:keys[0]];
    [diction setObject:values[1] forKey:keys[1]];
    [diction setObject:values[2] forKey:keys[2]];
    [diction setObject:values[3] forKey:keys[3]];
    [PopupBox loadDatas:diction];
    
//    [UserModel sharedInstance] updateProfile
}
ON_SIGNAL3(D0_ProfileCell_Header, gotosendhtml, signal)
{
    D1_MypostViewController_iphone *ctr=[[D1_MypostViewController_iphone alloc] init];
    ctr.uid = [UserModel sharedInstance].session.uid;
    [self.navigationController  pushViewController:ctr animated:YES];
}

ON_SIGNAL3(D0_ProfileCell_Header, gotofriend, signal)
{
    D0_ProfileCell_Header *cell =(D0_ProfileCell_Header *)[self.list cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [cell newmessage:0];
    D1_FriendsViewController_iphone *ctr=[[D1_FriendsViewController_iphone alloc] init];
    ctr.uid = [UserModel sharedInstance].session.uid;
    
    [self.navigationController  pushViewController:ctr animated:YES];
}
/*
 签到
 */
ON_SIGNAL3(D0_ProfileCell_Header, gotoqiandao, signal)
{
    
}

-(void)D0_CheckinsView:(D0_CheckinsView *)view signsuccess:(BOOL)success message:(NSString *)message
{
    if (success) {
        [UserModel sharedInstance].profile.issign=[NSNumber numberWithInt:1];
        [self presentMessageTips:[NSString stringWithFormat:@"签到成功！%@",message]];
        [self.qiandaoview hide];
        [BeeUINavigationBar setButtonSize:CGSizeMake(50, 30)];
        [self showBarButton:BeeUINavigationBar.RIGHT title:@"已签到" titlecolor:CLR_BUTTON_TXT];
        self.qiandaoview = nil;
    }
}

-(void)D0_CheckinsView:(D0_CheckinsView *)view MaskViewDidTaped:(id)object
{
    [self.qiandaoview hide];
}

ON_SIGNAL3(D0_ProfileCell_Header, gotomessage, signal)
{
    D1_MessageViewController *ctr=[[D1_MessageViewController alloc] init];
    [self.navigationController  pushViewController:ctr animated:YES];
}

ON_SIGNAL3(D0_ProfileCell_Header, gotoreply, signal)
{
    D1_ReplyViewController_iphone *ctr=[[D1_ReplyViewController_iphone alloc] init];
    ctr.uid = [UserModel sharedInstance].session.uid;
    [self.navigationController  pushViewController:ctr animated:YES];
     
}
ON_SIGNAL3(D0_ProfileCell_Header, gotocollect, signal)
{
    D1_CollectionViewController_iphone *collectctr=[[D1_CollectionViewController_iphone alloc] init];
    collectctr.uid = [UserModel sharedInstance].session.uid;
    [self.navigationController  pushViewController:collectctr animated:YES];
}

#pragma mark - E0_ProfileCell_iPhone
ON_SIGNAL3( D0_MineTools_iphone, BUTTONTAP, signal )
{
   
    
}

#pragma mark -

- (void)updateState
{
	if ( [UserModel online] )
	{
		[[UserModel sharedInstance] updateProfile];
        self.LoginSuccess=YES;
		if ( ![UserModel sharedInstance].loaded )
        { 
        }
	}
	else
	{
        if ( ![UserModel sharedInstance].loaded )
        {
        }
        self.LoginSuccess=NO;
        [self finishReloadingData];
	}
}

/*
ON_MESSAGE3( API, login, msg )
{
    if ( msg.sending )
	{
		[self presentLoadingTips:__TEXT(@"signing_in")];
	}
	else if(msg.succeed)
	{
//        [self.lginModel  setOnline:YES];
        [self.list reloadData];
		[self dismissTips];
	}
    else if(msg.failed)
    {
        [self.list reloadData];
    }
}*/

#pragma mark -获得通知登录成功

ON_SIGNAL3(UserModel, LOGIN_FAILED, signal)
{
//    [self dismissTips];
    [self finishReloadingData];
//    [self presentMessageTips:[NSString stringWithFormat:@"%@",signal.object]];
}

ON_SIGNAL3(UserModel, LOGIN_RELOADED, signal)
{
//    if ([UserModel sharedInstance].session.username == nil)
//        self.navigationBarTitle = @"我的";
//    else
     self.navigationBarTitle = [UserModel sharedInstance].session.username ;
     [self dismissTips];
     [self updateState];
//    [self presentMessageTips:@"登录成功"];
}

ON_SIGNAL3(UserModel, LOGOUT_FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:@"注销失败"];
}

ON_SIGNAL3(UserModel, LOGOUT_RELOADED, signal)
{
    [self presentMessageTips:@"注销成功"];
    [self updateState];
    [self hideBarButton:BeeUINavigationBar.RIGHT];
    [self.list reloadData];
    self.navigationBarTitle = @"我的";
    [self hideBarButton:BeeUINavigationBar.RIGHT];
}

-(void)startGetmessage
{
    self.remindModel=[RemindModel modelWithObserver:self];
    [self.remindModel loadCache];
    self.remindModel.uid = [UserModel sharedInstance].session.uid;
    [self.remindModel firstPage];
}
ON_SIGNAL3(UserModel, PROFILE_RELOADED, signal)
{
    //更新个人信息 
//    [self.list reloadData];
    AllpmModel *allpmmodel =[AllpmModel modelWithObserver:self];
    [allpmmodel firstPage];
    if (![UserModel sharedInstance].firstUse) {
        [self performSelector:@selector(startGetmessage) withObject:nil afterDelay:0.1];
    }
    if ([UserModel sharedInstance].profile.hassignplugin.intValue)
    {
        if (![UserModel sharedInstance].profile.issign.intValue) {
             [BeeUINavigationBar setButtonSize:CGSizeMake(40, 30)];
            [self showBarButton:BeeUINavigationBar.RIGHT title:@"签到" titlecolor:CLR_BUTTON_TXT];
        }
        else
        {
             [BeeUINavigationBar setButtonSize:CGSizeMake(50, 30)];
            [self showBarButton:BeeUINavigationBar.RIGHT title:@"已签到" titlecolor:CLR_BUTTON_TXT];
        }
    }
    [self finishReloadingData];
}



ON_SIGNAL3(UserModel, PROFILE_FAILED, signal)
{
    [self.list reloadData];
    [self finishReloadingData];
}

#pragma mark - remindmodel 
ON_SIGNAL3(RemindModel, RELOADED, signal)
{
    BeeLog(@"%@",self.remindModel.shots);
    NSInteger  count = self.remindModel.shots.count + self.remindModel.sysautomatic.count + self.remindModel.friendsautomatic.count;//  self.remindModel.dialog.count;
    count= count + [AllpmModel strangermsCount];
    [UserModel sharedInstance].messageCount = [NSString stringWithFormat:@"%d",count];
    [self.list reloadData];
}

ON_SIGNAL3(RemindModel, FAILED, signal)
{
    [self.list reloadData];
    BeeLog(@"获取失败");
}

ON_NOTIFICATION3(BeeReachability, CHANGED, notify)
{
    if ([BeeReachability isReachableViaWIFI] ) {
        [[UserModel sharedInstance] reload];
    }
    else if ([BeeReachability isReachableViaWLAN])
    {

    }
}
- (void)refreshView
{
   [self updateState];
}

@end
