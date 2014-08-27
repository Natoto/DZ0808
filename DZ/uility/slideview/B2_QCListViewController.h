//
//  QCListViewController.h
//  QCSliderTableView
//
//  Created byV 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Base_TableviewController.h"
@protocol QCListViewControllerDelegate <NSObject>
- (void)QCListViewControllerDelegateCellSelectedWithFid:(NSString *)fid name:(NSString *)name;
@end

@interface B2_QCListViewController : Base_TableviewController<UITableViewDataSource, UITableViewDelegate>
{
//    UITableView *_tableViewList;
}
@property(nonatomic,  assign) NSObject<QCListViewControllerDelegate>  *delegate;
//@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
@property (nonatomic, strong) NSArray *childAry;
- (void)viewDidCurrentView;

@end

