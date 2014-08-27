//
//  TopicViewController.m
//  DZ
//
//  Created by Nonato on 14-4-22.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B2_TopicViewController.h"
#import "TopicTableViewCell.h"
#import "bee.h"
@interface B2_TopicViewController ()

@end

@implementation B2_TopicViewController
DEF_SIGNAL(selectpost)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

ON_SIGNAL3(TopiclistModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self testFinishedLoadData];
//    BeeLog(@"self.tpclistModel.shots %@",self.tpclistModel.shots);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blueColor];
    self.tpclistModel =[TopiclistModel modelWithObserver:self];
    self.tpclistModel.fid=self.forum_fid;
    self.tpclistModel.type=self.topic_type;
    [self.tpclistModel loadCache];
    self.tableViewList=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top-44.0)];
    self.tableViewList.delegate=self;
    self.tableViewList.dataSource=self;
    self.tableViewList.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.tableViewList];
    [self setExtraCellLineHidden:self.tableViewList];
    
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:self.tableViewList.frame];
    view.delegate = self;
    [self.view insertSubview:view belowSubview:self.tableViewList];
    _refreshHeaderView = view;
    [_refreshHeaderView showcircleView:YES];
    [_refreshHeaderView refreshLastUpdatedDate];
    [self setFooterView];
    //NSLog(@"viewDidLoad title = %@",self.title);
    
}

-(void)setFooterView{
//    UIEdgeInsets test = self.tableViewList.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableViewList.contentSize.height, self.tableViewList.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.tableViewList.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableViewList.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
//        [self.view insertSubview:_refreshFooterView belowSubview:self.tableViewList];
        [self.tableViewList addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}


- (void)viewDidCurrentView
{
    if (!self.tpclistModel.loaded) {
        [self.tpclistModel firstPage];
//        [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:self.tableViewList];
    }
    NSLog(@"加载为当前视图 = %@",self.title);
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - 表格视图数据源代理方法
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tpclistModel.shots.count;
}
-(NSString *)datefromstring:(NSString *)timestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    topics *atopic=[self.tpclistModel.shots objectAtIndex:indexPath.row];
    if (atopic) {
        cell.lbllandlord.text=atopic.authorname;
        cell.lblreadl.text=atopic.views;
        cell.lblreply.text=atopic.replies;
        cell.lbltitle.text=atopic.subject;
        cell.lbltime.text=[NSString stringWithFormat:@"%@",[self datefromstring:atopic.lastpost]];
        cell.cellicon.data=atopic.img;
    }
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    topics *atopic=[self.tpclistModel.shots objectAtIndex:indexPath.row];
    if (_topicvcdelegate!= nil && [_topicvcdelegate respondsToSelector:@selector(topicViewControllerCellSelectedWithTid:)])
    {
        NSString *keys=[NSString stringWithFormat:@"%@:%@",atopic.fid,atopic.tid];
        [_topicvcdelegate performSelector:@selector(topicViewControllerCellSelectedWithTid:) withObject:keys];
    }
    //tid: 14
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
/*
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}
*/

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewList];
	[_refreshHeaderView hiddenSelfSubviews:YES];
}

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView hiddenSelfSubviews:NO];
    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
*/
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    
	[self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass


-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.2];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.2];
    }
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	//  model should call this when its done loading
	_reloading = NO; 
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewList];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewList];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
//刷新调用的方法
-(void)refreshView{
    [self.tpclistModel firstPage];
}

//加载调用的方法
-(void)getNextPageView{
    if (self.tpclistModel.more) {
        [self removeFooterView];
        [self.tpclistModel nextPage];
    }
    else
    {
        [self removeFooterView];
        [self finishReloadingData];
        [self presentMessageTips:@"没有更多的了"];
    }
//    [self testFinishedLoadData];
}
-(void)testFinishedLoadData
{
    [self finishReloadingData];
    [self setFooterView];
}
@end
