//
//  A1_WebmasterRecommend_iphone.m
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "A1_WebmasterRecommend_iphone.h"
#import "AppBoard_iPhone.h"
#import "A1_WebmasterRecommend_Cell.h"
#import "A1_WebmasterRecommend_HeaderCell.h"
#import "CommandModel.h"
#import "B3_PostViewController.h"
#import "D2_Share.h"

@interface A1_WebmasterRecommend_iphone ()

@property(nonatomic,assign) BOOL reloading;
@end

@implementation A1_WebmasterRecommend_iphone


ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.navigationBarShown = YES;
        self.navigationBarTitle = @"站长推荐";
        self.commandmodel=[CommandModel modelWithObserver:self];
        [self.commandmodel loadCache];
        [self.commandmodel firstPage];
    }
    else if([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
//        self.list.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        UIEdgeInsets edge=bee.ui.config.baseInsets;
//        self.list.frame=CGRectMake(0, edge.top, self.view.frame.size.width, self.view.frame.size.height - edge.top);

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *idtifier= @"A1_WebmasterRecommend.HeaderCell";
        A1_WebmasterRecommend_HeaderCell *cell=[tableView dequeueReusableCellWithIdentifier:idtifier];
        if (!cell) {
            cell=[[A1_WebmasterRecommend_HeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idtifier];
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        }
        command *acommand=[self.commandmodel.shots objectAtIndex:indexPath.row];
        cell.label.text = acommand.subject;
        cell.ImgeView.data = acommand.img;
        cell.lbllandlord.text = acommand.author;
        cell.lblreply.text = acommand.replies;
        cell.lbltitle.text = acommand.subject;
        NSString *datastring = @"";
        KT_DATEFROMSTRING(acommand.dateline, datastring)
        cell.lbltime.text = [NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:acommand.dateline]];

        return cell;
    }
    else
    {
        static NSString * idtifier = @"A1_WebmasterRecommend.Cell";
        A1_WebmasterRecommend_Cell *cell=[tableView dequeueReusableCellWithIdentifier:idtifier];
        if (!cell) {
            cell=[[A1_WebmasterRecommend_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idtifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        command *acommand = [self.commandmodel.shots objectAtIndex:indexPath.row];
        if (acommand) {
            cell.lbllandlord.text = acommand.author;
            cell.lblreadl.text = acommand.views;
            cell.lblreply.text = acommand.replies;
            cell.lbltitle.text = acommand.subject;
            NSString *datastring = @"";
            KT_DATEFROMSTRING(acommand.dateline, datastring)
            cell.lbltime.text = [NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:acommand.dateline]];
            if(acommand.img.length > 0)
                cell.cellicon.data = acommand.img;
                [cell layoutSubviews:YES];
        }
        return cell;
    }
}

ON_SIGNAL3(CommandModel, RELOADED, signal)
{
    [self finishReloadingData];
    [self.list reloadData];
}

ON_SIGNAL3(CommandModel, FAILED, signal)
{
    [self finishReloadingData];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 215;
    else
        return 90;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commandmodel.shots.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    command *atopic=[self.commandmodel.shots objectAtIndex:indexPath.row];
    [D2_Share sharedInstance].image = atopic.img;
    B3_PostViewController *board=[[B3_PostViewController alloc] init];
    board.tid = atopic.tid;
    [self.navigationController pushViewController:board animated:YES];
    
}


ON_WILL_APPEAR(signal)
{
    [bee.ui.appBoard hideTabbar];
}


//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

//刷新调用的方法
- (void)refreshView
{
    [self.commandmodel firstPage];
}
//加载调用的方法
-(void)getNextPageView
{
    if (self.commandmodel.more) {
        [self removeFooterView];
        [self.commandmodel nextPage];
    }
    else
    {
        [self removeFooterView];
        [self finishReloadingData];
        [self presentMessageTips:__TEXT(@"no_more")];//没有更多的了
        [self FinishedLoadData];
    }
}

@end
