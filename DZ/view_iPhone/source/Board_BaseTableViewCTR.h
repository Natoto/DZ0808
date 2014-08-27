//
//  Board_BaseTableViewCTR.h
//  DZ
//
//  Created by Nonato on 14-7-2.
//
//
#import "Constants.h"
#import "Bee_UIBoard.h"
//#import "EGORefreshTableFooterView.h"
//#import "EGORefreshTableHeaderView.h"
@interface Board_BaseTableViewCTR : BeeUIBoard<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableViewList;
  
}
@property(nonatomic,assign) BOOL reloading;
//@property(nonatomic,strong) EGORefreshTableHeaderView *refreshHeaderView;
//@property(nonatomic,strong) EGORefreshTableFooterView *refreshFooterView;
@property(nonatomic,strong) UITableView *list;
@property(nonatomic,strong) NSString *forum_fid;
@property(nonatomic,strong)   NSString *topic_type;
@property(nonatomic,assign) BOOL noFooterView;
@property(nonatomic,assign) BOOL noHeaderView;
-(void)refreshView;
- (void)viewDidCurrentView;
-(void)removeFooterView;
-(void)finishReloadingData;
-(void)setFooterView;
-(void)FinishedLoadData;
-(void)relayoutSubviews;
 

@end
