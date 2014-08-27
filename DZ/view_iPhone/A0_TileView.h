//
//  TileView.h
//  IPhoneTest
//
//  Created by Lovells on 13-8-27.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#define kTileWidth  145.f
#define kTileHeight 137.f  //kTileWidth
@class A0_TileView;
@class HOME2TOPICSPOSITIONITEM;
@protocol TileViewCloseBtnTapDelegate <NSObject>

- (void)TileViewCloseBtnTap:(A0_TileView *)tileview;

@end

@interface A0_TileView :UIView<UIGestureRecognizerDelegate,NSCopying>
//{
//   NSObject <TileViewCloseBtnTapDelegate> *delegate;
//}
@property(nonatomic,assign) BOOL enableDelete;
@property(nonatomic,assign) BOOL editmode;
@property (nonatomic, assign) NSObject <TileViewCloseBtnTapDelegate> * delegate;
@property(nonatomic,retain) HOME2TOPICSPOSITIONITEM *Tileitem;
@property(nonatomic,retain) BeeUIImageView * imgView;
@property(nonatomic,retain) BeeUILabel * synopsislbl;
@property(nonatomic,retain) UILabel * titlelbl;
- (id)initWithTarget:(id)target dragaction:(SEL)dragaction andlongpressaction:(SEL)longpressaction;
AS_SIGNAL(mask);
AS_SIGNAL(CLOSTBTNTAPPED);

-(void)dataChange:(HOME2TOPICSPOSITIONITEM *)item;
- (void)startShake;
- (void)stopShake;
-(id)initWithTileView:(A0_TileView *)item;
@end
