//
//  QCListViewController.m
//  QCSliderTableView
//
//  Created by   on 14-4-16.
//  Copyright (c) 2014年 nonat. All rights reserved.
//

#import "B2_QCListViewController.h"
#import "forumlist.h"
@interface B2_QCListViewController ()

@end

@implementation B2_QCListViewController

@synthesize childAry=_childAry;

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
    self.noFooterView = YES;
    self.noHeaderFreshView = YES;
    [super viewDidLoad];
    //NSLog(@"viewDidLoad title = %@",self.title);
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
}

-(void)setChildAry:(NSArray *)childAry
{
    _childAry=childAry;
    [self.tableViewList reloadData];
}

#pragma mark - 表格视图数据源代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.childAry.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        
    }
    NSDictionary *aforum =[self.childAry objectAtIndex:indexPath.row];
     
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[aforum objectForKey:@"name"]];
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aforum =[self.childAry objectAtIndex:indexPath.row];
    NSString * forum_fid= [aforum  objectForKey:@"fid"];
    NSString * forum_name=[aforum  objectForKey:@"name"];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(QCListViewControllerDelegateCellSelectedWithFid:name:)]) {
        [self.delegate QCListViewControllerDelegateCellSelectedWithFid:forum_fid name:forum_name];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
