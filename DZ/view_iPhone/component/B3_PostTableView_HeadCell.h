//
//  B3_PostTableView_HeadCell.h
//  DZ
//
//  Created by Nonato on 14-4-23.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
#import "Bee.h"
#import "postlist.h"
#import "SettingModel.h"
#import "B3_PostBaseTableViewCell.h"
#define HEADCONTENTVIEWSTARTTAG 110043

@class B3_PostTableView_HeadCell;
@protocol B3_PostTableView_HeadCellDelegate <NSObject>
-(void)B3_HeadCellShowBigImgview:(NSString *)url imageView:(BeeUIImageView *)imageView;
-(void)B3_HeadCellDidFinishLoad:(CGRect) frame;
-(void)B3_HeadCellReplyButtonTap:(B3_PostTableView_HeadCell *)obj;
-(void)B3_HeadCellSupportButtonTap:(B3_PostTableView_HeadCell *)obj;
@optional
-(void)B3_HeadCellProfileBtnTapped:(B3_PostTableView_HeadCell *)obj;
-(void)B3_HeadCellHeaderViewTapped:(B3_PostTableView_HeadCell *)obj;
-(void)B3_HeadCell:(B3_PostTableView_HeadCell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url;
@end
//webViewDidFinishLoad

@interface B3_PostTableView_HeadCell : UITableViewCell<B3_PostBaseTableViewCellDelegate>
{
//    NSObject <B3_PostTableView_HeadCellDelegate> *delegate;
//    NSMutableArray *cntSubViewsAry;
//    BeeUIWebView *webcontentview;
//    BeeUIImageView *splitimg;
//    FONTSIZE_TYPE  fontsize;
    B3_PostBaseTableViewCell *headerpostcell;
}
@property(nonatomic,strong) B3_PostBaseTableViewCell *headerpostcell;
@property (nonatomic, assign) NSObject <B3_PostTableView_HeadCellDelegate> * delegate;
@property(nonatomic,strong)NSString *lblfloortext;
@property(nonatomic,strong) topic  *celltopic;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *support;
@property (nonatomic, assign) CGRect cellHeaderFrame;
@property (nonatomic, assign) BOOL isHeader;

//
-(void)reloadsubviews;
+(float)heightOfCell:(NSArray *)contents;
- (void)B3_PostTableView_HeadCell:(void(^)(id sender))obj;

@end
