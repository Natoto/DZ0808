//
//  B3_PostTableView_Cell.h
//  DZ
//
//  Created by Nonato on 14-4-24.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postlist.h"
#import "SettingModel.h"
#import "B3_PostBaseTableViewCell.h"
//#define BELOWCONTENTVIEWSTARTTAG 110043
//#define  CONTENTVIEWSTARTTAG 153314
@class B3_PostTableView_Cell;

@protocol B3_PostTableView_CellDelegate <NSObject>
- (void)B3_CellDidFinishLoad:(B3_PostTableView_Cell *)cell andheight:(float) height;
- (void)B3_CellShowBigImgview:(NSString *)imgurl cell:(B3_PostTableView_Cell *)cell imageview:(BeeUIImageView *)ImageView;
@optional
- (void)B3_CellProfileBtnTapped:(B3_PostTableView_Cell *)object;
- (void)B3_CellReplyBtnTapped:(B3_PostTableView_Cell *)object;
- (void)B3_CellHeaderViewTapped:(B3_PostTableView_Cell *)object;
- (void)B3_CellSupportBtnTapped:(B3_PostTableView_Cell *)object;
- (void)B3_Cell:(B3_PostTableView_Cell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url;
@end

@interface B3_PostTableView_Cell : UITableViewCell<B3_PostBaseTableViewCellDelegate>
{
//    UIWebView *webcontentview;
//    NSMutableArray *cntSubViewsAry;
//    float splitLableViewTotalHeight;
//    FONTSIZE_TYPE fontsize;
    B3_PostBaseTableViewCell *headerpostcell;
    
}
@property(nonatomic,assign)TYPETOSHOWCONTENT        typetoshow;
//@property(nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic,assign)NSObject<B3_PostTableView_CellDelegate> *delegate;
@property(nonatomic,strong)NSString *lblfloortext;
//@property(nonatomic,strong)UIButton * btnreply;
//@property(nonatomic,strong)UILabel * lblfloor;
//@property(nonatomic,strong)UILabel * lblTitle;
//@property(nonatomic,strong)UILabel * lbllandlord;
//@property(nonatomic,strong)UILabel * lblreply;
//@property(nonatomic,strong)UILabel * lbltime;
//@property(nonatomic,strong)BeeUIImageView *imgprofile;
//@property(nonatomic,strong)UIView  * belowcontentView;
//@property(nonatomic,strong)NSArray * contentAry; 
//@property(nonatomic,strong)UIView  * headerView;
@property(nonatomic,strong) post    * cellpost;
@property(nonatomic,strong) NSString * cellIndex;
@property(nonatomic,assign) float       cellheight;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *support;
@property (nonatomic, assign) CGRect cellHeaderFrame;
//@property (nonatomic, assign) BOOL isHeader;

-(void)reloadsubviews;

+(float)heightOfCell:(NSArray *)contents;
- (void)B3_PostTableView_Cell:(void (^)(id sender))obj;

@end
