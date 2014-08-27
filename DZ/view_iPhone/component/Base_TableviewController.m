//
//  TopicViewController.m
//  DZ
//
//  Created by Nonato on 14-4-22.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B2_TopicViewController2.h"
#import "bee.h"
#import "Bee_UIActivityIndicatorView.h"
#import "MJRefresh.h"
@interface Base_TableviewController ()

@end

@implementation Base_TableviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)relayoutSubviews
{
    
}

-(void)reframeTableView:(TABLEVIEW_TYPE)type
{
    if (type == TABLEVIEW_WITHSLIDSWITCH) {
        self.tableViewList.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - SLIDSWITCH_SECTIONS_HEIGHT);
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{ 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationBarShown) {
        self.view.frame =CGRectMake(0, 0, 320, self.bounds.size.height - bee.ui.config.baseInsets.top);
    } 
    
    self.view.backgroundColor = CLR_BACKGROUND;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
     
    self.tableViewList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableViewList.delegate = self;
    self.tableViewList.dataSource = self;
    self.tableViewList.backgroundColor = CLR_FOREGROUND;//[UIColor whiteColor];
    self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (IOS7_OR_LATER) {
        [self.tableViewList setSeparatorInset:bee.ui.config.separatorInset];
    }
    [self.view addSubview:self.tableViewList];
    [self setExtraCellLineHidden:self.tableViewList];
    
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    if (!self.noHeaderFreshView) {
        [self.tableViewList addHeaderWithTarget:self action:@selector(refreshView)];
        [self.tableViewList headerBeginRefreshing];
    }
    if (!self.noFooterView) {
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        [self.tableViewList addFooterWithTarget:self action:@selector(getNextPageView)];
    }
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
}

- (void)footerRereshing
{
    
}




-(void)setFooterView{
//    UIEdgeInsets test = self.tableViewList.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
  
}
-(void)removeFooterView{
   
}


- (void)viewDidCurrentView
{ 
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//数据加载完成
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - 表格视图数据源代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)doneLoadingTableViewData
{
	 
}

//刷新调用的方法
-(void)refreshView
{
    
}

//加载调用的方法
-(void)getNextPageView
{
    
}
-(void)FinishedLoadData
{
    [self.tableViewList headerEndRefreshing];
    [self.tableViewList footerEndRefreshing];
}

-(void)noMore
{
    [self.tableViewList removeFooter];
}
-(void)finishReloadingData
{
    [self.tableViewList headerEndRefreshing];
    [self.tableViewList footerEndRefreshing];
}


@end
