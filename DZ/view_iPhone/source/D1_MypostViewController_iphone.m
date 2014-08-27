//
//  D1_MypostViewController_iphone.m
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_MypostViewController_iphone.h"
#import "UserModel.h"
#import "B2_TopicTableViewCell.h"
#import "B3_PostViewController.h"
#import "AppBoard_iPhone.h"
#import "ToolsFunc.h"
#import "D2_Share.h"

@interface D1_MypostViewController_iphone ()

@end

@implementation D1_MypostViewController_iphone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title= self.newtitle?self.newtitle:@"我的发帖";
    self.view.backgroundColor=[UIColor whiteColor];
 
    self.postModel =[myPostModel modelWithObserver:self];
    self.postModel.uid=self.uid;
    [self.postModel loadCache];
    [self viewDidCurrentView];
    // Do any additional setup after loading the view.
}
-(void)dealloc
{
    [self.postModel removeObserver:self];
}

ON_SIGNAL3(myPostModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}
ON_SIGNAL3(myPostModel, FAILED, signal)
{
     [self FinishedLoadData];
}
- (void)viewDidCurrentView
{
    if (!self.postModel.loaded) {
        [self.postModel firstPage];
    }
    NSLog(@"加载为当前视图 = %@",self.title);
}
-(void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postModel.shots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    B2_TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[B2_TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
         
    }
    mypost *atopic=[self.postModel.shots objectAtIndex:indexPath.row];
    if (atopic) {        
        cell.lblreadl.text=atopic.views;
        cell.lblreply.text=atopic.replies;
        cell.lbltitle.text=atopic.subject;
        cell.message.text = atopic.message;
        cell.lbltime.text=[NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:atopic.dateline]];
        if (atopic.img.length) {
            cell.cellicon.data=atopic.img;
        }
        cell.lbllandlord.text=self.username?self.username:@"我";
        [cell layoutSubviews:atopic.img.length];
//        [cell isOwner:YES];
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    mypost *atopic=[self.postModel.shots objectAtIndex:indexPath.row];
    [D2_Share sharedInstance].image = atopic.img;
    B3_PostViewController *board=[[B3_PostViewController alloc] init];
    board.tid=atopic.tid; //[array objectAtIndex:1];
    board.fid=atopic.fid;//[array objectAtIndex:0];
    [self.navigationController pushViewController:board animated:YES];
}

//刷新调用的方法
-(void)refreshView{
    [self.postModel firstPage];
}

//加载调用的方法
-(void)getNextPageView{
    if (self.postModel.more) {
        [self removeFooterView];
        [self.postModel nextPage];
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
