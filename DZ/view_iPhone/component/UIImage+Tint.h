//
//  UIImage+Tint.h
//  DZ
//
//  Created by Nonato on 14-5-20.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
//改变图片的颜色
@interface  UIImage (Tint)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
