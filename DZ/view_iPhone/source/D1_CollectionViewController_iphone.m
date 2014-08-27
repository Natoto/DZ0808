//
//  D1_CollectionViewController.m
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "UserModel.h"
#import "D1_CollectionViewController_iphone.h"
#import "B2_TopicTableViewCell.h"
#import "B3_PostViewController.h"
#import "AppBoard_iPhone.h"
#import "ToolsFunc.h"
#import "D2_Share.h"

@interface D1_CollectionViewController_iphone ()

@end

@implementation D1_CollectionViewController_iphone
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
    self.title=self.newtitle?self.newtitle:@"我的收藏";
    self.view.backgroundColor=[UIColor whiteColor];
 
    self.collectModel =[collectionModel modelWithObserver:self];
    self.collectModel.uid = self.uid; //[UserModel sharedInstance].session.uid;
    [self.collectModel loadCache];
    [self viewDidCurrentView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}

ON_SIGNAL3(collectionModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(collectionModel, FAILED, signal)
{
    [self FinishedLoadData];
}
- (void)viewDidCurrentView
{
    if (!self.collectModel.loaded) {
        [self.collectModel firstPage];
    }
    NSLog(@"加载为当前视图 = %@",self.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectModel.shots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    B2_TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[B2_TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        
    }
    collection *atopic=[self.collectModel.shots objectAtIndex:indexPath.row];
    if (atopic) {
        cell.lbllandlord.text=atopic.author;
        cell.lblreadl.text=atopic.views;
        cell.lblreply.text=atopic.replies;
        cell.lbltitle.text=atopic.subject;
        cell.message.text = atopic.message;
        cell.lbltime.text=[NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:atopic.dateline]];
        if (atopic.img.length) {
            cell.cellicon.data=atopic.img; 
            [cell layoutSubviews:atopic.img.length];
        }
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    collection *atopic=[self.collectModel.shots objectAtIndex:indexPath.row];
    [D2_Share sharedInstance].image = atopic.img;
    B3_PostViewController *board=[[B3_PostViewController alloc] init];
    board.tid=atopic.tid; //[array objectAtIndex:1];
    board.fid=atopic.favid;//[array objectAtIndex:0];
    [self.navigationController pushViewController:board animated:YES];
}

//刷新调用的方法
-(void)refreshView{
    [self.collectModel firstPage];
}

//加载调用的方法
-(void)getNextPageView{
    if (self.collectModel.more) {
        [self removeFooterView];
        [self.collectModel nextPage];
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
