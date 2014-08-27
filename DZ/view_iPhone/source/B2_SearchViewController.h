//
//  B2_SearchViewController.h
//  DZ
//
//  Created by Nonato on 14-5-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B3_PostViewController.h"
#import "SearchModel.h"
#import "MaskView.h"
#import "BeeUIBoard+ViewController.h"

@interface B2_SearchViewController : BeeUIBoard_ViewController  <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MaskViewDelegate>
{
    UIView *searchBg;               //搜索框背景
    UITextField *inputText;         //搜索栏
    UITableView *list;              //结果列表
    UIButton *cancelBtn;            //取消按钮

    NSMutableArray *resultArray;    //搜索结果
    NSMutableString *tid;           //主题ID
    NSString *fid;                  //版块ID
}

@property (nonatomic, copy)     NSString        *uid;
@property (nonatomic, strong)   SearchModel     *searchModel;

@end
