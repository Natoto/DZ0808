//
//  ToolsFunc.m
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "ToolsFunc.h"

@implementation ToolsFunc
DEF_SINGLETON(ToolsFunc)

+ (NSString *)datefromstring:(NSString *)timestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr integerValue]];
    NSString *confromTimespStr =[confromTimesp timeAgo]; // [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)datefromstring2:(NSString *)timestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


+ (BeeUIImageView *)CreateImageViewWithFrame:(CGRect)frame andImgName:(NSString *)imgname
{
    BeeUIImageView *imgView=[[BeeUIImageView alloc] initWithFrame:frame];
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    //imgView.data=imgname;
    imgView.image=[UIImage bundleImageNamed:imgname];
    return imgView;
}

+ (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    UILabel *label=[[UILabel alloc] initWithFrame:frame];
    label.text=TXT;
    label.font=[UIFont systemFontOfSize:15];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT txtcolor:(UIColor *)color
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
    [button setTitle:TXT forState:UIControlStateNormal];
    button.frame=frame;
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
    [button setTitle:TXT forState:UIControlStateNormal];
    button.frame=frame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

//selector传递多个参数
+ (SEL)hbselector:(SEL)oldselector target:(id)target firstArgument:(id)firstArgument , ...
{
    SEL theSelector = oldselector;
    NSMethodSignature * sig = [target methodSignatureForSelector:theSelector];
    NSInvocation * theInvocation = [NSInvocation
                                    invocationWithMethodSignature:sig];
    [theInvocation setTarget:target];
    [theInvocation setSelector:theSelector];
    [theInvocation setArgument:&firstArgument atIndex:2];
    va_list args;
    int index = 0;
    va_start( args, firstArgument);
    id argument = va_arg(args,id);
    [theInvocation setArgument:&argument atIndex:3 + index];
    index ++;
    va_end(args);
    [theInvocation retainArguments];
    return theSelector;
}

@end


