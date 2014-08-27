//
//  TopicViewController.h
//  DZ
//
//  Created by Nonato on 14-4-22.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import <UIKit/UIKit.h> 
//#import "EGORefreshTableHeaderView.h"
//#import "EGORefreshTableFooterView.h"
#import "Bee.h"
#import "DZ_SystemSetting.h"
#import "ToolsFunc.h"
#import "UIViewController+ErrorTips.h"
#import "BeeUIBoard+ViewController.h"
#import "UIImage+Bundle.h"
#import "AppBoardTab_iPhone.h"

typedef enum : NSUInteger {
    TABLEVIEW_NORMAL,
    TABLEVIW_WITHTABBAR,
    TABLEVIEW_WITHSLIDSWITCH,
} TABLEVIEW_TYPE;
@interface Base_TableviewController : BeeUIBoard_ViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableViewList;
    BOOL _reloading;
}

//@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
//@property (nonatomic, strong) EGORefreshTableFooterView *refreshFooterView;
@property (nonatomic, strong) UITableView               *tableViewList;
@property (nonatomic, strong) NSString                  *forum_fid;
@property (nonatomic, strong) NSString                  *topic_type;
@property (nonatomic, assign) BOOL                       noFooterView;
@property (nonatomic, assign) BOOL                       noHeaderFreshView;
- (void)viewDidCurrentView;
-(void)removeFooterView;
-(void)finishReloadingData; 
-(void)setFooterView;
-(void)relayoutSubviews;

-(void)reframeTableView:(TABLEVIEW_TYPE)type;

//调用上下拉需要的
-(void)refreshView;
-(void)getNextPageView;
-(void)FinishedLoadData; 
@end
