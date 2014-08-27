//
//  ToolsFunc.h
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "DZ_SystemSetting.h"
#import <Foundation/Foundation.h>
#import "Bee.h"
#import "UIImage+Tint.h"
@interface ToolsFunc : NSObject
AS_SINGLETON(ToolsFunc)
+(NSString *)datefromstring:(NSString *)timestr;
+(NSString *)datefromstring2:(NSString *)timestr;

+(BeeUIImageView *)CreateImageViewWithFrame:(CGRect)frame andImgName:(NSString *)imgname;
+(UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT;
+(UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT txtcolor:(UIColor *)color;
+(UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT;
+(SEL)hbselector:(SEL)oldselector target:(id)target firstArgument:(id)firstArgument , ...;
@end
