//
//  QCSlideViewController.h
//  QCSliderTableView
//
//  Created by  on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "B2_QCListViewController.h"
#import "QCViewController.h"
@class B2_QCListViewController;
@interface QCSlideViewController : UIViewController<QCSlideSwitchViewDelegate>
{
    QCSlideSwitchView *_slideSwitchView;
    B2_QCListViewController *_vc1;
    B2_QCListViewController *_vc2;
    B2_QCListViewController *_vc3;
    B2_QCListViewController *_vc4;
    B2_QCListViewController *_vc5;
    B2_QCListViewController *_vc6;
}

@property (nonatomic, strong) QCSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) B2_QCListViewController *vc1;
@property (nonatomic, strong) B2_QCListViewController *vc2;
@property (nonatomic, strong) B2_QCListViewController *vc3;
@property (nonatomic, strong) B2_QCListViewController *vc4;
@property (nonatomic, strong) B2_QCListViewController *vc5;
@property (nonatomic, strong) B2_QCListViewController *vc6;

@end

