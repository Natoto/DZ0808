 //
//  Board_BaseTableViewCTR.m
//  DZ
//
//  Created by Nonato on 14-7-2.
//
//


#import "Bee.h"
#import "DZ_SystemSetting.h"
#import "ToolsFunc.h"
#import "UIViewController+ErrorTips.h"
#import "BeeUIBoard+ViewController.h"
#import "Board_BaseTableViewCTR.h"
#import "MJRefresh.h"
@interface Board_BaseTableViewCTR ()

@end

@implementation Board_BaseTableViewCTR

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
//   _refreshHeaderView.frame=self.list.frame;
}

ON_SIGNAL2(BeeUIBoard, signal)
{
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.navigationBarShown=YES;
        self.navigationBarTitle=@"";
        _list=[[UITableView alloc] init];
        _list.dataSource=self;
        _list.delegate=self;
        _list.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
 
        [self setExtraCellLineHidden:_list];
        [self.view addSubview:_list];
        self.view.backgroundColor = [UIColor whiteColor];
        self.list.backgroundColor = [UIColor clearColor];
        
        [self setupRefresh];
    }
    else if([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
        _list.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//       UIEdgeInsets edge=bee.ui.config.baseInsets; 
//        _list.frame=CGRectMake(0, edge.top, self.view.frame.size.width, self.view.frame.size.height - edge.top);
    }
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    if (!self.noHeaderView) {
        [self.list addHeaderWithTarget:self action:@selector(refreshView)];
        [self.list headerBeginRefreshing];
    }
    if (!self.noFooterView) {
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
      [self.list addFooterWithTarget:self action:@selector(getNextPageView)];
    }    
}


-(void)setFooterView{
}

-(void)removeFooterView
{
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
    [self setFooterView];
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

//刷新调用的方法
-(void)refreshView
{
    
}

//加载调用的方法
-(void)getNextPageView{
    
}


-(void)finishReloadingData
{
    [self FinishedLoadData];
}
-(void)FinishedLoadData
{
    [self.list headerEndRefreshing];
    [self.list footerEndRefreshing];
    [self setFooterView];
}

@end
