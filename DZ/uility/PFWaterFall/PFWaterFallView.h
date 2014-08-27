//
//  PFWaterFallView.h
//  DZ
//
//  Created by PFei_He on 14-6-11.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFWaterFallImageView.h"

@protocol PFWaterFallViewDatagate <NSObject, UIScrollViewDelegate>

@required

/**
 * @brief 点击图片后调用的方法（打开图片细节）
 */
- (void)touchImage:(PFWaterFallImageInfo *)imageInfo;

@end

@interface PFWaterFallView : UIScrollView

///图片对象数组
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, weak) id<PFWaterFallViewDatagate> delegate;

/**
 * @brief 初始化瀑布流
 * @param 图片对象数组
 */
- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)array;

/**
 * @brief 刷新瀑布流
 */
- (void)refresh:(NSArray *)array;

/**
 * @brief 加载更多
 */
- (void)loadMore:(NSArray *)array;

@end
