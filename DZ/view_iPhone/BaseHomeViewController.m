//
//  ViewController.m
//  IPhoneTest
//
//  Created by Lovells on 13-8-20.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "BaseHomeViewController.h"
#import "TileView.h"
#import "MyRect.h"
#import "DribbbleDetailBoard_iPhone.h"
#import "HomePageModel.h"

//#define kTileWidth  130.f
//#define kTileHeight kTileWidth
#define kTileMarginLeft1 10.f
#define kTileMarginLeft2 (320.f - kTileMarginLeft1 - kTileWidth)
#define kTileMargin 50.f
#define kTileMarginV 10.f
@interface BaseHomeViewController ()<TileViewCloseBtnTapDelegate>
{
    int changeSrsIndex;
    int changeDesIndex;
}
@end

@implementation BaseHomeViewController
DEF_SIGNAL(longPressEnd)
DEF_SIGNAL(dragViewEnd)
DEF_SIGNAL(removeView)
@synthesize tileArray = _tileArray, scrollView = _scrollView;

 
- (void)createButtonAndAddToSelfView//测试用
{
//    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
//    [addButton setBackgroundImage:[self createRoundPlusImageWithSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
//    [addButton addTarget:self action:@selector(addViewButtonWithTitle:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:addButton];
}

- (UIImage *)createRoundPlusImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 填充黑色圆形
    [[UIColor grayColor] setFill];
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // 画白色加号
    CGContextSetLineWidth(context, 2.f);
    [[UIColor whiteColor] set];
    CGContextMoveToPoint(context, 2, size.height / 2);
    CGContextAddLineToPoint(context, size.width - 2, size.height / 2);
    CGContextMoveToPoint(context, size.width / 2, 2);
    CGContextAddLineToPoint(context, size.width / 2, size.height - 2);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(CGRect)ViewinitFrame
{
    int counter = self.tileArray.count;
    
    int marginTop = (kTileHeight + kTileMargin) * (counter / 2 + 1) - 160;
    if (counter % 2 == 0) {
        return CGRectMake(kTileMarginLeft1-kTileWidth, marginTop-kTileHeight, kTileWidth*3/2, kTileHeight*3/2);//左边
    } else {
        return CGRectMake(kTileMarginLeft2+kTileWidth, marginTop-kTileHeight, kTileWidth*3/2, kTileHeight*3/2);//右边
    }
}

#pragma mark - 控件点击

- (BOOL)addViewButtonWithTitle:(HOME2TOPICSPOSITIONITEM *)item
{
    TileView *view = [[TileView alloc] initWithTarget:self dragaction:@selector(dragTile:) andlongpressaction:@selector(longPressTile:)];
//    view.frame=[self ViewinitFrame]; 
    view.alpha=0;
    view.delegate=self;
    CGRect viewframe= [self createFrameLayoutTile:self.tileArray.count];
    view.Tileitem=item;
    if (item.icon.length>1) {
        view.imgView.data=item.icon;
    }
    view.titlelbl.text=item.title;
    view.synopsislbl.text=item.subject;
    view.enableDelete=[item.enableDelete boolValue];
    // 动态增长contectSize
    if (viewframe.origin.y + kTileHeight + kTileMargin > self.scrollView.frame.size.height) {
        self.scrollView.contentSize = CGSizeMake(320, viewframe.origin.y + kTileHeight + kTileMargin * 2);
    }
    view.frame =viewframe;
    [UIView animateWithDuration:0.8 delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
//                         view.frame =viewframe;
                         view.alpha=1;
                     }
                     completion:^(BOOL f){
//                         view.frame =viewframe;
                         view.alpha=1;
                     }];
    [self.scrollView addSubview:view];
    [self.tileArray addObject:view]; 
    scrollContentSize=self.scrollView.contentSize;
    self.scrollView.scrollsToTop=YES; 
    return YES;
}



- (CGRect)createFrameLayoutTile:(int)counter
{
//    int counter = self.tileArray.count;
    int marginTop = (kTileHeight + kTileMarginV) * (counter / 2 + 1) - (kTileHeight + kTileMarginV+40);
    if (counter % 2 == 0) {
        return CGRectMake(kTileMarginLeft1, marginTop, kTileWidth, kTileHeight);
    } else {
        return CGRectMake(kTileMarginLeft2, marginTop, kTileWidth, kTileHeight);
    }
}

// 若使用此方法，则self.scrollView.subviews会出现UIImageView（不知道是何作用）
// 所以只能自己建立一个数组记录scrollView上的所有tileView
//- (void)scrollToBottomWithScrollView:(UIScrollView *)scrollView
//{
//    if (scrollView.contentSize.height - 480 > 0)
//    {
//        [scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - 480) animated:YES];
//    }
//}

-(void)TileViewCloseBtnTap:(TileView *)tileview
{
    //    TileView *tileView=(TileView *)signal.source;
    [self ReArrangTileViews:tileview];
}

-(void)startShakeAllTileViews
{
    for (int i=0;i<self.tileArray.count;i++)
    {
        TileView *item=[self.tileArray objectAtIndex:i];
        [item.layer setShadowColor:[UIColor grayColor].CGColor];
        [item.layer setShadowOpacity:1.0f];
        [item.layer setShadowRadius:10.0f];
        [item startShake];
    }
}
-(void)stopShakeAllTileViews
{
    for (int i=0;i<self.tileArray.count;i++)
    {
        TileView *item=[self.tileArray objectAtIndex:i];
        [item.layer setShadowColor:[UIColor whiteColor].CGColor];
        [item.layer setShadowOpacity:0.0f];
        [item.layer setShadowRadius:0.0f];
        [item stopShake];
    }
}

-(void)ReArrangTileViews:(TileView *)tileView
{
    
    int removeIndex=[self.tileArray indexOfObject:tileView];
    
    [self.tileArray removeObject:tileView];
    [tileView removeFromSuperview];
    BeeLog(@"tileArray: %@",self.tileArray);
    
    for (int i=0;i<self.tileArray.count;i++)
    {
        CGRect viewframe= [self createFrameLayoutTile:i];
        TileView *item=[self.tileArray objectAtIndex:i];
        [UIView animateWithDuration:0.2 animations:^{
                item.frame=viewframe;
            }];
    }
     CGRect viewframe= [self createFrameLayoutTile:self.tileArray.count];
    // 动态增长contectSize
      self.scrollView.contentSize = CGSizeMake(320, viewframe.origin.y + kTileHeight + kTileMargin * 2);
    scrollContentSize=self.scrollView.contentSize;
    [self sendUISignal:self.removeView withObject:[NSString stringWithFormat:@"%d",removeIndex]];
}


#pragma mark - 手势操作

- (BOOL)longPressTile:(UILongPressGestureRecognizer *)recognizer
{
        TileView *longPressView = (TileView *)recognizer.view;
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan:
            {
                if (longPressView.editmode) {
                    self.EDITMODE=NO;
                    [self stopShakeAllTileViews];
                }
                else
                {
                    self.EDITMODE=YES;
                    [self startShakeAllTileViews];
                    NSLog(@"长按开始~~~");
                }
                break;
            }
            case UIGestureRecognizerStateChanged:
                break;
            case UIGestureRecognizerStateEnded:
                    NSLog(@"长按结束~~~");
                [self sendUISignal:self.longPressEnd withObject:self.tileArray];
              

//                [longPressView stopShake];
                break;
            default: break;
        }

    return YES;
}
- (BOOL)dragTile:(UIPanGestureRecognizer *)recognizer
{
    if (!self.EDITMODE) {
        return NO;
    }
    switch ([recognizer state])
    {
        case UIGestureRecognizerStateBegan:
            [self dragTileBegan:recognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragTileMoved:recognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragTileEnded:recognizer];
            break;
        default: break;
    }
    return YES;
}

- (void)dragTileBegan:(UIPanGestureRecognizer *)recognizer
{
    _dragFromPoint = recognizer.view.center;
    [UIView animateWithDuration:0.2f animations:^{
        recognizer.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
        recognizer.view.alpha = 0.8;
    }];
}

- (void)dragTileMoved:(UIPanGestureRecognizer *)recognizer
{
//    CGPoint translation = [recognizer translationInView:self.scrollView];
    CGPoint pointInView = [recognizer locationInView:self.view];
    CGPoint _point = [recognizer locationInView:self.scrollView];
//    CGRect frame=recognizer.view.frame;
    
    recognizer.view.center =CGPointMake(_point.x, _point.y); // CGPointMake(recognizer.view.center.x + translation.x,
                                         //recognizer.view.center.y + translation.y );
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:self.scrollView];
    
    [self rollbackPushedTileIfNecessaryWithPoint:recognizer.view.center];
    [self pushedTileMoveToDragFromPointIfNecessaryWithTileView:(TileView *)recognizer.view];
 
    //上拉过程中
    if ((pointInView.y) < 44+kTileHeight/2) {
        if ((self.scrollView.contentOffset.y - 100)>0) {
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y - 150) animated:YES];
        }
        else
        [self.scrollView setContentOffset:CGPointMake(0, - kTileHeight/2) animated:YES];
    }
    
    //下拉
    if ((pointInView.y + kTileHeight/2.0) >420 && (_point.y + kTileHeight*3/2) <scrollContentSize.height)
    {
        if ((self.scrollView.contentOffset.y+ 150)<scrollContentSize.height) {
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y+ 150) animated:YES];
        }
    }
    
}

- (void)rollbackPushedTileIfNecessaryWithPoint:(CGPoint)point
{
    if (_pushedTile && !CGRectContainsPoint(_dragToFrame, point))
    {
        [UIView animateWithDuration:0.2f animations:^{
            _pushedTile.center = _dragToPoint;
        }];
        _dragToPoint = _dragFromPoint;
        _pushedTile = nil;
        _isDragTileContainedInOtherTile = NO;
    }
}

- (void)pushedTileMoveToDragFromPointIfNecessaryWithTileView:(TileView *)tileView
{
//     changeSrsIndex=-1;
//     changeDesIndex=-1;
    for (int index=0;index<self.tileArray.count;index++)
    {
        TileView *item =[self.tileArray objectAtIndex:index];
        if (CGRectContainsPoint(item.frame, tileView.center) && item != tileView)
        {//交换位置
            _dragToPoint = item.center;
            _dragToFrame = item.frame;
            _pushedTile = item;
            _isDragTileContainedInOtherTile = YES;
            [UIView animateWithDuration:0.2 animations:^{
                item.center = _dragFromPoint;
            }];
            changeDesIndex=index;
        }
        if (item == tileView) {
            changeSrsIndex=index;
        }
        if (changeDesIndex>0 && changeSrsIndex>0)
        {
            break;
        }
    }
    

}

- (void)dragTileEnded:(UIPanGestureRecognizer *)recognizer
{
    
    [UIView animateWithDuration:0.2f animations:^{
        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
        recognizer.view.alpha = 1.f;
    }];
    
    if (changeDesIndex>=0 && changeSrsIndex>=0 && changeSrsIndex!=changeDesIndex) {
        [self.tileArray exchangeObjectAtIndex:changeSrsIndex withObjectAtIndex:changeDesIndex];
        NSString *changePositions=[NSString stringWithFormat:@"%d:%d",changeSrsIndex,changeDesIndex];
        [self sendUISignal:self.dragViewEnd withObject:changePositions];
    }
    [UIView animateWithDuration:0.2f animations:^{
        if (_isDragTileContainedInOtherTile)
            recognizer.view.center = _dragToPoint;
        else
            recognizer.view.center = _dragFromPoint;
    }];
    
    _pushedTile = nil;
    _isDragTileContainedInOtherTile = NO;
}

#pragma mark - getter

- (NSMutableArray *)tileArray
{
    if (!_tileArray)
    {
        _tileArray = [[NSMutableArray alloc] init];
    }
    return _tileArray;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height)];
        UIEdgeInsets edge=bee.ui.config.baseInsets;
        _scrollView.contentInset=edge;
    }
    return _scrollView;
}

@end
