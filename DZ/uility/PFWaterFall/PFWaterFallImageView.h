//
//  PFWaterFallImageView.h
//  DZ
//
//  Created by PFei_He on 14-6-11.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFWaterFallImageInfo;

@interface PFWaterFallImageView : UIView

@property (nonatomic, strong) PFWaterFallImageInfo *imageInfo;

/**
 * @brief 初始化图片
 * @param y: 图片的Y坐标
 * @param numberOfImage: 图片的序号
 */
- (id)initWithImageInfo:(PFWaterFallImageInfo *)imageInfo y:(float)y numberOfImage:(int)numberOfImage;

@end

@interface PFWaterFallImageInfo : NSObject

///图片的url地址
@property (nonatomic, copy) NSString *url;

///图片宽度
@property float width;

///图片高度
@property float height;

/**
 * @brief 初始化瀑布流的图片
 * @param dictionary: 图片所在的字典（字典必须包括参数：url，width，height）
 */
- (id)initWithImage:(NSDictionary *)dictionary;

/**
 * @brief 初始化瀑布流的图片
 * @param url: 图片的url地址
 * @param width: 图片宽度
 * @param height: 图片高度
 */
- (id)initWithImage:(NSString *)url width:(float)width height:(float)height;

@end
