//
//  B2_SearchViewController.m
//  DZ
//
//  Created by Nonato on 14-5-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee.h"
#import "B2_SearchViewController.h"
#import "AppBoard_iPhone.h"
#import "rmbdz.h"
#import "NSData+base64.h"

@interface B2_SearchViewController ()
{
    UITextField *searchField;
    UIView *searchBar;

    MaskView *maskView;
}

@end

@implementation B2_SearchViewController

//DEF_MODEL(SearchModel, search)

@synthesize uid = _uid;
@synthesize searchModel = _searchModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)unload
{
//    self.search = nil;
//    [self unobserveAllNotifications];
    self.searchModel = nil;
}

- (BOOL)prefersStatusBarHiddenChange
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [bee.ui.appBoard hideTabbar];

    [inputText becomeFirstResponder];

    self.navigationItem.hidesBackButton = YES;

    inputText.hidden = NO;
    cancelBtn.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    inputText.hidden = YES;
    cancelBtn.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor whiteColor];
    //获取最底层的View
    //    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //    int stateBarHeight = 0;

    //    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    //    background.backgroundColor = KT_HEXCOLOR(0x32325a);
    //    [self.view addSubview:background];

    //    if (KT_IOS_VERSION_7_OR_ABOVE) {
    //        searchBg = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 35)];
    //        searchBg.backgroundColor = [UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1];
    //        [background addSubview:searchBg];
    //        stateBarHeight = 22;
    //    }
    //    searchBar = [self addReplayEditArea:CGRectMake(0, 22, 320, 40)];
    //    [self.view addSubview:searchBar];

    inputText = [[UITextField alloc] initWithFrame:CGRectMake(5, 7, 250, 30)];
    inputText.borderStyle = UITextBorderStyleRoundedRect;
    inputText.returnKeyType = UIReturnKeySearch;
    inputText.font = [UIFont systemFontOfSize:15];
    inputText.placeholder = @"请输入您想搜索的内容";
    inputText.delegate = self;
    inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (IOS7_OR_LATER) {
        [[UITextField appearance] setTintColor:[UIColor blueColor]];
    }
    [self.navigationController.navigationBar addSubview:inputText];

    //取消按钮
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    [cancelBtn setTitle:__TEXT(@"cancel") forState:UIControlStateNormal];//取消
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(280, 5, 35, 40);
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:cancelBtn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:__TEXT(@"cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtn)];//取消
    self.navigationItem.rightBarButtonItem = item;
    
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 64)];
    list.dataSource = self;
    list.delegate = self;
//    if (IOS7_OR_LATER) {
//        list.separatorInset = UIEdgeInsetsZero;
//    }
    [self.view addSubview:list];

    maskView= [[MaskView alloc] initWithFrame:CGRectMake(0, 0, list.frame.size.width, list.frame.size.height + 400)];
    maskView.delegate=self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/*
 - (UIView *)addReplayEditArea:(CGRect)frame
 {

 UIView *replayArea = [[UIView alloc] initWithFrame:frame];
 replayArea.backgroundColor = [UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1];

 UIView *txtfldview=[[UIView alloc] initWithFrame:CGRectMake(10, 5, frame.size.width-70, frame.size.height-10)];
 txtfldview.backgroundColor=[UIColor whiteColor];
 UIButton *iconbtn=[UIButton buttonWithType:UIButtonTypeCustom];
 [iconbtn setImage:[UIImage bundleImageNamed:@"sousuo2@2x.jpg"] forState:UIControlStateNormal];
 iconbtn.frame=CGRectMake(0, 5, 30, 30);
 [txtfldview addSubview:iconbtn];

 //    UITextField *txtfld=[[UITextField alloc] initWithFrame:CGRectMake(30, 5, frame.size.width-90, frame.size.height-10)];
 //    txtfld.placeholder=@"搜索一下";
 //    txtfld.backgroundColor=[UIColor whiteColor];

 KT_CORNER_RADIUS(txtfldview, 4);

 //    [txtfldview addSubview:txtfld];
 [replayArea addSubview:txtfldview];
 //    searchField=txtfld;
 return replayArea;
 }

 -(IBAction)replybtnTap:(id)sender
 {
 [self dismissViewControllerAnimated:YES completion:^{

 }];
 }
 */

ON_SIGNAL3(SearchModel, RELOADED, signal)
{
    if (self.searchModel.shots.count) {
        [list reloadData];
    }
    else
    {
        [self presentMessageTips:@"没有找到内容"];
    }
}

#pragma mark - Event

- (void)cancelBtn
{
    [inputText resignFirstResponder];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postRequest
{
    if (inputText.text == nil || inputText.text.length == 0) {
//        UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"请输入要搜索的内容"
//                                                         message:nil
//                                                        delegate:nil
//                                               cancelButtonTitle:@"确定"
//                                               otherButtonTitles:nil];
//        [prompt show];
        [self presentMessageTips:@"请输入要搜索的内容"];
        return;
    }

    //加密
    NSData *textData = [inputText.text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *kw = [textData base64Encoding];

    //    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://103.254.108.31/bliss_dz_31/source/plugin/dztoapp/status.php?action=search&kw=keyword&uid=1"]];
    //    [request addPostValue:@"admin" forKey:@"uid"];
    //    [request addPostValue:kw forKey:@"kw"];
    //    [request setDelegate:self];
    //    [request startAsynchronous];

    self.searchModel = [SearchModel modelWithObserver:self];
    self.searchModel.kw = kw;
//    self.searchModel.kw = inputText.text;
    NSLog(@"%@", self.searchModel.kw);
    [self.searchModel firstPage];
}

#pragma mark - UITextFieldDelegate

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [maskView showInView:list];
//    [inputText resignFirstResponder];
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [maskView showInView:list];
    [inputText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    [list reloadData];

    [self postRequest];

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [list reloadData];

    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return resultArray.count;
//    if (self.searchModel.shots.count == 0) {
//        [self presentMessageTips:@"没有搜索到相关结果"];
//    }
    return self.searchModel.shots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    //    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", [[resultArray objectAtIndex:indexPath.row] objectForKey:@"subject"]];

    @try {
        searchlist *searchList = [self.searchModel.shots objectAtIndex:indexPath.row];
        if (searchList)
            cell.textLabel.text = searchList.subject;
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {

    };
//    tid = [[NSMutableString alloc] initWithFormat:@"%@", [[resultArray objectAtIndex:indexPath.row] objectForKey:@"tid"]];
//    fid = [[NSString alloc] initWithFormat:@"%@", [[resultArray objectAtIndex:indexPath.row] objectForKey:@"fid"]];

    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"搜索结果：";
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [inputText resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    B3_PostViewController *board = [[B3_PostViewController alloc] init];
//    board.tid = [[NSMutableString alloc] initWithFormat:@"%@", [[resultArray objectAtIndex:indexPath.row] objectForKey:@"tid"]];
//    board.fid = [[NSString alloc] initWithFormat:@"%@", [[resultArray objectAtIndex:indexPath.row] objectForKey:@"fid"]];
    searchlist *searchList = [self.searchModel.shots objectAtIndex:indexPath.row];
    board.tid = searchList.tid;
    board.fid = searchList.fid;

    [self.navigationController pushViewController:board animated:YES];
}

/*
 #pragma mark - ASIHTTPRequestDelegate

 - (void)requestStarted:(ASIHTTPRequest *)request
 {

 }

 - (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
    resultArray = [resultDic objectForKey:@"searchlist"];
    NSLog(@"============!!!!!!!!!!=============%d", resultArray.count);
    //刷新列表
    [list reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
 NSLog(@"%@", request.error);
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchModel.shots.count == 0)
        return 0;
    else
        return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    [headerView setBackgroundColor:[UIColor colorWithRed:224./255. green:224./255. blue:224./255. alpha:1]];
    UILabel *_textlabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
//    _textlabel.font=[UIFont boldSystemFontOfSize:15];
    _textlabel.font = [UIFont systemFontOfSize:15];
    _textlabel.text=[NSString stringWithFormat:@"%@", __TEXT(@"search_result")];//搜索结果
    _textlabel.backgroundColor=[UIColor clearColor];
    [headerView addSubview:_textlabel];
    return headerView;
}

#pragma mark - MaskViewDelegate

- (void)MaskViewDidTaped:(id)object
{
    [maskView hiddenMask];
    [inputText resignFirstResponder];
}

- (NSArray *)sort:(NSArray *)oldArr {
	NSMutableArray *newArr = [NSMutableArray array];
	id tmpObj;
	tmpObj = [oldArr objectAtIndex:0];
	NSMutableArray *tmpArr = [NSMutableArray array];
	for (int i = 0; i < oldArr.count; i++) {
		if ([tmpObj isEqual:oldArr[i]]) {
			[tmpArr addObject:oldArr[i]];
		}
		else {
			[newArr addObject:tmpArr];
			tmpArr = [NSMutableArray array];
			[tmpArr addObject:oldArr[i]];
			tmpObj = oldArr[i];
		}
	}
	[newArr addObject:tmpArr];
	return newArr;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)note{

//    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat ty = - rect.size.height;
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
//    }];
    if (!maskView) {
        maskView= [[MaskView alloc] initWithFrame:CGRectMake(0, 0, list.frame.size.width, list.frame.size.height)];
        maskView.delegate=self;
    }
    [maskView showInView:self.view];
}

- (void)keyboardWillHide:(NSNotification *)note{

    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    [maskView hiddenMask];
}

#pragma mark - Memory Management

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
