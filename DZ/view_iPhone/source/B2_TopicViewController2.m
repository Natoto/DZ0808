//
//  Base_TableViewController.m
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B2_TopicViewController2.h"
#import "B2_TopicTableViewCell.h"
#import "ToolsFunc.h"

@interface B2_TopicViewController2 ()

@end

@implementation B2_TopicViewController2
DEF_SIGNAL(selectpost)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [self.tpclistModel removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);
//    CGFloat height = MAX(self.tableViewList.contentSize.height, self.tableViewList.frame.size.height);
//    self.refreshFooterView.frame = CGRectMake(0.0f,
//                                          height,
//                                          self.tableViewList.frame.size.width,
//                                          self.view.frame.size.height);
    self.tpclistModel =[TopiclistModel modelWithObserver:self];
    self.tpclistModel.fid=self.forum_fid;
    self.tpclistModel.type=self.topic_type; 
    [self.tpclistModel loadCache];
    [self setFooterView];
}

ON_SIGNAL3(TopiclistModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillLayoutSubviews//重新layout界面 针对越狱手机
{
    self.tableViewList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);
    [self relayoutSubviews];
}
- (void)viewDidCurrentView
{
    if (!self.tpclistModel.loaded)
    {
        [self.tpclistModel firstPage];
    }
//     self.tableViewList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);
//    self.refreshHeaderView.frame=self.tableViewList.frame;
    NSLog(@"加载为当前视图 = %@",self.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
//数据加载完成
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == (self.tpclistModel.shots.count-1)){
        [self setFooterView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tpclistModel.shots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    static NSString *ListViewCellId = @"ListViewCellId";
    B2_TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[B2_TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    topics *atopic = [self.tpclistModel.shots objectAtIndex:indexPath.row];
    if (atopic)
    {
        [cell datachanges:atopic];
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    topics *atopic = [self.tpclistModel.shots objectAtIndex:indexPath.row];
    if (_topicvcdelegate != nil && [_topicvcdelegate respondsToSelector:@selector(topicViewControllerCellSelectedWithTid:)])
    {
        NSString *keys = [NSString stringWithFormat:@"%@:%@", atopic.fid,atopic.tid];
        [_topicvcdelegate performSelector:@selector(topicViewControllerCellSelectedWithTid:) withObject:keys];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //tid: 14
}

//刷新调用的方法
-(void)refreshView{
    [self.tpclistModel firstPage];
}

//加载调用的方法
-(void)getNextPageView{
    if (!self.tpclistModel.end) {
        [self removeFooterView];
        [self.tpclistModel nextPage];
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
