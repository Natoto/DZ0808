 //
//  A0_HomePage1_iphone.m
//  DZ
//
//  Created by Nonato on 14-4-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "A0_HomePage1_iphone.h"
#import "A0_TileView.h"
#import "AppBoard_iPhone.h"
#import "D1_CollectionViewController_iphone.h"
#import "MJRefresh.h"

@interface A0_HomePage1_iphone ()
{
//    UIImageView *bgimgview;
}
@property(nonatomic,retain)UserModel *usermodel;
@end

@implementation A0_HomePage1_iphone
DEF_NOTIFICATION(homepageItemChanged)
-(void)load
{
    self.usermodel = [UserModel modelWithObserver:self]; 
    self.homeModel	= [homeModel  modelWithObserver:self];
}

- (void)unload
{
    [self.usermodel removeObserver:self];
	[self.homeModel removeObserver:self];    
    [self unobserveAllNotifications];
    
}
#pragma mark  -
#pragma mark 界面控制
ON_SIGNAL3(A0_HomePage1_iphone, dragViewEnd, signal)
{
     NSLog(@"移动交换位置~~ " );
    if (self.EDITMODE) {
        NSString *changePositions =signal.object;
        NSArray *positons=[changePositions componentsSeparatedByString:@":"];
        if (positons.count) {
            NSInteger changeSrsIndex2=(int)[[positons objectAtIndex:0] integerValue];
            NSInteger changeDesIndex2=(int)[[positons objectAtIndex:1] integerValue];
            if (changeSrsIndex2!= changeDesIndex2 && _ModeleBlocks.count) {
                [self.ModeleBlocks exchangeObjectAtIndex:changeSrsIndex2 withObjectAtIndex:changeDesIndex2];
            }
        }
    }
}

ON_SIGNAL3(A0_HomePage1_iphone, longPressEnd, signal)
{
    NSLog(@"保存位置~~ a " );
    if (!self.EDITMODE) {
            [self.homeModel saveArrangedPosition:self.ModeleBlocks];
      }
}
//removeView
ON_SIGNAL3(A0_HomePage1_iphone, removeView, signal)
{
    HOME2TOPICSPOSITIONITEM *item =signal.object;
    if (![self modeleBlocksContainsObject:item array:self.ModeleBlocks]) {
        return;
    }

    NSLog(@"删除一个视图~~~ ");
    [self.ModeleBlocks removeObject:item];
    [self.homeModel saveArrangedPosition:self.ModeleBlocks];
    [self postNotification:self.homepageItemChanged withObject:self.ModeleBlocks];//发送删除消息
}
ON_SIGNAL3(A0_TileView,CLOSTBTNTAPPED, signal)
{ 
    A0_TileView *tileView=(A0_TileView *)signal.source;
    [self ReArrangTileViews:tileView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.homeModel saveArrangedPosition:self.ModeleBlocks];
    self.EDITMODE = NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( NO == self.homeModel.loaded )
    {
        [self.homeModel firstPage];
    }
    [self ReArrangTileViews:nil];
    [bee.ui.appBoard showTabbar];
}


ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.tileArray = [[NSMutableArray alloc] initWithCapacity:0];
        UIBarButtonItem *myBarButtonItem = [[UIBarButtonItem alloc] init];
        myBarButtonItem.title = __TEXT(@"homepage");
        self.navigationItem.backBarButtonItem = myBarButtonItem;
        _ModeleBlocks=[[NSMutableArray alloc] initWithCapacity:0];
        self.navigationBarShown=YES;
        
        /*获得工程名字
         NSString *title= [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];*/
        NSString * title = [DZ_SystemSetting sharedInstance].appname;
        self.navigationBarTitle=title;
        
        
        self.view.backgroundColor =[UIColor whiteColor]; //[UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0]; //[UIColor colorWithRed:249.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
        [self.view addSubview:self.scrollView];
        self.scrollView.delegate=self;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
         
        
        [self addHeader];
        [self observeNotification:@"notify.B0_ForumPlates_iphone.FORUMADDTOHOME"];
        [self observeNotification:@"notify.B0_ForumPlates_iphone.FORUMREMOVEFROMEHOME"];
                
    }
    else if ([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
//        self.scrollView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - bee.ui.config.baseInsets.top);
        UIEdgeInsets edge= bee.ui.config.baseInsets;
//        bgimgview.frame =CGRectMake(0, 0, 320, edge.top);
//        self.scrollView.contentInset=edge;
        self.scrollView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -TAB_HEIGHT);
        [self reloadData];
        
    }
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.scrollView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc.homeModel firstPage];
    }];
    [self.scrollView headerBeginRefreshing];
}

-(void)reloadData
{
    if (self.homeModel) {
        
        NSMutableArray *tempModeleBlocks = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *blocks = (NSMutableArray *)[self.homeModel arrangedPositions];
        
        
        if (self.homeModel.onoff.iscommand.integerValue) {
            HOME2TOPICSPOSITIONITEM *item4 = [[HOME2TOPICSPOSITIONITEM alloc] init];
            home_command *acommand = self.homeModel.shots.command;
            item4.title = acommand.title ? acommand.title : @"站长推荐";
            item4.subject = acommand.subject ? acommand.subject : @"这个站长好懒，没有推荐什么";
            item4.icon = acommand.img;
            item4.fid = HOME_FID_TUIJIAN;
            item4.count = @"0";
            item4.enableDelete = [NSString stringWithFormat:@"0"];
            [tempModeleBlocks insertObject:item4 atIndex:0];
        }
        
        
        
        newest *new = self.homeModel.shots.newest;
        HOME2TOPICSPOSITIONITEM *item2 = [[HOME2TOPICSPOSITIONITEM alloc] init];
        item2.title = new.title;
        item2.count = @"0"; //[NSString stringWithFormat:@"%@",new];
        item2.subject = new.subject;
        item2.icon = new.img;
        item2.fid = HOME_FID_NEWEST;
        item2.enableDelete = [NSString stringWithFormat:@"0"];
        [tempModeleBlocks addObject:item2];
        
        HOME2TOPICSPOSITIONITEM *item3=[[HOME2TOPICSPOSITIONITEM alloc] init];
        hot *ahot=self.homeModel.shots.hot;
        item3.count=@"0";
        item3.subject=ahot.subject;
        item3.title=ahot.title;
        item3.icon=ahot.img;
        item3.fid=HOME_FID_HOTEST;
        item3.enableDelete=[NSString stringWithFormat:@"0"];
        [tempModeleBlocks addObject:item3];
        
        /*
        HOME2TOPICSPOSITIONITEM *item5=[[HOME2TOPICSPOSITIONITEM alloc] init];
        item5.subject=@"广告";
        item5.title=@"广告";
        item5.icon=@"0";
        item5.fid=@"-5";
        item5.enableDelete=[NSString stringWithFormat:@"0"];
        [tempModeleBlocks addObject:item5];
        */
        
        HOME2TOPICSPOSITIONITEM *item6=[[HOME2TOPICSPOSITIONITEM alloc] init];
        digest *adigest=self.homeModel.shots.digest;
        item6.subject=adigest.subject;
        item6.title=adigest.title;
        item6.backgroundcolor=@"0x706cda";
        item6.icon=adigest.img;
        item6.fid=HOME_FID_DIGEST;
        item6.count=@"0";
        item6.enableDelete=[NSString stringWithFormat:@"0"];
        [tempModeleBlocks addObject:item6];
        
        HOME2TOPICSPOSITIONITEM *item = [[HOME2TOPICSPOSITIONITEM alloc] init];
        my *amy = self.homeModel.shots.my;
        item.count = [NSString stringWithFormat:@"0"];
        item.subject = amy.subject ? amy.subject : @"如有帖子登录后刷新可查看";
        item.icon = amy.img;
        item.fid = HOME_FID_MINE;
        item.backgroundcolor = @"0xde6abb";
        item.count = @"0";
        item.title = amy.title?amy.title : @"我的主题";  //my.message;//我的
        item.enableDelete = [NSString stringWithFormat:@"0"];
        [tempModeleBlocks addObject:item];
        
        
        self.homeModel.onoff.isactivity = [NSNumber numberWithInt:0];
        /*暂时屏蔽活动主题
         if (self.homeModel.onoff.isactivity.integerValue) {
            HOME2TOPICSPOSITIONITEM *item4 = [[HOME2TOPICSPOSITIONITEM alloc] init];
            home_activity *activity = self.homeModel.shots.activity;
            item4.title = activity.title ? activity.title : @"活动主题";
            item4.subject = activity.subject ? activity.subject : @"活动推荐";
            item4.icon = activity.img;
            item4.fid = HOME_FID_ACTIVITY;
            item4.count = @"0";
            item4.enableDelete = [NSString stringWithFormat:@"0"];
            [tempModeleBlocks insertObject:item4 atIndex:0];
        }
        */
        
        HOME2TOPICSPOSITIONITEM *item7=[[HOME2TOPICSPOSITIONITEM alloc] init];
        item7.subject=@"";
        item7.fid=HOME_FID_ADD;
        item7.icon =@"localhost:tianjia@2x.jpg";
        item7.backgroundcolor=@"0XE9E9E9";
        item7.title=@"添加";
        item7.enableDelete=[NSString stringWithFormat:@"0"];
        [tempModeleBlocks addObject:item7];
        
     
        NSMutableArray *topicsAry=[[NSMutableArray alloc] initWithCapacity:0];
        if (self.homeModel.shots.topics2.count) {
            for ( int index=0; index<self.homeModel.shots.topics2.count; index ++) {
                topics2 *atopic = [self.homeModel.shots.topics2 objectAtIndex:index];
                HOME2TOPICSPOSITIONITEM *item=[[HOME2TOPICSPOSITIONITEM alloc] init];
                item.icon = atopic.img;
                item.subject = atopic.subject;
                item.title = atopic.title;
                item.count = [NSString stringWithFormat:@"%@",atopic.count];
                item.fid= [NSString stringWithFormat:@"%@",atopic.fid];
                [topicsAry addObject:item];
            }
        }
        [tempModeleBlocks addObjectsFromArray:topicsAry];
        
        if (blocks.count < tempModeleBlocks.count)
        {// 从后台返回的和本地的不一致  后台返回的比较多则更新本地的数据
            
            self.ModeleBlocks = tempModeleBlocks;
            if (!blocks) {
                blocks = [NSMutableArray arrayWithArray:tempModeleBlocks];
                self.ModeleBlocks = blocks;
            }
            for (int i=0; i<self.ModeleBlocks.count; i++) {
                HOME2TOPICSPOSITIONITEM *modelitem = [self.ModeleBlocks objectAtIndex:i];
                BOOL find = NO;
                for (int j=0; j<blocks.count; j++) {
                    HOME2TOPICSPOSITIONITEM *blockitem = [blocks objectAtIndex:j];
                    if ([blockitem.fid isEqual:modelitem.fid]) {
//                        blockitem = modelitem;
                        [blocks setObject:[modelitem copy] atIndexedSubscript:j];
                        find = YES;
                        break;
                    }
                }
                if (!find) {
                    [blocks addObject:modelitem];
                }
            }
            [self moveCommandPlatesFront:blocks];
            for (int i=0; i<blocks.count; i++)
             {
                 [self updateViewButtonWithTitle:[blocks objectAtIndex:i] index:i];
             }
            [self.homeModel saveArrangedPosition:blocks];
            self.ModeleBlocks = blocks;
        }
        else
        {
            [self moveCommandPlatesFront:blocks];
            for (int index=0;index < blocks.count;index ++) {
                HOME2TOPICSPOSITIONITEM *tempitem=[blocks objectAtIndex:index];
                int mdbindex=-1;
                HOME2TOPICSPOSITIONITEM *item=tempitem;
                self.ModeleBlocks = tempModeleBlocks;
                for (mdbindex=0;mdbindex<self.ModeleBlocks.count; mdbindex++ ) {
                    item =[self.ModeleBlocks objectAtIndex:mdbindex];
                    if ([item.fid isEqualToString:tempitem.fid]) {
                        break;
                    }//需要更新
                }
               
                if (mdbindex>=0 && mdbindex !=(self.ModeleBlocks.count)) {//找到了需要更新
                    [blocks setObject:item atIndexedSubscript:index];
                    continue;
                }
            }
            if (blocks.count) {
                for (int i=0; i<blocks.count; i++) {
                    [self updateViewButtonWithTitle:[blocks objectAtIndex:i] index:i];
                }
                [self.homeModel saveArrangedPosition:blocks];
                self.ModeleBlocks =blocks;
            }
        }
        //处理属性改变事件
    }

}
/*
 将站长推荐提前或者移除
 */
-(void)moveCommandPlatesFront:(NSMutableArray *)blocks
{
     if (self.homeModel.onoff.iscommand.integerValue) {
        int index = 0;
        HOME2TOPICSPOSITIONITEM *commanditem = blocks[0];
        if (![commanditem.fid isEqualToString:HOME_FID_TUIJIAN])
        {
            commanditem = nil;
            for (index = blocks.count-1; index >=0; index--) {
                HOME2TOPICSPOSITIONITEM *tempitem=[blocks objectAtIndex:index];
                if ([tempitem.fid isEqualToString:HOME_FID_TUIJIAN]) {
                    commanditem = tempitem;
                    break;
                }
            }
            if (index ) {
                for (int j=index-1; j>=0; j--) {
                    HOME2TOPICSPOSITIONITEM *tempitem2=[blocks objectAtIndex:j];
                    if ((j+1) > blocks.count) {
                        [blocks addObject:tempitem2];
                    }
                    else
                        blocks[j+1] = tempitem2;
                    
                }
            }
            if (commanditem) {
                blocks[0]=commanditem;
            }
        }
    }
    else
    {//如果没有开启站长推荐而本地数据库中有 则移除
        int index = 0;
        HOME2TOPICSPOSITIONITEM *commanditem = blocks[0];
        if (![commanditem.fid isEqualToString:HOME_FID_TUIJIAN])
        {
            commanditem = nil;
            for (index = blocks.count-1; index >=0; index--) {
                HOME2TOPICSPOSITIONITEM *tempitem=[blocks objectAtIndex:index];
                if ([tempitem.fid isEqualToString:HOME_FID_TUIJIAN]) {
                    commanditem = tempitem;
                    [blocks removeObjectAtIndex:index];
                    break;
                }
            }
        }
        else
        {
             [blocks removeObjectAtIndex:0];
        }
    }
    [self reloadActiveItem:blocks];
}
-(void)reloadActiveItem:(NSMutableArray *)blocks
{
   if (!self.homeModel.onoff.isactivity.integerValue)
    {//如果没有活动主题而本地数据库中有 则移除
        HOME2TOPICSPOSITIONITEM *commanditem = nil;
        int index = 0;
        for (index = blocks.count-1; index >=0; index--) {
            HOME2TOPICSPOSITIONITEM *tempitem=[blocks objectAtIndex:index];
            if ([tempitem.fid isEqualToString:HOME_FID_ACTIVITY]) {
                commanditem = tempitem;
                [blocks removeObjectAtIndex:index];
                break;
            }
        }        
    }
}
#pragma mark - 添加版块
ON_NOTIFICATION3(B0_ForumPlates_iphone, FORUMADDTOHOME, notify)
{
    HOME2TOPICSPOSITIONITEM *item=notify.object;
//    item.enableDelete=[NSString stringWithFormat:@"1"];
    if ([self modeleBlocksContainsObject:item array:self.ModeleBlocks]) {
        return;
    }
    [self.ModeleBlocks insertObject:item atIndex:1];
    [self inSertViewButtonWithTitle:item index:1];
    [self.homeModel saveArrangedPosition:self.ModeleBlocks];
}

-(NSMutableArray *)removeModeleBlocksObject:(HOME2TOPICSPOSITIONITEM *)item ModeleBlocks:(NSMutableArray *)ModeleBlocks
{
    int index = -1;
    for (index = 0; index < ModeleBlocks.count; index++) {
        HOME2TOPICSPOSITIONITEM *tempitem = [ModeleBlocks objectAtIndex:index];
        if ([item.fid isEqual: tempitem.fid]) {
            break;
        }
    }
    if (index != -1) {
        [ModeleBlocks removeObjectAtIndex:index];
    }
    return ModeleBlocks;
}
-(BOOL)modeleBlocksContainsObject:(HOME2TOPICSPOSITIONITEM *)item array:(NSArray *)array
{
    for (HOME2TOPICSPOSITIONITEM *tempitem in array) {
        if ([tempitem.fid isEqual:item.fid]) {
            return YES;
        }
    }
    return NO;
}

ON_NOTIFICATION3(B0_ForumPlates_iphone,FORUMREMOVEFROMEHOME, notify)
{
    HOME2TOPICSPOSITIONITEM *item=notify.object;
    if (![self modeleBlocksContainsObject:item array:self.ModeleBlocks]) {
        return;
    }
    self.ModeleBlocks = [self removeModeleBlocksObject:item ModeleBlocks:self.ModeleBlocks];
    [self removeViewButtonWithTitle:item];
    [self.homeModel saveArrangedPosition:self.ModeleBlocks];
}

#pragma mark - 版块添加选择 delegate 

-(void)saveHomePageUserModel:(NSMutableArray *)array
{
    [self removeAllitems];
    self.ModeleBlocks =array ;
    for (int i=0; i<self.ModeleBlocks.count; i++) { 
        [self updateViewButtonWithTitle:[self.ModeleBlocks objectAtIndex:i] index:i];
    }
    [self.homeModel saveArrangedPosition:self.ModeleBlocks];
    [self postNotification:self.homepageItemChanged withObject:self.ModeleBlocks];//发送删除消息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ReArrangTileViews:nil];
    });
}
#pragma mark - 登录 

ON_SIGNAL3(UserModel, LOGIN_RELOADED, signal)
{
    [self.homeModel firstPage];
}

#pragma mark - 加载完成
ON_SIGNAL3(homeModel, RELOADED, signal)
{
     BeeLog(@"更新完成 加载界面");
    [self reloadData];
    [self.scrollView headerEndRefreshing];
//    [self finishReloadingData];
}
ON_SIGNAL3(homeModel, CANCELLED, signal)
{
     [self.scrollView headerEndRefreshing];
}

ON_SIGNAL3(homeModel, FAILED, signal)
{
    if (self.homeModel.resp.emsg.length) {
        [self presentMessageTips:[NSString stringWithFormat:@"Error:%@",self.homeModel.resp.emsg]];
    }
    [self.scrollView headerEndRefreshing];
//    [self finishReloadingData];
}
//ON_NOTIFICATION3(HomePageModel, HOMEPAGE, notification)
//{
//   
//    BeeLog(@"%@", self.homeModel);
//    [self.homeModel clearArrangedPosition];
//    [self RELAYOUT];
//}

ON_SIGNAL3( A0_TileView, mask, signal )
{    
     HOME2TOPICSPOSITIONITEM *item=signal.object;
    if ([item.fid isEqualToString:HOME_FID_TUIJIAN]) {
        A1_WebmasterRecommend_iphone * board = [[A1_WebmasterRecommend_iphone alloc] init];
        [self.navigationController pushViewController:board animated:YES];
    }
    else if ([item.fid isEqualToString:HOME_FID_ADD]) {
        [bee.ui.appBoard showForumPlatesSelect:self];
    }
    else if ([item.fid isEqualToString:HOME_FID_NEWEST])
    {
        A1_Newest_iphone * board = [[A1_Newest_iphone alloc] init];
        [board setNavigationBarTitle:item.title];
        [self.navigationController pushViewController:board animated:YES];
    }
    else if ([item.fid isEqualToString:HOME_FID_GUANGGAO])//广告
    {
        
    }
    else if ([item.fid isEqualToString:HOME_FID_HOTEST]) {
        A1_Hotest_iphone * board = [[A1_Hotest_iphone alloc] init];
        [board setNavigationBarTitle:item.title];
        [self.navigationController pushViewController:board animated:YES]; 
    }
    else if ([item.fid isEqualToString:HOME_FID_DIGEST]) {//精华
        
        A1_Digest_iphone * board = [[A1_Digest_iphone alloc] init];
        [board setNavigationBarTitle:item.title];
        [self.navigationController pushViewController:board animated:YES];
    }
    else if ([item.fid isEqualToString:HOME_FID_MINE])//我的主题
    {
        if ([UserModel sharedInstance].session.uid) {
            D1_MypostViewController_iphone * board = [[D1_MypostViewController_iphone alloc] init];
            board.uid = [UserModel sharedInstance].session.uid;
            [board setNavigationBarTitle:item.title];
            [self.navigationController pushViewController:board animated:YES];
        }
        else
        {
            [bee.ui.appBoard showLogin];
        }
    }
    else
    {
        B1_ATopicViewController * board = [[B1_ATopicViewController alloc] init];
        board.forum_fid = item.fid;
        [board setNavigationBarTitle:item.title];
        [self.navigationController pushViewController:board animated:YES];
    }
}


ON_LOAD_DATAS( signal )
{
    [self.homeModel loadCache];
}

 
@end
