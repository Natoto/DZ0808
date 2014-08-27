//
//  TopicViewController.h
//  DZ
//
//  Created by Nonato on 14-4-22.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TopiclistModel.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "Bee.h"

@protocol B2_TopicViewControllerDelegate <NSObject>

- (void)topicViewControllerCellSelectedWithTid:(NSString *)tid;

@end

@interface B2_TopicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,EGORefreshTableDelegate>
{
    UITableView *_tableViewList;
    BOOL _reloading;
}
AS_SIGNAL(selectpost)
@property (nonatomic, assign) NSObject <B2_TopicViewControllerDelegate> * topicvcdelegate;
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic,strong) EGORefreshTableFooterView *refreshFooterView;
@property (nonatomic, strong) UITableView *tableViewList;
@property  (nonatomic,strong) NSString *forum_fid;
@property(nonatomic,strong)   NSString *topic_type;
- (void)viewDidCurrentView;
@property(nonatomic,strong) TopiclistModel *tpclistModel;
@end
