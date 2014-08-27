//
//  D2_ChatViewController.m
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_ChatViewController.h"
#import "D2_ChatMessageFrame.h"
#import "D2_ChatMessage.h"
#import "D2_ChatMessageCell.h"
#import "D2_ChatInputView.h"
#import "MaskView.h"
#import "bee.h"
//#import "D2_MsgLoadingView.h"
#import "PostpmModel.h"
#import "UserModel.h"
//#import "KGStatusBar.h"
#import "KGStatusBar.h"
#import "DZ_Timer.h"
#import "UIMenuItem+Object.h"
#define CHATINPUTHEIGHT 44
@interface D2_ChatViewController ()<UITextFieldDelegate,MaskViewDelegate,D2_ChatInputViewDelegate,DZ_TimerDelegate,D2_ChatMessageCellDelegate>
{
     NSMutableArray  * _allMessagesFrame;
     D2_ChatInputView * chatInputArea;
     MaskView         * maskview;
    
}
@property(nonatomic,assign) DZ_Timer * refreshtimer;
@property(nonatomic,strong) PostpmModel *postpmmodel;
//@property (nonatomic, strong) D2_MsgLoadingView *loadingView;
@property(nonatomic,strong)AllpmModel * allpmmodel;
@end

@implementation D2_ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - bee.ui.config.baseInsets.top);
    frame.size.height= frame.size.height - CHATINPUTHEIGHT;
    self.tableViewList.frame=frame;
    chatInputArea.frame=CGRectMake(0, self.tableViewList.frame.origin.y + self.tableViewList.frame.size.height, self.view.bounds.size.width, CHATINPUTHEIGHT);
    if (_allMessagesFrame.count) {
       [self.tableViewList scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:_allMessagesFrame.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


-(void)dealloc
{
    [self.refreshtimer invalidateDZ_RefreshmsgTime];
    self.refreshtimer = nil;
    [self.allpmmodel removeObserver:self];
    [self.postpmmodel removeObserver:self];
}

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    if (!self.allpmmodel.loading) {
        [self.allpmmodel getNewMessage];
//        [self.loadingView startAnimation];
    }
}

- (void)viewDidLoad
{
    self.noFooterView=YES;
    [super viewDidLoad];
    self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewList.allowsSelection = NO;
    self.tableViewList.backgroundView = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"chat_bg_default.jpg"]];
    
    [self recoverRigthButtons];
    _allMessagesFrame =  [[NSMutableArray alloc] initWithCapacity:0];
    self.allpmmodel=[AllpmModel modelWithObserver:self];
    
    if (self.chattype == CHATTYPE_FRIEND) {
        [self.allpmmodel loadFriendmsCashe:self.afriend.fuid];        
        self.refreshtimer = [DZ_Timer sharedInstance];
        self.refreshtimer.delegate = self;
        [self.refreshtimer endRefresh];
    }
    else if(self.chattype == CHATTYPE_STRANGER)
    {
        [self.allpmmodel loadFriendmsCashe:self.afriend.fuid];
    }
    
    self.title = [NSString stringWithFormat:@"与%@聊天中...",self.afriend.username];
    LASFLASHDATA *date=[[LASFLASHDATA alloc] init];
    date.nowdate=[NSNumber numberWithInt:1];
    self.allpmmodel.nowdate=date;
    [self loadData];
    [self.allpmmodel firstPage];
    
//    [self.tableViewList setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];//滚动到底部
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
     chatInputArea=[[D2_ChatInputView alloc] initWithFrame:CGRectMake(0, self.tableViewList.frame.size.height-CHATINPUTHEIGHT, self.view.bounds.size.width, CHATINPUTHEIGHT)];
    chatInputArea.delegate=self;
    [self.view addSubview:chatInputArea];
    [self.view bringSubviewToFront:chatInputArea];
    
    self.postpmmodel = [PostpmModel modelWithObserver:self];
    [self.postpmmodel loadCache];

}


-(void)refreshMessage:(DZ_Timer *)dztimer
{
//    self.allpmmodel.type = [NSString stringWithFormat:@"%d",DATA_RECENTDATE];
//    [self.allpmmodel getNewMessage];
    [self refreshView];
}

-(void)setAfriend:(friends *)afriend
{
    _afriend=afriend;
}
-(void)loadData
{
    NSString *previousTime = nil;
    NSArray *array= nil;
    if (self.chattype == CHATTYPE_FRIEND) {
        if (!self.allpmmodel.agoodfriendms.count) {
            return;
        }
        array=[self.allpmmodel.agoodfriendms objectAtIndex:0];
        if (!array.count) {
            return;
        }
        [_allMessagesFrame removeAllObjects];
        for (friendms *dict in array) {
            D2_ChatMessageFrame *messageFrame = [[D2_ChatMessageFrame alloc] init];
            D2_ChatMessage *message = [[D2_ChatMessage alloc] init];
            message.dict = dict;
            messageFrame.showTime = ![previousTime isEqualToString:message.time];
            message.content = message.content;
            messageFrame.message = message;
            previousTime = message.time;
            [_allMessagesFrame addObject:messageFrame];
        }
    }
    else if(self.chattype == CHATTYPE_STRANGER)
    {
        if (!self.allpmmodel.astrangermessages.count) {
            return;
        }
        array=self.allpmmodel.astrangermessages;
        if (!array.count) {
            return;
        }
        [_allMessagesFrame removeAllObjects];
        for (strangerms *dict in array) {
            D2_ChatMessageFrame *messageFrame = [[D2_ChatMessageFrame alloc] init];
            D2_ChatMessage *message = [[D2_ChatMessage alloc] init];
            friendms *afriend = [[friendms alloc] init];
            afriend.avatar = dict.avatar;
            afriend.message = dict.message;
            afriend.dateline = dict.dateline; 
            message.dict = afriend;
            messageFrame.showTime = ![previousTime isEqualToString:message.time];
            message.content = message.content;
            messageFrame.message = message;
            previousTime = message.time;
            [_allMessagesFrame addObject:messageFrame];
        }
    }

   
}

ON_SIGNAL3(AllpmModel, FAILED, signal)
{
    [self FinishedLoadData];
    [self recoverRigthButtons];
}
ON_SIGNAL3(AllpmModel, RELOADED, signal)
{
    [self loadData];
    [self recoverRigthButtons];
    [self.tableViewList reloadData];
    
    if (_allMessagesFrame.count) {
        [self.tableViewList scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:_allMessagesFrame.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
//    [self.tableViewList setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];//滚动到底部
    [self FinishedLoadData];
    
}

-(void)recoverRigthButtons
{
//    [BeeUINavigationBar setButtonSize:CGSizeMake(30, 30)]; 
   /*if (!self.loadingView) {
        [BeeUINavigationBar setButtonSize:CGSizeMake(40, 40)];
        self.loadingView = [[D2_MsgLoadingView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self showBarButton:BeeUINavigationBar.RIGHT view:self.loadingView];
    }
    else
    {
        [self.loadingView stopAnimation];
    }*/
}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.tableViewList.frame
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - bee.ui.config.baseInsets.top);
        frame.size.height= frame.size.height - CHATINPUTHEIGHT + ty;
        self.tableViewList.frame=frame;
        chatInputArea.frame = CGRectMake(0, CGRectGetMaxY(_tableViewList.frame), self.view.bounds.size.width, CHATINPUTHEIGHT);
//        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    if (!maskview) {
        maskview= [[MaskView alloc] initWithFrame:CGRectZero];
        maskview.delegate=self;
    }
    [maskview showInView:self.view belowSubview:chatInputArea];
//    [maskview showInView:self.view];
}

#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - bee.ui.config.baseInsets.top);
        frame.size.height= frame.size.height - CHATINPUTHEIGHT ;
        self.tableViewList.frame=frame;
        chatInputArea.frame = CGRectMake(0, CGRectGetMaxY(_tableViewList.frame), self.view.bounds.size.width, CHATINPUTHEIGHT);
//        self.view.transform = CGAffineTransformIdentity;
    }];
    [maskview hiddenMask];
}


-(void)MaskViewDidTaped:(id)object
{
    [maskview hiddenMask];
    maskview=nil;
    [chatInputArea resignFirstReponder];
}

ON_SIGNAL3(MaskView, MASKVIEWTAP, signal)
{
    [chatInputArea resignFirstReponder];
}

-(BOOL)D2_ChatInputdShouldSendMessage:(UITextView *)textField
{
    // 1、增加数据源
    NSString *content = textField.text;
    if (!textField.text.length) {
        [self presentMessageTips:@"请输入文字"];
        return NO;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:date];
    [self addMessageWithContent:content time:time];
    // 2、刷新表格
    [self.tableViewList reloadData];
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [self.tableViewList scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    // 4、清空文本框内容
     textField.text = nil;
    return YES;
}
#pragma mark  - 消息发送
ON_SIGNAL3(PostpmModel, RELOADED, signal)
{
    [KGStatusBar showSuccessWithStatus:@"发送成功!"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageSendSuccess:)]) {
        [self.delegate messageSendSuccess:self];
    }
}

ON_SIGNAL3(PostpmModel, FAILED, signal)
{    
    [KGStatusBar showSuccessWithStatus:signal.object];
}


#pragma mark 发送消息 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    
    self.postpmmodel.uid=[UserModel sharedInstance].session.uid;
    self.postpmmodel.touid=_afriend.fuid;
    self.postpmmodel.message=content;
    //去掉表情头尾

    D2_ChatMessageFrame *mf = [[D2_ChatMessageFrame alloc] init];
    D2_ChatMessage *msg = [[D2_ChatMessage alloc] init];
    msg.content = content;
    msg.time = time;
    msg.icon = [UserModel sharedInstance].session.avatar;
    msg.type = MessageTypeMe;
    mf.message = msg;
    [_allMessagesFrame addObject:mf];
     
    [self.postpmmodel firstPage];
}

#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    D2_ChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[D2_ChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.indexPath = indexPath;
    }
    // 设置数据
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)handleCopyCell:(id)sender
{//复制cell
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =self.selectString;
}

-(void)cellDidLongPress:(D2_ChatMessageCell *)cell recoginzer:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [cell becomeFirstResponder];
        /*给sel 传递多个参数*/
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(handleCopyCell:)];
//        itCopy.object = cell.messageFrame.message.content;
        UIMenuController *menu = [UIMenuController sharedMenuController];
        self.selectString = cell.messageFrame.message.content;
        [menu setMenuItems:[NSArray arrayWithObjects:itCopy,nil]];
        CGRect rect = cell.frame;
        [menu setTargetRect:rect inView:self.tableViewList];
        [menu setMenuVisible:YES animated:YES];
    }   
}


- (void)handleDeleteCell:(id)sender{//删除cell
    NSLog(@"handle delete cell");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//刷新调用的方法
-(void)refreshView{
//     self.allpmmodel.type = [NSString stringWithFormat:@"%d",DATE_ALLDATE];
    [self.allpmmodel firstPage];
    [KGStatusBar showSuccessWithStatus:@"消息刷新中..."];
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
