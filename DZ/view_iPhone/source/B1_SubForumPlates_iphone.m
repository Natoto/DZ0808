//
//  B0_SonForumPlates_iphone.m
//  DZ
//
//  Created by Nonato on 14-4-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B1_SubForumPlates_iphone.h"
#import "AppBoard_iPhone.h" 

@interface B1_SubForumPlates_iphone ()

@property(nonatomic,retain) NSArray *array;
@property(nonatomic,retain) NSArray *sections;
@property(nonatomic,retain)UITableView *list;

@end

@implementation B1_SubForumPlates_iphone
DEF_MODEL(TopiclistModel, topicModel);

DEF_MODEL(SubForumsModel, subfmModel);
DEF_MODEL(PostlistModel, postmodel);

- (void)load
{
    self.subfmModel =[SubForumsModel modelWithObserver:self];
     self.subfmModel.forum_fid=self.forums.fid;
}


- (void)unload
{
    self.subfmModel.loaded=NO;
}

ON_WILL_APPEAR(signal)
{
    [bee.ui.appBoard hideTabbar]; 
}

ON_DID_APPEAR( signal )
{
    if (NO == self.subfmModel.loaded) {
        self.subfmModel.forum_fid=self.forums.fid;
        [self.subfmModel firstPage];
    }
}


ON_SIGNAL2(BeeUIBoard, signal)
{
    if ([signal is:BeeUIBoard.CREATE_VIEWS]) {
        
        _list=[[UITableView alloc] init];
        _list.dataSource=self;
        _list.delegate=self;
        
        [self.view addSubview:_list];
        
        self.view.backgroundColor = [UIColor grayColor];
        self.navigationBarTitle=@"iOS开发";
        self.navigationBarShown=YES;
        [self showNavigationBarAnimated:NO];
        self.navigationBarShown = YES;
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back"]];
        
        _sections=[NSArray arrayWithObjects:@"无限创意",@"设计利器",@"新闻作品", nil];
        _array=[NSArray arrayWithObjects:@"A",@"B",@"C", nil]; 
    }
    else if ([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
        _list.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idtifier= @"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idtifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idtifier];
//        FORUMS *forums=[self.fmModel.forums objectAtIndex:indexPath.section];
//        FORUMS *childforums=[forums.children objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:12];
    }
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    FORUMS *forums=[self.fmModel.forums objectAtIndex:section];
    return 3;//forums.children.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.postmodel=[PostlistModel modelWithObserver:self];
//    [self.postmodel postlistWithtid:@"2" page:@"1" pageSize:@"20"];
}


ON_MESSAGE3(API, postlist, msg)
{
    if ( msg.sending )
	{
		[self presentLoadingTips:__TEXT(@"tips_loading")];
	}
	else
	{
		[self dismissTips];
	}
}


ON_MESSAGE3(API, subforumlist, msg)
{
    if ( msg.sending )
	{
		[self presentLoadingTips:__TEXT(@"tips_loading")];
	}
	else
	{
		[self dismissTips];
	}
}


ON_NOTIFICATION3(SubForumsModel, SUBFORUMS, notification)
{
    self.navigationBarTitle=self.forums.name;
    [self.list reloadData];
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}
@end
