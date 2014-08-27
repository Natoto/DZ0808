//
//  CreateComponent+NSObject.h
//  DZ
//
//  Created by Nonato on 14-8-5.
//
//
#import "DZ_SystemSetting.h"
#import <Foundation/Foundation.h>
#import "Bee.h"
@interface CreateComponent: NSObject

+(BeeUITextView *)CreateTextviewWithFrame:(CGRect)frame andTxt:(NSString *)TXT;
+(UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT;
+(UIButton *)CreateButtonWithFrame:(CGRect)frame andImage:(NSString *)image tag:(int)tag title:(NSString *)title titlecolor:(UIColor *)titlecolor target:(id)target sel:(SEL)selector bgcolor:(UIColor *)bgcolor;
+(UIButton *)CreateButtonWithFrame:(CGRect)frame andImage:(NSString *)image tag:(int)tag;

+ (BeeUIImageView *)CreateImageViewWithFrame:(CGRect)frame andImgName:(NSString *)imgname;
//+ (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT;
+ (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT txtcolor:(UIColor *)color;
+ (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT;
@end
