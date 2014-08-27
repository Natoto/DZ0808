//
//  D1_Reply_OtherViewController.m
//  DZ
//
//  Created by Nonato on 14-7-31.
//
//

#import "D1_Reply_OtherViewController.h"
#import "PostmineModel.h"
#import "AppBoard_iPhone.h"
#import "B3_PostViewController.h"
@interface D1_Reply_OtherViewController ()
@property(nonatomic,retain)PostmineModel *myReplyModel;
@end

@implementation D1_Reply_OtherViewController

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
    
    self.title = self.newtitle ? self.newtitle : @"别人的回复";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.myReplyModel = [PostmineModel modelWithObserver:self];
    self.myReplyModel.uid = self.uid; //[UserModel sharedInstance].session.uid;
    [self.myReplyModel loadCache];
    [self viewDidCurrentView];
    [self.myReplyModel firstPage];
    self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self reframeTableView:TABLEVIEW_WITHSLIDSWITCH];
    self.array = [NSArray arrayWithArray:self.myReplyModel.shots];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.tableViewList reloadData];
}

ON_SIGNAL3(PostmineModel, RELOADED, signal)
{
    self.array = [NSArray arrayWithArray:self.myReplyModel.shots];
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(PostmineModel, FAILED, signal)
{
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    postmine *reply = [self.array objectAtIndex:indexPath.row];
    if (reply)
    {
        NSString *text=[NSString stringWithFormat:@"%@回复了%@",reply.replies,reply.subject];
        int length =[NSString unicodeLengthOfString:text];
        if (length>24) {
            text =  [NSString subStringByUnicodeIndex:text asciiLength:24];// [text substringToIndex:14];
            text = [text stringByAppendingString:@"..."];
        }
        UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];
        int LENGTH1=reply.replies.length;
        int LENGTH2=LENGTH1 +3;
        [attriString addAttribute:NSForegroundColorAttributeName
                            value:color
                            range:NSMakeRange(0, LENGTH1)];
        
        [attriString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor blackColor]
                            range:NSMakeRange(LENGTH1, 3)];
        
        
        //把后面的变为绿色
        if ( text.length > LENGTH2) {
            [attriString addAttribute:NSForegroundColorAttributeName
                                value:color
                                range:NSMakeRange(LENGTH2, text.length - LENGTH2)];
        }
        cell.textLabel.attributedText = attriString;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [ToolsFunc datefromstring:reply.dateline]];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_Reply_OtherViewController:cellSelectedWithTid:)]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        postmine *atopic=[self.array objectAtIndex:indexPath.row];
        [self.delegate D1_Reply_OtherViewController:self cellSelectedWithTid:atopic.tid];
    }
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
