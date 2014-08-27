//
//  D2_Setting_AboutUsCellViewController.m
//  DZ
//
//  Created by PFei_He on 14-6-25.
//
//

#import "D2_Setting_AboutUsCellViewController.h"
#import "rmbdz.h"
#import "Bee.h"
#import "AppBoard_iPhone.h"
#import "D2_Setting_AboutUsCtr_Cell.h"
#import "DZ_SystemSetting.h"
#import "CreateComponent.h"
@interface D2_Setting_AboutUsCellViewController ()

@end

@implementation D2_Setting_AboutUsCellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DZ_SystemSetting * setting = [DZ_SystemSetting sharedInstance];
    NSString * email =[setting aboutus:@"email"];
    NSString * abstract =[setting  aboutus:@"abstract"];
    NSString * qq =[setting aboutus:@"qq"];
    NSString * website =[setting aboutus:@"website"];
    NSString * clientversion =[setting aboutus:@"clientversion"];
    [ServerConfig sharedInstance].aboutUsLeftArray = [NSMutableArray arrayWithArray:@[@"简介：", @"邮箱：", @"QQ：", @"网站：",@"内部版本号:"]];
    [ServerConfig sharedInstance].aboutUsRightArray = [NSMutableArray arrayWithArray:@[abstract,email, qq, website,clientversion]];
     
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTitle = @"关于我们";
    float MARGIN_HEIGHT = 0;
    if (IOS6_OR_EARLIER) {
        MARGIN_HEIGHT = 44;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height - MARGIN_HEIGHT)];
//    tableView.scrollEnabled = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    if (IOS7_OR_LATER) {
//        tableView.separatorInset = bee.ui.config.separatorInset;
    }
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDataSource Methods
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [CreateComponent CreateLabelWithFrame:CGRectMake(0, 0, 320, 30) andTxt:@"由易多app提供技术支持"];
    label.textColor = [UIColor grayColor];
//    label.font =[UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name =[ServerConfig sharedInstance].aboutUsLeftArray[indexPath.row];
    NSString *value =[ServerConfig sharedInstance].aboutUsRightArray[indexPath.row];
    NSString *classtype = [NSString stringWithFormat:@"%@%@",name,value];
    return [D2_Setting_AboutUsCtr_Cell heightOfcell:classtype];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ServerConfig sharedInstance].aboutUsLeftArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";

    D2_Setting_AboutUsCtr_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[D2_Setting_AboutUsCtr_Cell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
    }
    NSString *name =[ServerConfig sharedInstance].aboutUsLeftArray[indexPath.row];
    NSString *value =[ServerConfig sharedInstance].aboutUsRightArray[indexPath.row];
    cell.classtype = [NSString stringWithFormat:@"%@%@",name,value];
    [cell datachange:nil];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSString *value =[ServerConfig sharedInstance].aboutUsRightArray[indexPath.row];
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"*{1,}"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
    
    
    NSString *message = [regular stringByReplacingMatchesInString:acontmsg
                                                options:NSMatchingReportCompletion
                                                  range:NSMakeRange(0, value.length)
                                           withTemplate:@"\n"];*/
    
}
#pragma mark - UITableViewDelegate Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
