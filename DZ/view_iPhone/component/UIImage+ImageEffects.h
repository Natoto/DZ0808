//
//  BeeUIImageView+ImageEffects.h
//  DZ
//
//  Created by Nonato on 14-7-9.
//
//

#import "Bee_UIImageView.h"
/*
 毛玻璃效果
 
 首先需要导入Accelerate.framework。
 */
@interface UIImage(ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
