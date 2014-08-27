//
//  D1_MyReplyViewController.m
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_MyReplyViewController.h"
#import "MyReplyModel.h"
#import "UserModel.h"
#import "AppBoard_iPhone.h"
#import "B2_TopicTableViewCell.h"
#import "B3_PostViewController.h"
#import "ToolsFunc.h"
#import "DZ_BASETableViewCell.h"
@interface D1_MyReplyViewController ()
{
//    UILabel *replyLeft;
//    UILabel *replyRight;
}

@property (nonatomic,retain) MyReplyModel *myReplyModel;

@end

@implementation D1_MyReplyViewController

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
    [self.myReplyModel removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
    [self.tableViewList reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.newtitle ? self.newtitle : @"我的回复";
    self.view.backgroundColor=[UIColor whiteColor];
  
    self.myReplyModel = [MyReplyModel modelWithObserver:self];
    self.myReplyModel.uid = self.uid; //[UserModel sharedInstance].session.uid;
    [self.myReplyModel loadCache];
    [self viewDidCurrentView];
    [self.myReplyModel firstPage];
    self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
//    replyLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 105, 40)];
//    replyRight = [[UILabel alloc] initWithFrame:CGRectMake(replyLeft.frame.size.width, 0, 250, 40)];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.tableViewList reloadData];
}

ON_SIGNAL3(MyReplyModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

- (void)viewDidCurrentView
{
    if (!self.myReplyModel.loaded)
        [self.myReplyModel firstPage];
    NSLog(@"加载为当前视图 = %@",self.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        UIImage *image=[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(320, 10)];
        cell.backgroundImage = image;
    }
    myreply *reply = [self.myReplyModel.shots objectAtIndex:indexPath.row];
    if (reply)
    {
        if (reply.subject.length>7) {
            reply.subject = [reply.subject substringToIndex:7];
            reply.subject = [reply.subject stringByAppendingString:@"..."];
        }
        NSString *text=[NSString stringWithFormat:@"您回复了%@",reply.subject];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];
      
        int LENGTH=4;
        [attriString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor blackColor]
                            range:NSMakeRange(0, LENGTH)];
        //把后面的变为绿色
        [attriString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor greenColor]
                            range:NSMakeRange(LENGTH, text.length - LENGTH)];

        cell.textLabel.attributedText = attriString;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [ToolsFunc datefromstring:reply.dateline]];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myReplyModel.shots.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    myreply *atopic=[self.myReplyModel.shots objectAtIndex:indexPath.row];
    B3_PostViewController *board=[[B3_PostViewController alloc] init];
    board.tid=atopic.tid; //[array objectAtIndex:1];
    board.fid=atopic.fid;//[array objectAtIndex:0];
    [self.navigationController pushViewController:board animated:YES];
}

//刷新调用的方法
- (void)refreshView
{
    [self.myReplyModel firstPage];
    [self.tableViewList reloadData];
}

//加载调用的方法
- (void)getNextPageView
{
    if (self.myReplyModel.more) {
        [self removeFooterView];
        [self.myReplyModel nextPage];
    }
    else
    {
        [self removeFooterView];
        [self finishReloadingData];
        [self presentMessageTips:@"没有更多的了"];
    }
    [self FinishedLoadData];
    [self.tableViewList reloadData];
}


@end
