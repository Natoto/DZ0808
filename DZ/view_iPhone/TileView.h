//
//  TileView.h
//  IPhoneTest
//
//  Created by Lovells on 13-8-27.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#define kTileWidth  140.f
#define kTileHeight kTileWidth
@class TileView;
@class HOME2TOPICSPOSITIONITEM;
@protocol TileViewCloseBtnTapDelegate <NSObject>

- (void)TileViewCloseBtnTap:(TileView *)tileview;

@end

@interface TileView :UIView<UIGestureRecognizerDelegate>
//{
//   NSObject <TileViewCloseBtnTapDelegate> *delegate;
//}
@property(nonatomic,assign) BOOL enableDelete;
@property(nonatomic,assign) BOOL editmode;
@property (nonatomic, assign) NSObject <TileViewCloseBtnTapDelegate> * delegate;
@property(nonatomic,retain) HOME2TOPICSPOSITIONITEM *Tileitem;
@property(nonatomic,retain) BeeUIImageView * imgView;
@property(nonatomic,retain) UILabel * synopsislbl;
@property(nonatomic,retain) UILabel * titlelbl;
- (id)initWithTarget:(id)target dragaction:(SEL)dragaction andlongpressaction:(SEL)longpressaction;
AS_SIGNAL(mask);
AS_SIGNAL(CLOSTBTNTAPPED);

- (void)startShake;
- (void)stopShake;
@end
