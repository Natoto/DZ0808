//
//  A2_PlatesSelectBoard_iphone.m
//  DZ
//
//  Created by Nonato on 14-4-18.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "A2_PlatesSelectBoard_iphone.h"
#import "Bee.h"
#import "AppBoard_iPhone.h"

@interface A2_PlatesSelectBoard_iphone ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSArray *sections;
@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) UITableView *list;
@end

@implementation A2_PlatesSelectBoard_iphone

DEF_MODEL(ForumsModel, fmModel);

- (void)load
{
    self.fmModel =[ForumlistModel modelWithObserver:self]; 
}
- (void)unload
{
	self.fmModel	= nil;
}
ON_SIGNAL3(ForumlistModel, RELOADED, signal)
{
    [self.list reloadData];
}

ON_WILL_APPEAR( signal )
{
    if (NO == self.fmModel.loaded) {
        [self.fmModel firstPage];
    }
}

ON_LEFT_BUTTON_TOUCHED(signal)
{
    [bee.ui.appBoard hideForumPlatesSelect:self save:NO];
}

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(saveHomePageUserModel:)]) {
        [self.delegate saveHomePageUserModel:self.ModeleBlocks];
    }
    [bee.ui.appBoard hideForumPlatesSelect:self save:YES];
}

ON_SIGNAL2(BeeUIBoard, signal)
{
    if ([signal is:BeeUIBoard.CREATE_VIEWS]) {
        
        _list=[[UITableView alloc] init]; 
        _list.dataSource=self;
        _list.delegate=self;
        if (IOS7_OR_LATER) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_6_1
#else
            _list.separatorInset = UIEdgeInsetsZero;
#endif
        }
        [self showBarButton:BeeUINavigationBar.LEFT title:__TEXT(@"cancel")];//取消
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"confirm")];//确定
        self.navigationBarShown = YES;
        [self.view addSubview:_list];
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationBarTitle = @"选择模块";
        self.navigationBarShown = YES;
        [self showNavigationBarAnimated:NO];
       
//        _sections = [NSArray arrayWithObjects:__TEXT(@"setting_0plates"), __TEXT(@"setting_1plates"), __TEXT(@"setting_2plates"), nil];//无限创意，设计利器，新闻作品
        _sections = @[__TEXT(@"setting_0plates"), __TEXT(@"setting_1plates"), __TEXT(@"setting_2plates")];
//        _array = [NSArray arrayWithObjects:@"A", @"B", @"C", nil];
        _array = @[@"A", @"B", @"C"];

        _selectedFiddic = [[NSMutableDictionary alloc] init];
        if (self.delegate) {
            _ModeleBlocks = [[NSMutableArray alloc] initWithArray:self.delegate.ModeleBlocks];
        }
        for (HOME2TOPICSPOSITIONITEM *item in _ModeleBlocks) {
            [_selectedFiddic setObject:@"1" forKey:item.fid];
        }
    }
    else if ([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
//        UIEdgeInsets edge=bee.ui.config.baseInsets;
//        _list.contentInset = edge;
        _list.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        _list.separatorInset = UIEdgeInsetsZero;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    forums *aforums = [self.fmModel.shots objectAtIndex:section];
    return aforums.child.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idtifier = @"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idtifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idtifier];

    }
    forums *aforums = [self.fmModel.shots objectAtIndex:indexPath.section];
    child *childforums = [aforums.child objectAtIndex:indexPath.row];
    NSString *mark = [self.selectedFiddic valueForKey:childforums.fid];
    cell.accessoryType = mark.intValue ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",childforums.name];
//    cell.textLabel.font = GB_FontHelveticaNeue(12);//[UIFont systemFontOfSize:12];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    BeeLog(@"%d",_sections.count);
    return self.fmModel.shots.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    forums *aforums=[self.fmModel.shots objectAtIndex:section];
    return   aforums.name;
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
    UILabel *_textlabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
    forums *aforums=[self.fmModel.shots objectAtIndex:section];
//    _textlabel.font=[UIFont boldSystemFontOfSize:15];
    _textlabel.font = [UIFont systemFontOfSize:15];
    _textlabel.text=[NSString stringWithFormat:@"%@",aforums.name];
    _textlabel.backgroundColor=[UIColor clearColor];
    [headerView addSubview:_textlabel];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType==UITableViewCellAccessoryNone) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        if (self.delegate) {
            HOME2TOPICSPOSITIONITEM *item=[[HOME2TOPICSPOSITIONITEM alloc] init];
            forums *aforums=[self.fmModel.shots objectAtIndex:indexPath.section];
            child *childforums=[aforums.child objectAtIndex:indexPath.row];
            item.subject=childforums.name;
            item.title=childforums.name;
//            item.icon=childforums.icon;
            item.fid=childforums.fid;
            item.enableDelete=@"1";
            [_selectedFiddic setObject:@"1" forKey:item.fid]; 
            for (HOME2TOPICSPOSITIONITEM *tempitem in _ModeleBlocks) {
                if ([tempitem.fid isEqualToString:item.fid]) {
                    [_ModeleBlocks removeObject:tempitem];
                    return;
                }
            }
            [_ModeleBlocks insertObject:item atIndex:1];
        }
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        if (self.delegate) {
            HOME2TOPICSPOSITIONITEM *item=[[HOME2TOPICSPOSITIONITEM alloc] init];
            forums *aforums=[self.fmModel.shots objectAtIndex:indexPath.section];
            child *childforums=[aforums.child objectAtIndex:indexPath.row];
            item.subject=childforums.name;
            item.title=childforums.name;
            item.icon=childforums.icon;
            item.fid=childforums.fid;
            item.enableDelete=@"1";
            [_selectedFiddic setObject:@"0" forKey:item.fid];
            for (HOME2TOPICSPOSITIONITEM *tempitem in _ModeleBlocks) {
                if ([tempitem.fid isEqualToString:item.fid]) {
                    [_ModeleBlocks removeObject:tempitem];
                    break;
                }
            }
        }
    }

//    [bee.ui.appBoard hideForumPlatesSelect];
}


ON_NOTIFICATION3(ForumsModel, FORUMS, notification)
{
    [self.list reloadData];
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
