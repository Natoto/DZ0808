//
//  B4_PreviewImageViewController.m
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B4_PreviewImageView.h"
#import "LXActionSheet.h"
#import "UIImage+BeeExtension.h"
#import "MRZoomScrollView.h"
#import "postlist.h"
@interface B4_PreviewImageView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    BeeUIImageView *showView;
    UIScrollView *scrollview;
 
    CGFloat currentScale;
    UIImage * srcImage;
}
@property (nonatomic, retain) UILabel           * lblTips;
@property (nonatomic, retain) UIScrollView      * scrollView;
@property (nonatomic, retain) NSArray           * imgURLarray;
@end

@implementation B4_PreviewImageView

-(NSArray *)imgURLAry:(NSArray *)contentsAry
{
    NSMutableArray *imgarray=[[NSMutableArray alloc] init];
    for ( content *acontent in contentsAry) {
        if (acontent.type.integerValue == 1) {
            [imgarray addObject:acontent];
        }
    }
    return imgarray;
}

-(NSInteger)indexOfImage:(NSString *)url
{
    int Index=0;
    for (Index = 0 ;Index < self.imgURLarray.count;Index++) {
        content *acontent =[self.imgURLarray objectAtIndex:Index];
        if ([acontent.msg isEqualToString:url]) {
            break;
        }
    }
    return Index;
}

-(id)initWithFrame:(CGRect)frame withurl:(NSString *)url target:(id)target andSEL:(SEL)selaction contentAry:(NSArray *)contentAry
{
    self=[super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor=[UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView setContentSize:CGSizeMake(320 * 1, frame.size.height)];
        
        _imgURLarray=[[NSArray alloc] init];
        self.contentAry=contentAry;
        
        if (self.contentAry.count) {
            self.imgURLarray=[self imgURLAry:self.contentAry];
        }
        else
        {
            content *acont=[[content alloc] init];
            acont.type=[NSNumber numberWithInt:2];
            acont.msg=url;
            _imgURLarray=[NSArray arrayWithObject:acont];
        }
        
        for (int i = 0; i < self.imgURLarray.count; i++){
            
            MRZoomScrollView  *_zoomScrollView = [[MRZoomScrollView alloc]init];
            CGRect frame = self.scrollView.frame;
            frame.origin.x = frame.size.width * i;
            frame.origin.y = 0;
            _zoomScrollView.frame = frame;
            content *acontent =[self.imgURLarray objectAtIndex:i]; 
            [_zoomScrollView.imageView GET:acontent.originimg useCache:YES];
            self.scrollView.contentSize=CGSizeMake(frame.size.width * (i+1), frame.size.height);
            [self.scrollView addSubview:_zoomScrollView];
        }
        int indexImage=[self indexOfImage:url];
        CGRect frame = self.scrollView.frame;
        
        [self.scrollView setContentOffset:CGPointMake(frame.size.width * indexImage, 0) animated:YES];
         UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selaction];
        [_scrollView addGestureRecognizer:singleTap];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        _lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _lblTips.textAlignment = NSTextAlignmentCenter;
        _lblTips.center = CGPointMake(320/2, self.frame.size.height - 50);
        _lblTips.textColor = [UIColor whiteColor];
        _lblTips.backgroundColor = [UIColor clearColor];
        [self addSubview:_lblTips];
        _lblTips.text = [NSString stringWithFormat:@"%d/%d",(indexImage+1),self.imgURLarray.count];
        
    }
    return self;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = 1 + scrollView.contentOffset.x / scrollView.frame.size.width;
    int count= self.imgURLarray.count;
    _lblTips.text = [NSString stringWithFormat:@"%d/%d",index,count];
}
@end
