//
//  B2_PostViewController.h
//  DZ
//
//  Created by Nonato on 14-4-23.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B3_PostTableView_HeadCell.h"
#import "B3_PostTableView_Cell.h"
#import "PostlistModel.h"
#import "replyModel.h"
#import "UserModel.h"
#import "Base_TableviewController.h"
#import "collectModel.h"
#import "delcollectionModel.h"
#import "SupportModel.h"

@class FaceBoard;
@class MaskView;

BOOL isHeader;
NSInteger support;

@interface B3_PostViewController : Base_TableviewController <UITableViewDelegate, UITableViewDataSource, B3_PostTableView_HeadCellDelegate, B3_PostTableView_CellDelegate, UITextViewDelegate>
{
    float              headercellheight; 
    UIView          * replyArea;
    BeeUITextView   * replayField;
    BOOL             canscrollTableToFoot;
    MaskView          * maskview;
    NSString        * currentindexPath;
    FaceBoard       * facialView;
    NSArray         *shareArray;
//    UIButton        * titleBtn;
}

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) PostlistModel *postmodel;
//@property (nonatomic, retain) UITableView *list;
@property (nonatomic, strong) NSMutableDictionary *cellsHeightDic;
@property (nonatomic, strong) replyModel  *reply_model;
@property (nonatomic, strong) collectModel *collectModel;
@property (nonatomic, strong) delcollectionModel *delcollectionModel;
@property (nonatomic, strong) SupportModel *supportModel;
//@property (nonatomic, strong) B3_PostBaseTableViewCell *astatus;
@property (nonatomic, assign) BOOL isSelected;

@end
