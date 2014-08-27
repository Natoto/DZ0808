//
//  B0_ForumPlates.m
//  DZ
//
//  Created by Nonato on 14-4-1.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "B0_FormPlatesCell_iPhone.h"
#import "B0_ForumPlates_iphone.h"
#import "Bee.h"
#import "AppBoard_iPhone.h"
#import "ForumlistModel.h"
#import "PullLoader.h"
#import "homeModel.h"
#import "B2_SearchViewController.h"

@interface B0_ForumPlates_iphone ()<B0_FormPlatesCell_iPhoneDelegate>

@property(nonatomic,retain)UITableView *list;
@property(nonatomic,retain)homeModel * homemodel;

@end

@implementation B0_ForumPlates_iphone

DEF_MODEL(ForumsModel, fmModel);
DEF_NOTIFICATION(FORUMREMOVEFROMEHOME)
DEF_NOTIFICATION(FORUMADDTOHOME)

#pragma mark - BeeFramework

- (void)load
{
    self.noFooterView = YES;
    self.fmModel = [ForumlistModel modelWithObserver:self];
}
- (void)unload
{
	self.fmModel = nil;
    [self unobserveAllNotifications];
}

#pragma mark - BeeFramework Macro

ON_NOTIFICATION3(A0_HomePage1_iphone, homepageItemChanged, notify)
{
    BeeLog(@"更新B0_ForumPlates。。。");
    NSMutableArray *blocks = notify.object;
    for (NSString *key in _selectedFiddic.allKeys) {
        [_selectedFiddic setObject:UNMARK forKey:key];
    }
    for (HOME2TOPICSPOSITIONITEM *item in blocks) {
        [_selectedFiddic setObject:MARK forKey:item.fid];
    }
    [self.list reloadData];
}

ON_DID_APPEAR( signal )
{
    if (NO == self.fmModel.loaded) {
        [self.fmModel firstPage];
    } 
    [bee.ui.appBoard showTabbar];
}

ON_SIGNAL2(BeeUIBoard, signal)
{
    if ([signal is:BeeUIBoard.CREATE_VIEWS]) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationBarTitle=@"版块";
        self.navigationBarShown=NO;
        [self showNavigationBarAnimated:NO];
        _selectedFiddic=[[NSMutableDictionary alloc] init]; 
        
        self.homemodel=[homeModel sharedInstance];
        NSMutableArray *blocks =(NSMutableArray *)[self.homemodel arrangedPositions];
//        _ModeleBlocks=[NSMutableArray arrayWithArray:blocks];
        [_selectedFiddic removeAllObjects];
        for (HOME2TOPICSPOSITIONITEM *item in blocks) {
            [_selectedFiddic setObject:MARK forKey:item.fid];
        }
        [self observeNotification:@"notify.A0_HomePage1_iphone.homepageItemChanged"];
        
        [BeeUINavigationBar setButtonSize:CGSizeMake(30, 30)];
        [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage bundleImageNamed:@"sousuo.jpg"]];
    }
    else if ([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
         self.list.frame = CGRectMake(0, 0, self.bounds.size.width, self.frame.size.height - TAB_HEIGHT);
        self.navigationBarShown=YES;
        
    }
    
}


ON_SIGNAL3(BeeUINavigationBar, RIGHT_TOUCHED, signal)
{
    B2_SearchViewController *searchPage = [[B2_SearchViewController alloc] init];
    [self.navigationController pushViewController:searchPage animated:YES];
}

ON_SIGNAL3(ForumlistModel, RELOADED, signal)
{
    [self FinishedLoadData];
    [self.list reloadData];
}
ON_SIGNAL3(ForumlistModel, FAILED, signal)
{
    [self presentMessageTips:[NSString stringWithFormat:@"%@",signal.object]];
    [self FinishedLoadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    forums *aforums=[self.fmModel.shots objectAtIndex:section];
    return aforums.child.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier= @"cell";
    B0_FormPlatesCell_iPhone *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[B0_FormPlatesCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate=self;
    }
    cell.indexPath = indexPath;
    forums *aforums=[self.fmModel.shots objectAtIndex:indexPath.section];
    if (aforums.child) {
        child *achild=[aforums.child objectAtIndex:indexPath.row];
        NSString *mark=[self.selectedFiddic valueForKey:achild.fid];
        if (mark) {
            cell.mark=mark;
        }
        else
        {
            cell.mark = UNMARK;
        }
        cell.achild=achild;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fmModel.shots.count; //self.fmModel.forums.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    forums *aforums = [self.fmModel.shots objectAtIndex:section];
    return aforums.name;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    [headerView setBackgroundColor:[UIColor colorWithRed:224./255. green:224./255. blue:224./255. alpha:1]];
    UILabel *_textlabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 40)];
    forums *aforums=[self.fmModel.shots objectAtIndex:section];
//    _textlabel.font=[UIFont boldSystemFontOfSize:15];
    _textlabel.font = [UIFont systemFontOfSize:16];
    _textlabel.text=[NSString stringWithFormat:@"%@", aforums.name];
    _textlabel.backgroundColor=[UIColor clearColor];
    [headerView addSubview:_textlabel];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    forums *aforums=[self.fmModel.shots objectAtIndex:indexPath.section];
    child  *achild=[aforums.child objectAtIndex:indexPath.row];
    B1_ATopicViewController * board = [[B1_ATopicViewController alloc] init];
    board.forum_fid=achild.fid;
    board.forum_name=achild.name;
    BeeLog(@"child child= %@",achild.child);
    NSArray *childary=(NSArray *)achild.child;
    if ([childary isKindOfClass:[NSArray class]]&& childary.count) {
        board.haveSubForums=YES;
        board.childAry=childary;
    }    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:board animated:YES];
}

#pragma mark - Event

-(void)buttonPressedTap:(id)obj indexPath:(NSIndexPath *)indexPath mark:(BOOL)mark
{
    B0_FormPlatesCell_iPhone *cell=(B0_FormPlatesCell_iPhone *)obj;
    [self.selectedFiddic setObject:[NSString stringWithFormat:@"%d",mark] forKey:cell.achild.fid];
    HOME2TOPICSPOSITIONITEM *item=[[HOME2TOPICSPOSITIONITEM alloc] init];
    
    forums *aforums=[self.fmModel.shots objectAtIndex:indexPath.section];
    child  *achild=[aforums.child objectAtIndex:indexPath.row];
    item.fid = achild.fid;
    item.title = achild.name;
    if (!mark) {//删除一个位置
        [self postNotification:self.FORUMREMOVEFROMEHOME withObject:item];
    }
    else//添加一个版块到主页
    {
       [self postNotification:self.FORUMADDTOHOME withObject:item];
    }
}

//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

//刷新调用的方法
- (void)refreshView
{
    [self.fmModel firstPage];
}

@end
