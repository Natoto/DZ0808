//
//  C0_FacialInputView.m
//  DZ
//
//  Created by Nonato on 14-4-30.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "C0_FacialInputView.h"

@implementation C0_FacialInputView
@synthesize delegate;
DEF_SIGNAL(selectedFacialView)
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.frame=CGRectMake(0, 0, 320, 200);
        [self setBackgroundColor:[UIColor grayColor]];
        
		scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        [scrollView setBackgroundColor:[UIColor grayColor]];
		for (int i=0; i<3; i++) {
			FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 180)];
			[fview loadFacialView:i size:CGSizeMake(45, 45)];
			fview.delegate=self;
			[scrollView addSubview:fview];
		}
		scrollView.contentSize=CGSizeMake(320*3, 180);
        scrollView.showsVerticalScrollIndicator  = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollEnabled = YES;
        scrollView.pagingEnabled=YES;
        scrollView.delegate = self;
        
        //定义PageControll
        pageControl = [[UIPageControl alloc] init];
        [pageControl setBackgroundColor:[UIColor grayColor]];
        pageControl.frame = CGRectMake(130, 180, 60, 20);//指定位置大小
        pageControl.numberOfPages = 3;//指定页面个数
        pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
        [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        //添加委托方法，当点击小白点就执行此方法
        [self addSubview:scrollView];
        [self addSubview:pageControl];
        
    }
    return self;
}
- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;//获取当前pagecontroll的值
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

-(void)selectedFacialView:(NSString*)str
{
    self.selectedFacialStr=str;
    [delegate selectedFacialView:str];
//    [self sendUISignal:self.selectedFacialView];
//    [self _addEmotion:str];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
