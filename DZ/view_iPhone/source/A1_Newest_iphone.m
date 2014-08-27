//
//  A1_Newest_iphone.m
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "A1_Newest_iphone.h"
#import "A1_NewestTopics_Cell.h"
#import "AppBoard_iPhone.h"
#import "neworhotlist.h"
#import "D2_Share.h"

@interface A1_Newest_iphone ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation A1_Newest_iphone
@synthesize newhotModel=_newhotModel;
-(void)load
{
    self.newhotModel=[newOrHotlistModel modelWithObserver:self];
    self.newhotModel.type=[NSNumber numberWithInt:1];
    [self.newhotModel load];
    [self.newhotModel loadCache];
}
- (void)unload
{
	self.newhotModel = nil;
}

ON_SIGNAL3(newOrHotlistModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [bee.ui.appBoard hideTabbar];
}

-(void)setNavigationBarTitle:(id)navigationBarTitle
{
    self.title = navigationBarTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBarShown=YES;
//    self.navigationBarTitle=@"最新";
    //        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage bundleImageNamed:@"navigation-back"]];
    self.view.backgroundColor = [UIColor whiteColor];
    UIEdgeInsets edge = bee.ui.config.baseInsets;
    BeeLog(@"self.view.frame.size.height-edge.top = %f",self.view.frame.size.height-edge.top);
    
    self.newhotModel=[newOrHotlistModel modelWithObserver:self];
    self.newhotModel.type=[NSNumber numberWithInt:1];
    [self.newhotModel load];
    [self.newhotModel loadCache];
    [self.newhotModel firstPage];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idtifier= @"A1_NewestTopic.Cell";
    B2_TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idtifier];
    if (cell == nil) {
        cell = [[B2_TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idtifier];
    }
    neworlisttopics *atopic=[self.newhotModel.shots objectAtIndex:indexPath.row];
    if (atopic) {
        cell.lbllandlord.text=atopic.authorname;
        cell.lblreadl.text=atopic.views;
        cell.lblreply.text=atopic.replies;
        cell.lbltitle.text=atopic.subject;
        cell.message.text = atopic.message;
        
        NSString *datastring=@"";
        KT_DATEFROMSTRING(atopic.lastpost, datastring)
        cell.lbltime.text=[NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:atopic.lastpost]];
        if (atopic.img.length) {
            [cell.cellicon GET:atopic.img useCache:YES];
            [cell layoutSubviews:YES];
            //            cell.cellicon.data=atopic.img;
        }
        else
        {
            [cell layoutSubviews:NO];
        }
//        [cell.cellicon GET:atopic.img useCache:YES];
    }
    return  cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    return 90;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newhotModel.shots.count;//forums.children.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    neworlisttopics *atopic=[self.newhotModel.shots objectAtIndex:indexPath.row];
    [D2_Share sharedInstance].image = atopic.img;
    B3_PostViewController *board=[[B3_PostViewController alloc] init];
    board.tid=atopic.tid;
    board.fid=atopic.fid;
    [self.navigationController pushViewController:board animated:YES];
//     testViewController *ctr=[[testViewController alloc] init];
//    [self.navigationController pushViewController:ctr animated:YES];
}
ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

#pragma mark - 上下拉需要添加的
//刷新调用的方法
-(void)refreshView{
    [self.newhotModel firstPage];
}

//加载调用的方法
-(void)getNextPageView{
    if (self.newhotModel.more) {
        [self removeFooterView];
        [self.newhotModel nextPage];
    }
    else
    {
        [self removeFooterView];
        [self finishReloadingData];
        [self presentMessageTips:__TEXT(@"no_more")];//没有更多的了
    }
    [self FinishedLoadData];
}



@end
