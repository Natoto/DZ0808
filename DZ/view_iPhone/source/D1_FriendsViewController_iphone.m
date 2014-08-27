//
//  D1_FriendsViewController_iphone.m
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_FriendsViewController_iphone.h"
#import "UserModel.h"
#import "AppBoard_iPhone.h"
#import "D1_FriendsTableViewCell.h"
#import "D2_ChatViewController.h"
#import "AllpmModel.h"
#import "pinyin.h"
#import "ChineseString.h"
#import "D1_FriendsInfoViewController.h"
@interface D1_FriendsViewController_iphone ()<D2_ChatViewControllerDelegate,D1_FriendsTableViewCellDelegate>

@property (nonatomic, strong)   NSArray *key;
@property (nonatomic, strong)   NSMutableArray      *indexarray;
@property (nonatomic, strong)   NSMutableArray      *dataSource;
@property (nonatomic, strong)   NSMutableArray      *dataBase;
@property (nonatomic, strong)   AllpmModel          *allpmmodel;
@property (nonatomic, copy)     NSString            *pinyinString;
@property (nonatomic, strong)   ChineseString       *chineseString;
@property (nonatomic, strong)   NSMutableArray      *result;

@end

@implementation D1_FriendsViewController_iphone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc
{    
    [self.myfriendsModel removeObserver:self];
    [self.allpmmodel cancelRequests];
    [self.allpmmodel removeObserver:self];
}
- (void)viewDidLoad
{
    self.noFooterView = YES;
    [super viewDidLoad];
    self.title=self.newtitle ? self.newtitle : @"我的好友"; 
 
    //改变索引的颜色
//    self.tableViewList.sectionIndexColor = [UIColor grayColor];
    self.tableViewList.sectionIndexTrackingBackgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    //改变索引选中的背景颜色
    self.tableViewList.sectionIndexTrackingBackgroundColor = [UIColor grayColor];
    //索引数组
     _dataSource = [[NSMutableArray alloc] init] ;
    //tableview 数据源
    _dataBase = [[NSMutableArray alloc] init] ;
    
    self.myfriendsModel =[FriendsModel modelWithObserver:self];
    self.myfriendsModel.uid= self.uid; //[UserModel sharedInstance].session.uid;
    [self.myfriendsModel loadCache];
    
    self.dataSource=[self createIndexForList:self.myfriendsModel.shots];
    self.indexarray = [self createIndexArray];
//    [self.myfriendsModel firstPage];
    
    self.allpmmodel=[AllpmModel modelWithObserver:self];
    self.allpmmodel.msgtype =[NSString stringWithFormat:@"%d",MSG_HAOYOU];
    [self.allpmmodel loadCache:MSG_HAOYOU];
//    [self.allpmmodel firstPage];
//    [self.allpmmodel getMessageWithtype:self.allpmmodel.msgtype date:self.allpmmodel.nowdate.nowdate];
  
//    [self.allpmmodel getALLMessageWithtype:MSG_HAOYOU];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)createIndexArray
{
     NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (int index = 'A'; index <= 'Z'; index ++) {
        [categoryArray addObject:[NSString stringWithFormat:@"%c",index]];
    }
    return categoryArray;
}

- (NSMutableArray *)createIndexForList:(NSMutableArray *)array
{//建立右侧的索引
    if (!array.count) {
        return nil;
    }
    //排序
    for (friends *tempobj in array)
    {
        NSString *pinyin = [[NSString alloc] init];
        for (int i = 0; i < tempobj.username.length; i++) {
            NSString *letter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([tempobj.username characterAtIndex:i])] uppercaseString];
            pinyin = [pinyin stringByAppendingString:letter];
        }
        tempobj.pinyin = pinyin;
    }

    array = (NSMutableArray *)[array sortedArrayUsingComparator:^NSComparisonResult(friends *obj1, friends *obj2) {
        if ([obj1.pinyin compare:obj2.pinyin options:NSCaseInsensitiveSearch] > 0) {
            return NSOrderedDescending;
        }
        if ([obj1.pinyin compare:obj2.pinyin options:NSCaseInsensitiveSearch] < 0) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];

    NSLog(@"%@", array);

    //赋值到cell
    //section的数组
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];

    //cell的数组
    if (_dataBase.count) {
        [_dataBase removeAllObjects];        
    }
    if (array.count)
    {
        NSMutableArray *asectioncell=[[NSMutableArray alloc] init];
        friends *tempobj = [array objectAtIndex:0];
        NSString *oldkey = [tempobj.username substringToIndex:1];
        oldkey = [oldkey uppercaseString];
        NSString *newkey = oldkey;
        int i = 0;
        for (friends *tempobj in array)
        {
            newkey = [tempobj.pinyin substringToIndex:1];
            if ([categoryArray containsObject:newkey] == NO)
            {
                if (![oldkey isEqualToString:newkey]) {//两个值不同则保存到字典
                    if (asectioncell.count) {
                        NSMutableArray *tempasectioncell=[[NSMutableArray alloc] initWithArray:asectioncell];
                        [_dataBase addObject:[NSArray arrayWithArray:tempasectioncell]];
                    }
                    [asectioncell removeAllObjects];
                    oldkey=newkey;
                }
                [asectioncell addObject:tempobj];
                [categoryArray addObject:newkey];
                
            } else {
                [asectioncell addObject:tempobj];
            }
            i++;
        }
        //section的数组
        if (asectioncell.count) {
            [_dataBase addObject:[NSArray arrayWithArray:asectioncell]];
        }
    }
    return categoryArray;
}
#define  mark -
-(void)D1_FriendsTableViewCell:(D1_FriendsTableViewCell *)cell avator:(id)sender
{
    NSArray *frdary=[_dataBase objectAtIndex:cell.indexPath.section];
    friends *frd=[frdary objectAtIndex:cell.indexPath.row];
    D1_FriendsInfoViewController *ctr=[[D1_FriendsInfoViewController alloc] init];
    ctr.uid=frd.fuid; 
    [self.navigationController pushViewController:ctr animated:YES];
}
#pragma mark  - FriendsModel

ON_SIGNAL3(FriendsModel, RELOADED, signal)
{
    if (self.myfriendsModel.shots.count) {
        self.dataSource = [self createIndexForList:self.myfriendsModel.shots];
    }
    [self FinishedLoadData];
    [self.tableViewList reloadData];
}

ON_SIGNAL3(FriendsModel, FAILED, pinyinString)
{
    [self FinishedLoadData];
}
#pragma mark  -  AllpmModel

- (void)viewDidCurrentView
{
    if (!self.myfriendsModel.loaded) {
        [self.myfriendsModel firstPage];
    }
    NSLog(@"加载为当前视图 = %@",self.title);
}
-(void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataBase.count>section) {
        NSArray *ary = [_dataBase objectAtIndex:section];
        return ary.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    D1_FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[D1_FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        cell.delegate = self;
        cell.havenewmessage = NO;
    }    
    cell.indexPath = indexPath;
    NSArray *frdary=[_dataBase objectAtIndex:indexPath.section]; //[self.myfriendsModel.shots objectAtIndex:indexPath.row];
    friends *frd=[frdary objectAtIndex:indexPath.row];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    if (!cell.message.text.length) {
        //加载其他的行
        NSMutableArray *afriendms =[[NSMutableArray alloc] initWithCapacity:0];
        [self.allpmmodel loadfriendmsCache:MSG_HAOYOU frienduid:frd.fuid agoodfriendms:afriendms];
        if (afriendms.count) {
            NSArray *amsary = [afriendms lastObject];
            friendms *ams = [amsary lastObject];
            cell.message.text = ams.message;
        }
        else
        {
            cell.message.text = @"";
        }
        cell.havenewmessage = NO;
//     }
        if (self.allpmmodel.nowdate.nowdate.longLongValue != DATE_ALLDATE && self.allpmmodel.friendms.count) {
            NSArray  *amsary = [self newMessage:self.allpmmodel.friendms fuid:frd.fuid];
            if (amsary) {
                //加载有新消息的行
                friendms *ams = [amsary lastObject];
                if (![cell.message.text isEqualToString:ams.message]) {
                    cell.message.text = ams.message;
                    cell.havenewmessage = YES;
                    NSLog(@"frdary%@", ams.message);
                    NSLog(@"%@", cell.message.text);
                }
            }
        }
    });
    
    //上面几行比较耗时
    [cell setcellData:frd];
    return  cell;
}
-(NSArray *)newMessage:(NSArray *)dialogs fuid:(NSString *)fuid
{
//    self.delegate.remindModel.dialog
 
    NSArray *afriendsmsg =nil;
    for (NSArray *adialogs in dialogs) {
        friendms *adialog = [adialogs objectAtIndex:0];
        if ([adialog.touid isEqualToString:fuid] || [adialog.authorid isEqualToString:fuid]) {
            afriendsmsg = adialogs;
            break;
        }
    }
    return afriendsmsg;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    D1_FriendsTableViewCell *cell = ( D1_FriendsTableViewCell *)[self.tableViewList cellForRowAtIndexPath:indexPath];
    cell.havenewmessage = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    D2_ChatViewController *ctr=[[D2_ChatViewController alloc] init];
    NSArray *frdary=[_dataBase objectAtIndex:indexPath.section];
    friends *frd=[frdary objectAtIndex:indexPath.row];
    ctr.delegate = self;
    ctr.indexPath = indexPath;
    ctr.afriend=frd;
    [self.navigationController pushViewController:ctr animated:YES];
}



//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    return _dataSource;
    return _indexarray;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    NSLog(@"%@-%d",title,index);
//    [self presentMessageTips:title];
    for(NSString *character in _dataSource)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [D1_FriendsTableViewCell heightOfFriendsCell];
}

//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_dataSource count];
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_dataSource objectAtIndex:section];
}

#pragma mark - D2_ChatViewController delegate
//没啥作用 数据没有被存储起来
-(void)messageSendSuccess:(D2_ChatViewController *)viewController
{
    NSArray *indexpaths=[NSArray arrayWithObject:viewController.indexPath];
    [self.tableViewList reloadRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

//刷新调用的方法
-(void)refreshView{
//    [self.allpmmodel firstPage];
    [self.allpmmodel getMessageWithtype:self.allpmmodel.msgtype date:self.allpmmodel.nowdate.nowdate];
    [self.myfriendsModel firstPage];
//    [self.allpmmodel getALLMessageWithtype:MSG_HAOYOU];
}

//加载调用的方法
-(void)getNextPageView{
    if (self.myfriendsModel.more) {
        [self removeFooterView];
        [self.myfriendsModel nextPage];
    }
    else
    {
        [self removeFooterView];
        [self finishReloadingData];
        [self presentMessageTips:@"没有更多的了"];
    }
    [self FinishedLoadData];
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
