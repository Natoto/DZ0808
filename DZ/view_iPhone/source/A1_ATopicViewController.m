//
//  A1_ATopicViewController.m
//  DZ
//
//  Created by Nonato on 14-4-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "A1_ATopicViewController.h"
#import "PullLoader.h"
#import "FootLoader.h"
#import "DribbbleDetailBoardComment_iPhone.h"
#import "rmbdz.h"
#import "SVGloble.h"
#import "SVRootScrollView.h"
#import "SVTopScrollView.h"

@interface A1_ATopicViewController ()
@property(nonatomic,strong)SVTopScrollView *topScrollView;
@property(nonatomic,strong)SVRootScrollView *rootScrollView;
@end

@implementation A1_ATopicViewController
-(void)initSVscrollview
{
    UIEdgeInsets edgeInset= bee.ui.config.baseInsets;
    _topScrollView = [[SVTopScrollView alloc] initWithFrame:CGRectMake(0, edgeInset.top, CONTENTSIZEX, 44)];;
    _rootScrollView = [[SVRootScrollView alloc] initWithFrame:CGRectMake(0, 44+edgeInset.top, 320, [SVGloble shareInstance].globleAllHeight - 44 - edgeInset.top)];
    
    _topScrollView.nameArray = @[@"全部", @"热帖",  @"精华", @"置顶", @"子版块"];
    _rootScrollView.viewNameArray = @[@"全部", @"热帖", @"精华", @"置顶", @"子版块"];
    
    [self.view addSubview:_topScrollView];
    [self.view addSubview:_rootScrollView];
    [_topScrollView initWithNameButtons];
    [_rootScrollView initWithViews];
}
#pragma mark -
ON_SIGNAL3(SVRootScrollView, adjustTopScrollView, signal)
{
    SVRootScrollView *rootview=(SVRootScrollView *)signal.sourceView;
    [_topScrollView setButtonUnSelect];
    _topScrollView.scrollViewSelectedChannelID = rootview.POSITIONID +100;
    [_topScrollView setButtonSelect];
    [_topScrollView setScrollViewContentOffset];
}

#pragma mark -
ON_SIGNAL3(SVTopScrollView, selectNameButtonTap, signal)
{
    SVTopScrollView *topview=(SVTopScrollView *)signal.sourceView;
    int BUTTONID=topview.BUTTONID;
    [_rootScrollView setContentOffset:CGPointMake(BUTTONID*320, 0) animated:YES];
}

ON_SIGNAL2(BeeUIBoard, signal)
{
    if ([signal is:BeeUIBoard.CREATE_VIEWS]) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        UIEdgeInsets edgeInset= bee.ui.config.baseInsets;
        [SVGloble shareInstance].globleWidth = screenRect.size.width; //屏幕宽度
        [SVGloble shareInstance].globleHeight = screenRect.size.height-edgeInset.top;  //屏幕高度（无顶栏）
        [SVGloble shareInstance].globleAllHeight = screenRect.size.height;//screenRect.size.height;  //屏幕高度（有顶栏）
        [self initSVscrollview];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back"]];
        self.navigationBarShown=YES;
    }
}

ON_LOAD_DATAS(signal)
{
    if(self.topicitem)
    {
        self.navigationBarTitle=self.topicitem.fid;;
    }
}


ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}


@end
