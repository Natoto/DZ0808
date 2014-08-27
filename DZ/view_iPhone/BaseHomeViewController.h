//
//  ViewController.h
//  IPhoneTest
//
//  Created by Lovells on 13-8-20.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "homeModel.h"
#import "BaseBoard_iPhone.h"

@class TileView;
@interface BaseHomeViewController : BaseBoard_iPhone
{
    // 拖动的tile的原始center坐标
    CGPoint _dragFromPoint;
    
    // 要把tile拖往的center坐标
    CGPoint _dragToPoint;
    
    // tile拖往的rect
    CGRect _dragToFrame;
    
    // 拖拽的tile是否被其他tile包含
    BOOL _isDragTileContainedInOtherTile;
    
    // 拖拽往的目标处的tile
    TileView *_pushedTile;
    CGSize   scrollContentSize;
    float    scrollOffset;

}
AS_SIGNAL(longPressEnd)
AS_SIGNAL(dragViewEnd)
AS_SIGNAL(removeView)
@property(nonatomic,assign) BOOL  EDITMODE;
@property (nonatomic, readonly) NSMutableArray *tileArray;
@property (nonatomic, readonly) UIScrollView *scrollView;


- (void)createButtonAndAddToSelfView;
- (BOOL)addViewButtonWithTitle:(HOME2TOPICSPOSITIONITEM *)item;
-(void)ReArrangTileViews:(TileView *)tileView;
@end
