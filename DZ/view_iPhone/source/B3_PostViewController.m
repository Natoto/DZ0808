//
//  B2_PostViewController.m
//  DZ
//
//  Created by Nonato on 14-4-23.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "D1_FriendsInfoViewController.h"
#import "B4_PreviewImageView.h"
#import "B3_PostViewController.h"
#import "RCLabel.h"
#import "B3_PostMenuView.h"
#import "AppBoard_iPhone.h"
#import "D1_LoginBoard_iphone.h"
#import "B3_PostReplyViewController.h"
#import "UserModel.h"
#import "D2_Share.h"
#import "rmbdz.h"
#import "DZ_Timer.h"
#import "PostlistModel.h"
#import "collect.h"
#import "B3_QuickReplyView.h"
#import "MaskView.h"
#define REPLYAREAHEIGHT 40

//extern BOOL isHeader;
extern NSInteger support;

@interface B3_PostViewController ()<FaceBoardDelegate,MaskViewDelegate>
{
    float historyY;
    BOOL  replyMode;
    B4_PreviewImageView *previewView;
    B3_PostMenuView * menuView;
    UIButton * toTopbtn;
    UIButton * sendbtn;
//    NSTimer  * timer;
//    NSInteger  indexTimer;
    BOOL isHeader;
    NSUInteger index;
}

@property (nonatomic,retain) post * friendpost;
@property (nonatomic,retain) UserModel * usermodel;

@end

@implementation B3_PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    menuView.isfavorite = self.postmodel.maintopic.isfavorite;
    [menuView showInView:self.view];
//    self.postmodel.maintopic.isfavorite = menuView.isfavorite;
}

#pragma mark - 菜单: 只看楼主 回复 分享 收藏

ON_NOTIFICATION3(B3_PostMenuView, onlyReadBuildingOwner, signal)
{
    self.postmodel.tid=self.tid;
    self.postmodel.onlyauthorid= self.postmodel.maintopic.authorid;
    [self.postmodel loadCache];
    [self.postmodel firstPage];
//    [titleBtn setTitle:@"只看楼主" forState:UIControlStateNormal];
    self.title = @"只看楼主";
}

ON_NOTIFICATION3(B3_PostMenuView, allRead, signal)
{
//    [titleBtn setTitle:@"全部" forState:UIControlStateNormal];
    self.title = @"全部";
    [self refreshView];
}

ON_NOTIFICATION3(B3_PostMenuView, reply, signal)
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        [self showAlertView];
        return;
    }
    B3_PostReplyViewController *ctr=[[B3_PostReplyViewController alloc] init];
    ctr.fid = self.fid;
    ctr.tid = self.tid;
    [self.navigationController pushViewController:ctr animated:YES];
}

ON_NOTIFICATION3(B3_PostMenuView, share, signal)
{
#warning here
    D2_Share *share = [[D2_Share alloc] init];
    share.title = self.postmodel.maintopic.title;
//    content *aconent = nil;
//    share.msg = aconent.msg;
    share.tid = self.tid;
    share.hasTid = YES;
    [self.navigationController pushViewController:share animated:YES];
//    [self dismissTips];
//    [self presentMessageTips:@"此功能暂未开放"];
}

#pragma mark - 收藏与取消收藏
ON_NOTIFICATION3(B3_PostMenuView, collect, signal)
{
    NSString *username = [UserModel sharedInstance].session.username;

    if (!username) {
        [self showAlertView];
        return;
    }
    else
    {
        self.collectModel = [collectModel modelWithObserver:self];
        self.collectModel.tid = self.tid;
        self.collectModel.uid = [UserModel sharedInstance].session.uid;
        NSLog(@"%@", self.postmodel.maintopic.isfavorite);
        if ([self.postmodel.maintopic.isfavorite isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [self presentMessageTips:@"您已收藏本帖子，不可重复收藏"];
        } else {
            [self.collectModel collect];
        }
    }
}

ON_NOTIFICATION3(B3_PostMenuView, delcollection, signal)
{
    NSString *username = [UserModel sharedInstance].session.username;

    if (!username) {
        [self showAlertView];
        return;
    } else {
        self.delcollectionModel = [delcollectionModel modelWithObserver:self];
        self.delcollectionModel.uid = [UserModel sharedInstance].session.uid;
        NSLog(@"123123123%@", [UserModel sharedInstance].session.uid);
        if (self.collectModel.favid != 0) {
            self.delcollectionModel.favid = self.collectModel.favid;
            NSLog(@"aaabbbccc%@", self.delcollectionModel.favid);
            NSLog(@"aaabbbccc%@", self.collectModel.favid);
        } else {
            self.delcollectionModel.favid = (NSNumber *)self.postmodel.maintopic.favid;
            NSLog(@"aaabbbccc%@", self.delcollectionModel.favid);
            NSLog(@"aaabbbccc%@", (NSNumber *)self.postmodel.maintopic.favid);
        }
        [self.delcollectionModel delcollection];
    }
}

/*
#pragma mark 点赞

ON_NOTIFICATION3(B3_PostBaseTableViewCell, SUPPORT, notify)
{
    NSString *username = [UserModel sharedInstance].session.username;
    isHeader = [notify.object boolValue];
    if (!username) {
        [self showAlertView];
        return;
    } else {
        self.supportModel = [SupportModel modelWithObserver:self];
        self.supportModel.tid = self.tid;
        self.supportModel.pid = self.pid;
        self.supportModel.type = self.type;
    }
    [self.supportModel firstPage];
}
 */

ON_SIGNAL3(collectModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"success")];//收藏成功
    self.isSelected = YES;
    self.postmodel.maintopic.isfavorite = [NSNumber numberWithInt:1];
//    [self.postmodel firstPage];
}

ON_SIGNAL3(collectModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"fail")];//收藏失败，请重试
    self.isSelected = NO;
}

ON_SIGNAL3(delcollectionModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"success")];//已取消收藏
    self.isSelected = YES;
    self.postmodel.maintopic.isfavorite = 0;
//    [self.postmodel firstPage];
}

ON_SIGNAL3(delcollectionModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"fail")];//取消收藏失败
    self.isSelected = NO;
}

ON_SIGNAL3(SupportModel, RELOADED, signal)
{
    [self dismissTips];
//    [self presentMessageTips:@"点赞成功"];

//    isHeader ? [[B3_PostBaseTableViewCell sharedInstance].btnsupport setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/weidingtie(02)@2x" ofType:@"png"]] forState:UIControlStateNormal] : [[B3_PostBaseTableViewCell sharedInstance].btnsupport setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/dingtie@2x" ofType:@"png"]] forState:UIControlStateNormal];

    [B3_PostBaseTableViewCell sharedInstance].lblsupport.text = [NSString stringWithFormat:@"%d", support + 1];

    if (isHeader)
    {
//        B3_PostTableView_HeadCell *cell = [[B3_PostTableView_HeadCell alloc] init];
//        [cell B3_PostTableView_HeadCell:^(id sender) {
//            [(UIButton *)sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/weidingtie(02)@2x" ofType:@"png"]] forState:UIControlStateNormal];
//        }];
        [[B3_PostBaseTableViewCell sharedInstance].btnsupport setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/weidingtie(02)@2x" ofType:@"png"]] forState:UIControlStateNormal];
        self.postmodel.maintopic.status = @0;
        self.postmodel.maintopic.support = @(self.postmodel.maintopic.support.integerValue + 1);
    }
    else
    {
//        B3_PostTableView_Cell *cell = [[B3_PostTableView_Cell alloc] init];
//        [cell B3_PostTableView_Cell:^(id sender) {
//            [(UIButton *)sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/dingtie@2x" ofType:@"png"]] forState:UIControlStateNormal];
//        }];
        [[B3_PostBaseTableViewCell sharedInstance].btnsupport setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/dingtie@2x" ofType:@"png"]] forState:UIControlStateNormal];
        post *post = self.postmodel.shots[index];
        post.support = @(post.support.integerValue + 1);
        post.status = @0;
    }
}

ON_SIGNAL3(SupportModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:[NSString stringWithFormat:@"%@",self.supportModel.shots.emsg]];
}

//显示提示框
- (void)showAlertView
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您还没有登录，是否现在登录？"
                                                       delegate:self
                                              cancelButtonTitle:@"不了"
                                              otherButtonTitles:@"好的", nil];
    alertview.tag = 1338;
    [alertview show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1338) {
        if (buttonIndex == 1) {
            [bee.ui.appBoard showLogin];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.postmodel firstPage];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [replayField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}

- (void)viewDidLoad
{
//    self.noFooterView=YES;
    [super viewDidLoad];
    
    self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor=[UIColor whiteColor];
    self.postmodel=[PostlistModel modelWithObserver:self];
    self.postmodel.tid=self.tid;
    
    [self.postmodel loadCache];
    self.usermodel=[UserModel modelWithObserver:self];
    menuView=[[B3_PostMenuView alloc] initWithFrame:CGRectMake(250, 20, 60, 100)];
    
    _cellsHeightDic=[[NSMutableDictionary alloc] initWithCapacity:0];
    for (int i=0; i<self.postmodel.shots.count; i++) {
        [_cellsHeightDic setObject:[NSNumber numberWithFloat:60] forKey:[NSString stringWithFormat:@"%d",i]];
    }
//    B3_QuickReplyView *replyview = [[B3_QuickReplyView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height- 2*REPLYAREAHEIGHT,self.view.bounds.size.width, REPLYAREAHEIGHT)];
//    [self.view addSubview:replyview];
//    [self.view bringSubviewToFront:replyview];
    
    replyArea= [self addReplayEditArea:CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT,self.view.bounds.size.width, REPLYAREAHEIGHT)]; 
    [self.view addSubview:replyArea];
    [self.view bringSubviewToFront:replyArea];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];

    [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage bundleImageNamed:@"caidan"]];
    [self observeNotification:[B3_PostMenuView sharedInstance].onlyReadBuildingOwner];
    [self observeNotification:[B3_PostMenuView sharedInstance].reply];
    [self observeNotification:[B3_PostMenuView sharedInstance].share];
    [self observeNotification:[B3_PostMenuView sharedInstance].collect];
    [self observeNotification:[B3_PostMenuView sharedInstance].delcollection];
    [self observeNotification:[B3_PostMenuView sharedInstance].allRead];
//    self.astatus = [[B3_PostBaseTableViewCell alloc] init];
//    [self observeNotification:self.astatus.SUPPORT];

    toTopbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    toTopbtn.frame=CGRectMake(280,self.view.bounds.size.height-REPLYAREAHEIGHT-70, 40, 40);
    [toTopbtn setImage:[UIImage bundleImageNamed:@"huidaoshouye-02"] forState:UIControlStateNormal];
    [toTopbtn addTarget:self action:@selector(titleBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    toTopbtn.hidden=YES;
    [self.view addSubview:toTopbtn];
//    [self.view bringSubviewToFront:toTopbtn];
    
    self.title = @"全部";
//    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    titleBtn.frame=CGRectMake(100, 0, 200, self.navigationController.navigationBar.bounds.size.height);
//    titleBtn.center =CGPointMake(320.0/2.0, self.navigationController.navigationBar.bounds.size.height/2.0);
//    [titleBtn setTitle:@"全部" forState:UIControlStateNormal];
//    [titleBtn addTarget:self action:@selector(titleBtnTap:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.titleView = titleBtn;

    maskview=[[MaskView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    maskview.delegate = self;
//    [self.view insertSubview:maskview aboveSubview:self.tableViewList];
//    bgtransparencyView.hidden=YES;
    
    facialView=[[FaceBoard alloc] init];
    facialView.delegate = self;
    facialView.inputTextView=replayField;
    [self setTable2ReplyViewalpha:0.0];
    [self setFooterView];
}

-(void)setTable2ReplyViewalpha:(float)alpha
{
    self.tableViewList.alpha = alpha;
    replyArea.alpha = alpha;
    if (alpha ==0){
        [self presentLoadingTips:__TEXT(@"loading")];//加载中……
    }
    else
    {
        [self dismissTips];
    }
}
-(IBAction)titleBtnTap:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableViewList setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
            [self.tableViewList setContentOffset:CGPointMake(0, 0)];
    }];
}

-(void)dealloc
{
//    [timer invalidate];
    [maskview hiddenMask];
    [self.postmodel removeObserver:self];
    [self.usermodel removeObserver:self];
    [self.collectModel removeObserver:self];
    [self.delcollectionModel removeObserver:self];
}

-(void)keybordWillAppear:(NSNotification *)notify
{
    replyMode=YES;
    NSDictionary* info  =  [notify userInfo];
    CGSize keyBoardSize =  [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
//    bgtransparencyView.hidden=NO;
    replyArea.frame=CGRectMake(0, self.view.bounds.size.height-keyBoardSize.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
    [maskview showInView:nil];
    maskview.frame = CGRectMake(0, 0, keyBoardSize.width,CGRectGetHeight(self.view.window.bounds) - keyBoardSize.height-REPLYAREAHEIGHT);
   [UIView commitAnimations];
}
-(void)resignAll:(UIGestureRecognizer *)gesture
{
    [replayField resignFirstResponder];
    [maskview hiddenMask];
//      bgtransparencyView.hidden=YES;
//    bgtransparencyView=nil;
}

-(void)keybordWillDisAppear:(NSNotification *)notify
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
//     bgtransparencyView.hidden=YES;
    [maskview hiddenMask];
    replyArea.frame=CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
     replyMode=NO;
    [UIView commitAnimations];
}

#pragma mark - 回复点击
//-(void)timerFired:(NSTimer *)theTimer
//{
//    if (indexTimer <= 0) {
//        [timer invalidate];
//        return;
//    }
//    indexTimer --;
//}
-(IBAction)replybtnTap:(id)sender
{
    replayField.text=replayField.text.trim;
    if (replayField.text.length == 0) {
        [replayField resignFirstResponder];
        return;
    }
    if ([NSString unicodeLengthOfString:replayField.text]<10) {
        [self presentMessageTips:@"回复不得小于10个字"];
        [replayField resignFirstResponder];
        return;
    }
    int indexTimer = [DZ_Timer sharedInstance].replycount;
    if (indexTimer >0 ) {
        [self presentMessageTips:[NSString stringWithFormat:@"%ds 后可以回复",indexTimer]];
        return;
    }
    self.reply_model=[replyModel modelWithObserver:self];
    self.reply_model.tid=self.postmodel.maintopic.tid;
    self.reply_model.fid=self.postmodel.maintopic.fid;
    self.reply_model.authorid=[[UserModel sharedInstance] session].uid; //@"1";
    self.reply_model.pid  = @"";
    //此处回复只针对楼主
    self.friendpost = nil;
    if (self.friendpost) {
       self.reply_model.pid = self.friendpost.pid.length?self.friendpost.pid:self.postmodel.maintopic.pid;
       replayField.placeholder = [NSString stringWithFormat:@"回复%@...", self.friendpost.authorname];
    }
    
    NSMutableArray *contentTextAry= [self spliteFacialandText:replayField.text];
    //compants
    self.reply_model.contents=contentTextAry;
    [self.reply_model firstPage];
    [replayField resignFirstResponder];
    [self presentLoadingTips:@"回复中..."];
}

- (NSMutableArray *)spliteFacialandText:(NSString *)text
{
    NSArray *compants=[text componentsSeparatedByString:@" "];
    NSMutableArray *contentTextAry=[[NSMutableArray alloc] initWithCapacity:0];
    
    if (compants.count==0) {
        replyContent *acont1=[[replyContent alloc] init];
        acont1.msg=text;
        acont1.type=[NSNumber numberWithInt:0];
        [contentTextAry addObject:acont1];
    }
    for (int index = 0; index < compants.count; index ++) {
        NSString *key=[compants objectAtIndex:index];
        NSString *isfacion=[FaceBoard isExistFacail:key];
        if (!isfacion) {//不是表情
            replyContent *acont1=[[replyContent alloc] init];
            acont1.msg=key;
            acont1.type=[NSNumber numberWithInt:0];
            [contentTextAry addObject:acont1];
        }
        else//是表情
        {
            replyContent *acont1=[[replyContent alloc] init];
            acont1.msg=isfacion;
            acont1.type=[NSNumber numberWithInt:0];
            [contentTextAry addObject:acont1];
        }
    }
    return contentTextAry;
}

#pragma mark - 开始回复


ON_SIGNAL3(UserModel, LOGIN_RELOADED, signal)
{
    [replayField resignFirstResponder];
    [self.postmodel firstPage];
}

ON_SIGNAL3(replyModel, FAILED, signal)
{
    self.friendpost=nil;
    [self dismissTips];
    replyModel *amodel=(replyModel *)signal.sourceViewModel;
    NSString *tips=[NSString stringWithFormat:@"%@",amodel.shots.emsg];
    [self presentFailureTips:tips];
//    indexTimer = 0;
}

ON_SIGNAL3(replyModel, RELOADED, signal)
{
    self.friendpost=nil;
    [self dismissTips];
    [self presentSuccessTips:__TEXT(@"success")];//发布成功
    replayField.text=@"";
    [self.postmodel firstPage];
    canscrollTableToFoot=YES;
    [[DZ_Timer sharedInstance] endReply];
//    indexTimer = 15;
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
//    [timer fire];
}
#pragma mark - 输入框
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (![UserModel sharedInstance].session.uid) {
        [bee.ui.appBoard showLogin];
       return NO;
   }
    else
    {
       replayField.placeHolderLabel.alpha = 0.0f;
      [sendbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return YES;
}

//ON_SIGNAL3(BeeUITextView, DID_ACTIVED, signal)
//{
//    if (![UserModel sharedInstance].session.uid) {
//        [replayField resignFirstResponder];
//        [bee.ui.appBoard showLogin];
//    }
//    else
//    {
//        [sendbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
//}

ON_SIGNAL3(BeeUITextView, DID_DEACTIVED, signal)
{
    [sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)scrollTableToFoot:(BOOL)animated tableview:(UITableView *)Table{
    if (!canscrollTableToFoot) {
        return;
    }
    canscrollTableToFoot=NO;
    NSInteger s = [Table numberOfSections];
    if (s<1) return;
    NSInteger r = [Table numberOfRowsInSection:s-1];
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [Table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (UIView *)addReplayEditArea:(CGRect)frame
{
    UIView *replayArea=[[UIView alloc] initWithFrame:frame];
    replayArea.backgroundColor=[UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1];
    
    sendbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendbtn setTitle:@"回复" forState:UIControlStateNormal];
    sendbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sendbtn.frame=CGRectMake(frame.size.width-55, 5, 60, frame.size.height-10);
    [sendbtn addTarget:self action:@selector(replybtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [replayArea addSubview:sendbtn];
    
    UIButton *_btnFacial=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btnFacial setImage:[UIImage bundleImageNamed:@"biaoqing"] forState:UIControlStateNormal];
    _btnFacial.frame=CGRectMake(5, 5, 30, 30);
    _btnFacial.tag = 1414;
    [replayArea addSubview:_btnFacial];
    [_btnFacial addTarget:self action:@selector(facailBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    BeeUITextView *txtfld=[[BeeUITextView alloc] initWithFrame:CGRectMake(36, 5, 235, frame.size.height-10)];
    txtfld.placeholder=@"这是快捷回复，只能发表情和文字！";
//    txtfld.placeHolderLabel.font = [UIFont systemFontOfSize:20];
//    [txtfld.placeHolderLabel updateConstraints];
    txtfld.backgroundColor=[UIColor whiteColor];
    txtfld.NONEEDUSERETURN = YES;
//    txtfld.delegate=self;
    KT_CORNER_RADIUS(txtfld, 4);
    [replayArea addSubview:txtfld];
    replayField=txtfld;
    replayField.delegate = self;
    return replayArea;
}
#pragma - mark 表情
- (IBAction)facailBtnTap:(id)sender
{
    UIButton *button=(UIButton *)sender;
    if (button.tag == 1414) {
        button.tag = 1415;
        [button setImage:[UIImage bundleImageNamed:@"jianpan"] forState:UIControlStateNormal];
        replayField.inputView =facialView;
    }
    else
    {
        button.tag = 1414;
        [button setImage:[UIImage bundleImageNamed:@"biaoqing"] forState:UIControlStateNormal];
        replayField.inputView = nil;
    }    
    [replayField reloadInputViews];
    [replayField becomeFirstResponder];
}


- (void)faceboardBackface
{
    if (replayField.text.length) {
        NSString *edittext = replayField.text;
        float length=edittext.length;
        edittext=[edittext substringToIndex:length-1];
        replayField.text = edittext;
    }
//    [replayField deleteBackward];
}
- (void)facebuttonTap:(id)sender andName:(NSString *)name
{
    UIButton *button = sender;
    UIImage *stampImage = [button imageForState:UIControlStateNormal];
    if (stampImage) {
//        NSString *msg = [FaceBoard faceFileName:name];
        replayField.text = [replayField.text stringByAppendingString:[NSString stringWithFormat:@"%@ ",name]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载成功

ON_SIGNAL3(PostlistModel, RELOADED, signal)
{ 
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self setTable2ReplyViewalpha:1];
                     }
                     completion:^(BOOL f){
                         [self setTable2ReplyViewalpha:1];
                     }];
    
    for (int i=0; i<self.postmodel.shots.count; i++) {
        [_cellsHeightDic setObject:[NSNumber numberWithFloat:60] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    self.fid = self.postmodel.maintopic.fid;
    menuView.isfavorite = self.postmodel.maintopic.isfavorite;

    if (!self.postmodel.shots.count) {
        self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

    
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(PostlistModel, FAILED, signal)
{
//    [self presentFailureTips:message];
    [self setTable2ReplyViewalpha:1.0];
    [self showErrorTips:signal];
    [self FinishedLoadData];
}

#pragma mark - Table view data source

//加载完成的判断
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    [self scrollTableToFoot:YES tableview:tableView];
    
    if (!replyMode) {
        if (tableView.contentSize.height<self.view.frame.size.height) {
            replyArea.frame=CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.postmodel.shots.count+1;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
//        topic *atopic=self.postmodel.maintopic;
//        float myheadercellheight=120;
//        myheadercellheight= 120 + headercellheight;
//        post *apost = [self.postmodel.mai objectAtIndex:indexPath.row];
        float height = [B3_PostTableView_HeadCell heightOfCell:self.postmodel.maintopic.content];
        height = height + 100 ;
        return height;
//        return headercellheight;
    }
    else
    {
        post *apost = [self.postmodel.shots objectAtIndex:indexPath.row - 1];
        float height = [B3_PostTableView_Cell heightOfCell:apost.content];
        height = height + 60 ;
        return height; 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.row==0) {
         static NSString *headerindeifier=@"postview.header.cell";
         B3_PostTableView_HeadCell *cell =[tableView dequeueReusableCellWithIdentifier:headerindeifier];
         if (!cell) {
              cell=[[B3_PostTableView_HeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerindeifier];
             cell.delegate=self;             
         }
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
         cell.celltopic=self.postmodel.maintopic;
         cell.lblfloortext = [NSString stringWithFormat:@"楼主: "];

         //点赞
         cell.support = self.postmodel.maintopic.support;

         if (cell.celltopic.support != nil)
             cell.status = self.postmodel.maintopic.status;

         [cell reloadsubviews];

         cell.isHeader = YES;

         return cell;
     }
     else
     {
         static NSString *indeifier=@"postview.cell";
         B3_PostTableView_Cell *cell =[tableView dequeueReusableCellWithIdentifier:indeifier];
         if (!cell) {
             cell=[[B3_PostTableView_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indeifier];
             cell.delegate=self;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
         }
         cell.cellIndex=[NSString stringWithFormat:@"%d",indexPath.row-1];
         cell.cellpost=[self.postmodel.shots objectAtIndex:indexPath.row - 1];
         cell.lblfloortext = [NSString stringWithFormat:@"%d楼: ",indexPath.row+1];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [cell reloadsubviews];
            });
         //点赞
         cell.support = cell.cellpost.support;
         if (cell.cellpost.support != nil)
             cell.status = cell.cellpost.status;

         return cell;
     }
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (replyMode) {
        return;
    }
    [replayField resignFirstResponder];
    if (replyArea.frame.origin.y == self.view.bounds.size.height-REPLYAREAHEIGHT) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             toTopbtn.hidden=NO;
                             replyArea.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, REPLYAREAHEIGHT);
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.25
                     animations:^{
                         toTopbtn.hidden=YES;
                         replyArea.frame=CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
                     }];

    }
}

#pragma mark - 上滑隐藏回复栏

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (replyMode) {
         return;
    }
    if (historyY+50<targetContentOffset->y)//下拉
    {
        [UIView animateWithDuration:0.25
                         animations:^{
                             toTopbtn.hidden=NO;
                             replyArea.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, REPLYAREAHEIGHT);
                         }];
        
    }
    else if (historyY-50>targetContentOffset->y)//上拉 显示回复框
    {
        [UIView animateWithDuration:0.25
                         animations:^{
                          toTopbtn.hidden=YES;
                          replyArea.frame=CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
                         }];
    }
    historyY = targetContentOffset->y;
}

- (void)B3_HeadCellDidFinishLoad:(CGRect)frame
{
    if (headercellheight!=frame.size.height) {
        headercellheight=frame.size.height;
        [self.tableViewList reloadData];
    }
}

#pragma mark - 查看好友资料

- (void)B3_HeadCellProfileBtnTapped:(B3_PostTableView_HeadCell *)obj
{
     D1_FriendsInfoViewController *ctr = [[D1_FriendsInfoViewController alloc] init];
    ctr.uid=obj.celltopic.authorid;
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)B3_HeadCellReplyButtonTap:(B3_PostTableView_HeadCell *)obj
{
    self.friendpost = nil;
    self.reply_model.pid =@"";
    replayField.placeholder = @"回复楼主...";
    [replayField becomeFirstResponder];
}

//赞楼主
- (void)B3_HeadCellSupportButtonTap:(B3_PostTableView_HeadCell *)obj
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        [self showAlertView];
        return;
    } else {
        self.supportModel = [SupportModel modelWithObserver:self];
        self.supportModel.tid = self.tid;
        self.supportModel.pid = obj.celltopic.pid;
        self.supportModel.type = @"1";
    }
    isHeader = YES;

    [self.supportModel firstPage];
}

- (void)B3_HeadCellHeaderViewTapped:(B3_PostTableView_HeadCell *)object
{
     [self tableView:self.tableViewList didSelectRowAtIndexPath:nil];
}

#pragma mark - 预览图片

- (void)B3_HeadCellShowBigImgview:(NSString *)url imageView:(BeeUIImageView *)imageView
{
    currentindexPath = @"-1";
    [self showPreviewsBigImgview:url imageView:imageView mainTopic:YES];
}

- (void)B3_HeadCell:(B3_PostTableView_HeadCell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url
{
    [self gotoUrlWeb:url];
//     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)gotoUrlWeb:(NSString *)url
{
    url = [url stringByReplacingOccurrencesOfString:@"'" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSURL * gotourl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
    
    if ([self isSelfWebSite:url]) {
        NSString *tid =[self articletid:url];
        if (tid.length) {
            B3_PostViewController *board=[[B3_PostViewController alloc] init];
            board.tid = tid;
            [self.navigationController pushViewController:board animated:YES];
            return;
        }
    }
      [[UIApplication sharedApplication] openURL:gotourl];
}

- (BOOL)isSelfWebSite:(NSString *)url
{
    NSString *regTags = @"http:\\/\\/.*\\/";
    NSError *error;
    NSRegularExpression *regex = [ NSRegularExpression regularExpressionWithPattern:regTags                                                                          options:NSRegularExpressionCaseInsensitive    // 还可以加一些选项，例如：不区分大小写
                                                                              error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    if (matches.count) {
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        NSRange range = [match range];
        NSString * suburl = [url substringWithRange:range];
        NSString *selfurl=[DZ_SystemSetting sharedInstance].websiteurl;
        if ([selfurl rangeOfString:suburl].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)articletid:(NSString *)url
{
    NSString *regTags = @"tid=(\\d+)";
    NSError *error;
    NSRegularExpression *regex = [ NSRegularExpression regularExpressionWithPattern:regTags                                                                          options:NSRegularExpressionCaseInsensitive    // 还可以加一些选项，例如：不区分大小写
                                                                              error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    if (matches.count) {
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        NSRange range = [match range];
        NSString * substr = [url substringWithRange:range];
        NSArray *array = [substr componentsSeparatedByString:@"="];
        if (array.count == 2) {
            return [array objectAtIndex:1];
        }
    }
    return @"";
}

- (void)B3_Cell:(B3_PostTableView_Cell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url
{
//     url = [url stringByReplacingOccurrencesOfString:@"'" withString:@""];
//     url = [url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [self gotoUrlWeb:url];
}

- (void)showPreviewsBigImgview:(NSString *)url imageView:(BeeUIImageView *)imageView mainTopic:(BOOL)maintopic
{
    
    if (imageView.command ==COMMAND_URL && url && [url rangeOfString:@"file://"].location==NSNotFound) {
        NSArray *contentArray = nil;
        if (maintopic || currentindexPath.integerValue < 0) {
            contentArray = self.postmodel.maintopic.content;
        }
        else
        {
            post *apost=[self.postmodel.shots objectAtIndex:currentindexPath.integerValue];
            contentArray = apost.content;
        }
        if (!contentArray.count) {
            return;
        }
        CGRect frame =[UIScreen mainScreen].bounds;
        previewView =[[B4_PreviewImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) withurl:url target:self andSEL:@selector(handleSingleViewTap:) contentAry:contentArray];
        [self.view addSubview:previewView];
        [self.view bringSubviewToFront:previewView];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
         [UIView animateWithDuration:0.5f animations:^{
            previewView.frame =CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        }];
        replyArea.hidden = YES;
    }
    else
    {
        if (imageView.command == COMMAND_NOPERMISSION)
        {
            [self presentMessageTips:@"亲，您没有权限查看附件图片哦！"];
        }
        else if (imageView.command == COMMAND_2G3GNOSEE)
        {
            [self presentMessageTips:@"当前设置2G3G不显示，请在我的->设置修改"];
            //            imageView.command = COMMAND_2G3GCAN;
            //            [imageView GET:url useCache:YES];
        }
        else if (imageView.command == COMMAND_NORMARL)
        {
            [self presentMessageTips:@"亲，您没有权限查看附件图片哦!"];
        }
    }
}

- (void)B3_CellReplyBtnTapped:(B3_PostTableView_Cell *)object
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        [self showAlertView];
        return;
    }
    
    self.friendpost = object.cellpost;
    if (self.friendpost) {
        self.reply_model.pid = self.friendpost.pid.length?self.friendpost.pid:self.postmodel.maintopic.pid;
    }
    B3_PostReplyViewController *ctr=[[B3_PostReplyViewController alloc] init];
    ctr.fid = self.fid;
    ctr.tid = self.tid;
    ctr.pid = self.friendpost.pid;
    ctr.friendpost = self.friendpost;
    ctr.title = [NSString stringWithFormat:@"回复%@",self.friendpost.authorname];
    [self.navigationController pushViewController:ctr animated:YES];
}

//赞楼下
- (void)B3_CellSupportBtnTapped:(B3_PostTableView_Cell *)obj
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        [self showAlertView];
        return;
    } else {
        self.supportModel = [SupportModel modelWithObserver:self];
        self.supportModel.tid = self.tid;
        self.supportModel.pid = obj.cellpost.pid;
        self.supportModel.type = @"2";
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        index = [formatter numberFromString:obj.cellIndex].integerValue;
    }
    isHeader = NO;

    [self.supportModel firstPage];
}

- (void)B3_CellProfileBtnTapped:(B3_PostTableView_Cell *)object
{    
    D1_FriendsInfoViewController *ctr=[[D1_FriendsInfoViewController alloc] init];
    ctr.uid=object.cellpost.authorid;
    [self.navigationController pushViewController:ctr animated:YES];
    
}

//ON_SIGNAL3(BeeUIImageView, LOAD_COMPLETED, signal)
//{
//    CGFloat capWidth = showView.image.size.width ;
//    CGFloat capHeight = showView.image.size.height;
//    showView.frame=CGRectMake(0, 0, capWidth, capHeight);
//    float centerX=MAX(capWidth/2,self.width/2);
//    showView.center=CGPointMake(centerX, self.height/2);
//    if (scrollview.contentSize.width < capWidth) {
//        scrollview.contentSize=CGSizeMake(capWidth, capHeight);
//    }
//}
//ON_SIGNAL3(BeeUIImageView, LOAD_CACHE, signal)
//{
//    [self handleUISignal_BeeUIImageView_LOAD_COMPLETED:signal];
//}
//

- (void)MaskViewDidTaped:(id)object
{
    [replayField resignFirstResponder];
}

- (void)handleSingleViewTap:(UITapGestureRecognizer *)sender
{
    replyArea.hidden = NO;
    [previewView removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//
- (void)B3_CellShowBigImgview:(NSString *)imgurl cell:(B3_PostTableView_Cell *)cell imageview:(BeeUIImageView *)ImageView
{
     currentindexPath = cell.cellIndex;
    [self showPreviewsBigImgview:imgurl imageView:ImageView  mainTopic:NO];
}

- (void)B3_CellHeaderViewTapped:(B3_PostTableView_Cell *)object
{
    [self tableView:self.tableViewList didSelectRowAtIndexPath:nil];
}

- (void)B3_CellDidFinishLoad:(B3_PostTableView_Cell *)cell andheight:(float)height
{
    NSNumber *nbheight=[_cellsHeightDic objectForKey:cell.cellIndex];
    if (nbheight.floatValue != height)
    {
        [_cellsHeightDic setValue:[NSNumber numberWithFloat:height] forKey:cell.cellIndex];
        [self.tableViewList reloadData];

        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:(cell.cellIndex.intValue +1) inSection:0];
        NSArray *array = [NSArray arrayWithObject:indexpath];
        [self.tableViewList reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//刷新调用的方法
- (void)refreshView
{
    self.postmodel.onlyauthorid=nil;
    [self.postmodel firstPage];
}

- (void)getNextPageView
{
    if (self.postmodel.more) {
        [self removeFooterView];
        [self.postmodel nextPage];
    }
    else
    {
//        [self removeFooterView];
//        [self finishReloadingData];
        [self FinishedLoadData];
        [self presentMessageTips:@"没有更多的了"];
    }
}

@end
