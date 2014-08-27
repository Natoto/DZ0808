//
//  ViewController.m
//  IPhoneTest
//
//  Created by Lovells on 13-8-20.
//  Copyright (c) 2013年 Luwei. All rights reserved.
// 
#import "A0_BaseHomeViewController.h"
#import "A0_TileView.h"
#import "MyRect.h" 
//#import "HomePageModel.h"

//#define kTileWidth  130.f
//#define kTileHeight kTileWidth
#define kTileMarginLeft1 10.f
#define kTileMarginLeft2 (320.f - kTileMarginLeft1 - kTileWidth)
#define kTileMargin 50.f
#define kTileMarginV 10.f
@interface A0_BaseHomeViewController ()<TileViewCloseBtnTapDelegate>
{
    int changeSrsIndex;
    int changeDesIndex;
}
@end

@implementation A0_BaseHomeViewController
DEF_SIGNAL(longPressEnd)
DEF_SIGNAL(dragViewEnd)
DEF_SIGNAL(removeView)
@synthesize tileArray = _tileArray, scrollView = _scrollView;

-(void)viewWillDisappear:(BOOL)animated
{
    if(self.EDITMODE==YES)
    {
        [self stopShakeAllTileViews];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    if(self.EDITMODE==YES)
    {
        [self stopShakeAllTileViews];
    }
} 
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
    NSInteger counter = self.tileArray.count;
    int marginTop = (kTileHeight + kTileMargin) * (counter / 2 + 1) - 160;
    if (counter % 2 == 0) {
        return CGRectMake(kTileMarginLeft1-kTileWidth, marginTop-kTileHeight, kTileWidth*3/2, kTileHeight*3/2);//左边
    } else {
        return CGRectMake(kTileMarginLeft2+kTileWidth, marginTop-kTileHeight, kTileWidth*3/2, kTileHeight*3/2);//右边
    }
}

#pragma mark - 控件点击
-(void)removeViewButtonWithTitle:(HOME2TOPICSPOSITIONITEM *)item
{
    BeeLog(@"---removeView ButtonWithTitle ---");
    for ( A0_TileView *view in self.tileArray) {
        if ([view.Tileitem.fid isEqualToString:item.fid]) {
            [self ReArrangTileViews:view];
            return;
        }
    }
}

- (BOOL)inSertViewButtonWithTitle:(HOME2TOPICSPOSITIONITEM *)item index:(int)index
{
     BeeLog(@"---inSertView ButtonWithTitle ---");
    for ( A0_TileView *aview in self.tileArray) {
        if ([aview.Tileitem.fid isEqualToString:item.fid]) {
            return NO;
        }
    }
    A0_TileView *view = [[A0_TileView alloc] initWithTarget:self dragaction:@selector(dragTile:) andlongpressaction:@selector(longPressTile:)];
    view.tag = TILEVIEWSTARTTAG + item.fid.integerValue;
    view.alpha = 0;
    view.delegate = self;
    CGRect viewframe = [self createFrameindexLayoutTile:index];
    [view dataChange:item];
    view.frame = viewframe;
    [self.scrollView addSubview:view];
    if (index >= self.tileArray.count) {
         [self.tileArray addObject:view];
    }
    else
    {
        [self.tileArray insertObject:view atIndex:index];
    }
    // 动态增长contectSize
    [self resizeScrollView:viewframe];
     view.alpha=1;
  
    scrollContentSize=self.scrollView.contentSize;
    self.scrollView.scrollsToTop=YES;
    return YES;
}
/*
-(BOOL)isWebMasterFirst
{
    if (!self.tileArray.count) {
        return YES;
    }
    A0_TileView *view =[self.tileArray objectAtIndex:0];
    if ([view.Tileitem.fid isEqual:@"-1"]) {
        return YES;
    }
    return NO;
}

-(void)moveWebMasterFirst
{
    if (!self.tileArray.count) {
        return ;
    }
    A0_TileView *itemView =[self.tileArray objectAtIndex:0];
    if ([itemView.Tileitem.fid isEqual:@"-1"]) {
        return;
    }
    for (int index=0 ;index < self.tileArray.count; index ++) {
        A0_TileView *itemView =[self.tileArray objectAtIndex:index];
        if (index && [itemView.Tileitem.fid isEqualToString:@"-1"]) {
//            itemView.frame = [self createFrameindexLayoutTile:0];
            A0_TileView *tempitemView = [[A0_TileView alloc] initWithTileView:itemView];
            [self.tileArray removeObjectAtIndex:index];
            [self.tileArray insertObject:tempitemView atIndex:0];
            break;
        }
    }
    
    for (int i=0;i<self.tileArray.count;i++)
    {
        CGRect viewframe= [self createFrameLayoutTile:i];
        A0_TileView *item=[self.tileArray objectAtIndex:i];
        [UIView animateWithDuration:0.2 animations:^{
            item.frame=viewframe;
        }];
    }
    
}*/

- (BOOL)updateViewButtonWithTitle:(HOME2TOPICSPOSITIONITEM *)item index:(int)index
{
    BeeLog(@"---updateViewButtonWithTitle---");
    A0_TileView *view =(A0_TileView *)[self.scrollView viewWithTag: TILEVIEWSTARTTAG + item.fid.integerValue];
    if (!view)
    {
        [self inSertViewButtonWithTitle:item index:index];
      
    }
    else
    {
        [view dataChange:item];
        CGRect viewframe= [self createFrameindexLayoutTile:index];
        view.frame =viewframe;
    }
    
    return YES;
}
-(void)resizeScrollView:(CGRect)LastViewFrame
{
    BeeLog(@"---resizeScrollView---");
    // 动态增长contectSize
   float contentsizeheight = self.tileArray.count % 2>0?(self.tileArray.count +1)/2:(self.tileArray.count)/2;
    contentsizeheight = contentsizeheight * (kTileHeight) + (contentsizeheight +1) * kTileMarginV + 55;
    if (contentsizeheight > self.scrollView.frame.size.height)
    {
//        float contentsizeheight = self.tileArray.count % 2>0?(self.tileArray.count +1)/2:(self.tileArray.count)/2;
        
        self.scrollView.contentSize = CGSizeMake(320, contentsizeheight);
        NSLog(@"---多屏 %f scrollviewframe %f",self.scrollView.contentSize.height,self.scrollView.frame.size.height);
    }
    else
    {
//        float contentsizeheight = self.tileArray.count%2>0?(self.tileArray.count +1)/2:(self.tileArray.count)/2;
//        contentsizeheight = contentsizeheight * (kTileHeight +kTileMarginV) + 60 + 50;
//        self.scrollView.contentSize = CGSizeMake(320, contentsizeheight);
        CGRect rect = [UIScreen mainScreen].bounds;
        self.scrollView.contentSize =CGSizeMake(self.view.width, rect.size.height - bee.ui.config.baseInsets.top + 5);
        NSLog(@"---单屏 %f scrollviewframe %f",self.scrollView.contentSize.height,self.scrollView.frame.size.height);
    }
     scrollContentSize=self.scrollView.contentSize;
}

- (BOOL)addViewButtonWithTitle:(HOME2TOPICSPOSITIONITEM *)item
{
    BeeLog(@"--- addViewButtonWithTitle ---");
    for ( A0_TileView *view in self.tileArray) {
        if ([view.Tileitem.fid isEqualToString:item.fid]) {
            [self.tileArray removeObject:item];
            break;
        }
    }
    
    A0_TileView *view = [[A0_TileView alloc] initWithTarget:self dragaction:@selector(dragTile:) andlongpressaction:@selector(longPressTile:)]; 
    view.tag = TILEVIEWSTARTTAG + item.fid.integerValue;
    view.alpha=0;
    view.delegate=self;
    CGRect viewframe= [self createFrameLayoutTile:self.tileArray.count];
    [view dataChange:item];
    [self.tileArray addObject:view];
    // 动态增长contectSize
    view.frame =viewframe;
 
    [UIView animateWithDuration:0.8 delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.frame =viewframe;
                         view.alpha=1;
                     }
                     completion:^(BOOL f){
                          view.frame = viewframe;
                         view.alpha=1;
                     }];
    [self.scrollView addSubview:view];
    [self resizeScrollView:viewframe];
    scrollContentSize=self.scrollView.contentSize;
    self.scrollView.scrollsToTop=YES; 
    return YES;
}


- (CGRect)createFrameindexLayoutTile:(NSInteger)index
{
    //    int counter = self.tileArray.count;
    //    float height=bee.ui.config.baseInsets.top;
    BeeLog(@"--- createFrameindexLayoutTile  ---");
    int marginTop = (kTileHeight + kTileMarginV) * (index / 2 + 1) - (kTileHeight + kTileMarginV)+10.f;
   
    if (index % 2 == 0) {
        return CGRectMake(kTileMarginLeft1, marginTop, kTileWidth, kTileHeight);
    }
    else {
        return CGRectMake(kTileMarginLeft2, marginTop, kTileWidth, kTileHeight);
    }
}

- (CGRect)createFrameLayoutTile:(NSInteger)counter
{
//    int counter = self.tileArray.count;
//    float height=bee.ui.config.baseInsets.top;
    BeeLog(@"--- createFrame LayoutTile  ---");
    int marginTop = (kTileHeight + kTileMarginV) * (counter / 2 + 1) - (kTileHeight + kTileMarginV)+10.f;
 
    if (counter % 2 == 0) {
        return CGRectMake(kTileMarginLeft1, marginTop, kTileWidth, kTileHeight);
    }
    else {
        return CGRectMake(kTileMarginLeft2, marginTop, kTileWidth, kTileHeight);
    }
}


-(void)TileViewCloseBtnTap:(A0_TileView *)tileview
{
    //    TileView *tileView=(TileView *)signal.source;
     BeeLog(@"--- TileViewCloseBtnTap  ---");
    [self ReArrangTileViews:tileview];
}

-(void)startShakeAllTileViews
{
    for (int i= 0;i<self.tileArray.count;i++)
    {
        A0_TileView *item=[self.tileArray objectAtIndex:i];
        if ([item.Tileitem.fid isEqualToString:HOME_FID_TUIJIAN]) {
            continue;
        }
        [item.layer setShadowColor:[UIColor grayColor].CGColor];
        [item.layer setShadowOpacity:1.0f];
        [item.layer setShadowRadius:5.0f];
        item.editmode=YES;
        [item startShake];
    }
}
-(void)stopShakeAllTileViews
{
    for (int i = 0;i<self.tileArray.count;i++)
    {
        A0_TileView *item=[self.tileArray objectAtIndex:i];
        if ([item.Tileitem.fid isEqualToString:HOME_FID_TUIJIAN]) {
            continue;
        }
        [item.layer setShadowColor:[UIColor whiteColor].CGColor];
        [item.layer setShadowOpacity:0.0f];
        [item.layer setShadowRadius:0.0f];
        item.editmode=NO;
        [item stopShake];
    }
}

-(void)removeAllitems
{
    NSInteger count=_tileArray.count;
    for(int i=0;i<count;i++)
    {
        A0_TileView *item = [_tileArray objectAtIndex:0];
        [_tileArray removeObject:item];
        [item removeFromSuperview];
    }
}

//删除某一个模块 重新排序
-(void)ReArrangTileViews:(A0_TileView *)tileView
{
    BeeLog(@"---ReArrangTileViews---");
    if (tileView) {
        NSInteger removeIndex=[self.tileArray indexOfObject:tileView];
        if (removeIndex != NSNotFound) {
            [self.tileArray removeObject:tileView];
            [tileView removeFromSuperview];
        }
        //[NSString stringWithFormat:@"%ld",(long)removeIndex]
        [self sendUISignal:self.removeView withObject:tileView.Tileitem];
    }
    
    for (int i=0;i<self.tileArray.count;i++)
    {
        CGRect viewframe= [self createFrameLayoutTile:i];
        A0_TileView *item=[self.tileArray objectAtIndex:i];
         [UIView animateWithDuration:0.2 animations:^{
             item.frame=viewframe;
            }];
    }
    if (self.tileArray.count) {
        CGRect viewframe= [self createFrameLayoutTile:self.tileArray.count];
        [self resizeScrollView:viewframe];
    } 
}


#pragma mark - 手势操作

- (BOOL)longPressTile:(UILongPressGestureRecognizer *)recognizer
{
        A0_TileView *longPressView = (A0_TileView *)recognizer.view;
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
                    [self longdragTile:recognizer];
                }
                break;
            }
            case UIGestureRecognizerStateChanged:
            {
                [self longdragTile:recognizer];
                break;
            }
            case UIGestureRecognizerStateEnded:
                    NSLog(@"长按结束~~~");
                [self longdragTile:recognizer];
                [self sendUISignal:self.longPressEnd withObject:self.tileArray];
//                [longPressView stopShake];
                break;
            default: break;
        }
    return YES;
}
//UIPanGestureRecognizer
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

- (BOOL)longdragTile:(UILongPressGestureRecognizer *)recognizer
{
    if (!self.EDITMODE) {
        return NO;
    }
    switch ([recognizer state])
    {
        case UIGestureRecognizerStateBegan:
            [self dragTileBegan:(UIPanGestureRecognizer *)recognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragTileMoved:(UIPanGestureRecognizer *)recognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragTileEnded:(UIPanGestureRecognizer *)recognizer];
            break;
        default: break;
    }
    return YES;
}

- (void)dragTileBegan:(UIPanGestureRecognizer *)recognizer
{
    _dragFromPoint = recognizer.view.center;
     changeSrsIndex=-1;
     changeDesIndex=-1;
    [UIView animateWithDuration:0.2f animations:^{
        recognizer.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
        recognizer.view.alpha = 0.8; 

    }];
}
#pragma mark - 拖拽
- (void)dragTileMoved:(UIPanGestureRecognizer *)recognizer
{
    A0_TileView *titleview= (A0_TileView *)recognizer.view;
    if (!titleview.editmode) {//非编辑状态的不能拖拽
        return;
    }
    CGPoint pointInView = [recognizer locationInView:self.view];
    CGPoint _point = [recognizer locationInView:self.scrollView];
    recognizer.view.center =CGPointMake(_point.x, _point.y);
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
//    [recognizer setTranslation:CGPointZero inView:self.scrollView];
    
    [self rollbackPushedTileIfNecessaryWithPoint:recognizer.view.center];
    [self pushedTileMoveToDragFromPointIfNecessaryWithTileView:(A0_TileView *)recognizer.view];
 
    //上拉过程中
    if ((pointInView.y) <  bee.ui.config.baseInsets.top + kTileHeight/2) {
        if ((self.scrollView.contentOffset.y )>0) {
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y - 150) animated:YES];
        }
        else
        [self.scrollView setContentOffset:CGPointMake(0, - kTileHeight/2) animated:YES];
    }
    
    //下拉
    if ((pointInView.y + kTileHeight/2.0) > ( self.view.frame.size.height - TAB_HEIGHT) && (_point.y + kTileHeight*3/2) <scrollContentSize.height)
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

- (void)pushedTileMoveToDragFromPointIfNecessaryWithTileView:(A0_TileView *)tileView
{
    int tempchangeDesIndex = -1;
    changeSrsIndex = -1;
    for (int index=0;index<self.tileArray.count;index++)
    {
        A0_TileView *item =[self.tileArray objectAtIndex:index];
        if ([item.Tileitem.fid isEqualToString:HOME_FID_TUIJIAN]) {
            continue;
        }
        if (item && CGRectContainsPoint(item.frame, tileView.center) && ![item.Tileitem.fid isEqualToString:tileView.Tileitem.fid])
        {   //交换位置
            _dragToPoint = item.center;
            _dragToFrame = item.frame;
            _pushedTile = item;
            _isDragTileContainedInOtherTile = YES;
             [UIView animateWithDuration:0.2 animations:^{
                item.center = _dragFromPoint;
            }];
            tempchangeDesIndex = index;
            changeDesIndex = tempchangeDesIndex;
            BeeLog(@"changeDesIndex fid =%d",changeDesIndex);
            
            
        }
        if (item && [item.Tileitem.fid isEqualToString:tileView.Tileitem.fid]) {
            changeSrsIndex=index;
            BeeLog(@"changeSrsIndex fid =%d",index);
        }
        if (tempchangeDesIndex>0 && changeSrsIndex>0)
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
    changeSrsIndex=-1;
    changeDesIndex=-1;
    _pushedTile = nil;
    _isDragTileContainedInOtherTile = NO;
}

#pragma mark - getter

//- (NSMutableArray *)tileArray
//{
//    if (!_tileArray)
//    {
//        _tileArray = [[NSMutableArray alloc] init];
//    }
//    return _tileArray;
//}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height)];
        _scrollView.backgroundColor = [UIColor blueColor];
    }
    return _scrollView;
}

@end
