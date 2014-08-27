//
//  D1_SubMessageViewController.m
//  DZ
//
//  Created by Nonato on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "D1_FriendsInteractTableViewCell.h"
#import "D1_SubMessageViewController.h"
#import "Bee.h"
#import "ToolsFunc.h"
@interface D1_SubMessageViewController ()

@end

@implementation D1_SubMessageViewController

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
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}


- (void)viewDidCurrentView
{
    if (!self.allpmmodel.loaded) {
        [self.allpmmodel firstPage];
    }
    NSLog(@"加载为当前视图 = %@",self.title);
}

- (void)viewDidLoad
{
    self.noFooterView=YES;
    [super viewDidLoad];
    self.title=@"好友互动";
    self.view.backgroundColor=[UIColor whiteColor];
    //    self.tableViewList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);
    self.allpmmodel =[AllpmModel modelWithObserver:self];
    self.allpmmodel.uid=[UserModel sharedInstance].session.uid;
    [self.allpmmodel loadCache];
    [self viewDidCurrentView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allpmmodel.friendms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    D1_FriendsInteractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[D1_FriendsInteractTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    friendms *atopic=[self.allpmmodel.friendms objectAtIndex:indexPath.row];
//   NSDictionary *atopic=[array objectAtIndex:indexPath.row];
    if (atopic.authorid) {
        cell.lbllandlord.text=[NSString stringWithFormat:@"%@",[atopic valueForKey:@"authorid"]];
        cell.lbltitle.text=[NSString stringWithFormat:@"%@",[atopic valueForKey:@"message"]];
        cell.lbltime.text=[NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:[NSString stringWithFormat:@"%@",[atopic valueForKey:@"dateline"]]]];
        cell.cellicon.data=[NSString stringWithFormat:@"%@",[atopic valueForKey:@"avatar"]];
       
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    friendms *atopic=[self.allpmmodel.friendms objectAtIndex:indexPath.row];
//    B3_PostViewController *board=[[B3_PostViewController alloc] init];
//    board.tid=atopic.tid; //[array objectAtIndex:1];
//    board.fid=atopic.favid;//[array objectAtIndex:0];
//    [self.navigationController pushViewController:board animated:YES];
}

//刷新调用的方法
-(void)refreshView{
    [self.allpmmodel firstPage];
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
