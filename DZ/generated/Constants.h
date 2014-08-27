//
//  Constants.h
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#ifndef DZ_Constants_h
#define DZ_Constants_h
#endif

//----------------------------------------------------------------- 颜色
#define KT_HEXCOLORA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define KT_HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.8]
#define KT_UIColorWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define KT_UIColorWithRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
#define KT_UICOLOR_CLEAR [UIColor clearColor]
#define KT_DEFAULT_COLOR [UIColor whiteColor]   //默认颜色
#define KT_BlueColor    KT_HEXCOLOR(0x44B5FF)//
//---------------------------------------------------------------- 颜色


//----------------------------------------------------------------- 倒圆角
#define KT_CORNER_RADIUS(_OBJ,_RADIUS)   _OBJ.layer.masksToBounds = YES;\
_OBJ.layer.cornerRadius = _RADIUS;
#define KT_CORNER_RADIUS_VALUE_2    2.0f
#define KT_CORNER_RADIUS_VALUE_5    5.0f
#define KT_CORNER_RADIUS_VALUE_10   10.0f
#define KT_CORNER_RADIUS_VALUE_15   15.0f
#define KT_CORNER_RADIUS_VALUE_20   20.0f
//---------------------------------------------------------------- 倒圆角

//----------------------------------------------------------------- IOS版本
#define KT_IOS_VERSION_5_OR_ABOVE (([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 5)? (YES):(NO))
#define KT_IOS_VERSION_6_OR_ABOVE (([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 6)? (YES):(NO))
#define KT_IOS_VERSION_7_OR_ABOVE (([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)? (YES):(NO))
#define KT_DEVICE_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//---------------------------------------------------------------- IOS版本



//----------------------------------------------------------------- 文本对齐格式
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define KT_TextAlignmentLeft   NSTextAlignmentLeft
#define KT_TextAlignmentCenter NSTextAlignmentCenter
#define KT_TextAlignmentRight  NSTextAlignmentRight
#else
#define KT_TextAlignmentLeft   UITextAlignmentLeft
#define KT_TextAlignmentCenter UITextAlignmentCenter
#define KT_TextAlignmentRight  UITextAlignmentRight
#endif
//---------------------------------------------------------------- 文本对齐格式


//----------------------------------------------------------------- 文本Size
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define KT_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin)\
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero
#define KT_TEXTSIZE_SIMPLE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero

#else

#define KT_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero
#define KT_TEXTSIZE_SIMPLE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero
#endif
//---------------------------------------------------------------- 文本Size



//UIFont的属性宏
#define GB_DEFAULT_FONT(fontSize)      [UIFont fontWithName:@"FZZhongDengXian-Z07S" size:fontSize]  //方正中等线简体
#define GB_FontHelvetica_BoldNeue(fontSize)   [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]
#define GB_FontHelveticaNeue(fontSize)    [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]

#define KT_LABELEWIFRAM(_OBJ, fm, txt, size, bgcolor, txtcolor, txtalignment, isbreak) \
    _OBJ.frame = fm;\
    _OBJ.text = txt;\
    _OBJ.font = GB_FontHelveticaNeue(size);\
    _OBJ.backgroundColor = bgcolor;\
    _OBJ.textColor = txtcolor;\
    _OBJ.textAlignment = txtalignment;\
    if(isbreak){\
    _OBJ.numberOfLines = 0;\
    _OBJ.lineBreakMode = NSLineBreakByWordWrapping;}

#define KT_CORNER_PROFILE(_OBJ) _OBJ.layer.masksToBounds = YES;\
[_OBJ.layer setCornerRadius:CGRectGetHeight([_OBJ bounds]) / 2];\
_OBJ.layer.borderWidth = 1;\
_OBJ.layer.borderColor = [[UIColor whiteColor] CGColor];


#define KT_IMGVIEW_CIRCLE(_OBJ,BDWITH) _OBJ.layer.masksToBounds = YES;\
[_OBJ.layer setCornerRadius:CGRectGetHeight([_OBJ bounds]) / 2];\
_OBJ.layer.borderWidth = BDWITH;\
_OBJ.layer.borderColor = [[UIColor whiteColor] CGColor];

#define KT_DATEFROMSTRING(string,confromTimespStr) NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;\
[formatter setDateStyle:NSDateFormatterMediumStyle];\
[formatter setTimeStyle:NSDateFormatterShortStyle];\
[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];\
NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[string integerValue]];\
confromTimespStr = [formatter stringFromDate:confromTimesp];

//--------------------------首页配置--------------------------------------
#define HOME_FID_TUIJIAN @"-1"
#define HOME_FID_NEWEST @"-3"
#define HOME_FID_HOTEST @"-4"
#define HOME_FID_DIGEST @"-6"
#define HOME_FID_MINE @"-2"
#define HOME_FID_ACTIVITY @"-8"
#define HOME_FID_ADD @"-7"
#define HOME_FID_GUANGGAO @"-5"

//--------------------------系统颜色--------------------------------------
//是否需要配置图片链接访问加密
#define IMAGEURLNEEDADDSECRET 0
#define kDuration 0.3

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

#undef	TAB_HEIGHT
#define TAB_HEIGHT	49.0f

#define SYS_AUTHORID @"authorid"
#define SYS_AUTHORNAME @"authorname"
#define SYS_AUTHORPASSWORD @"authorpassword"

#define CLR_FOREGROUND [UIColor whiteColor]
//[UIColor colorWithRed:236.0/255.0 green:237.0/255.0 blue:244.0/255.0 alpha:1.0]
#define CLR_BACKGROUND [UIColor colorWithRed:236.0/255.0 green:237.0/255.0 blue:244.0/255.0 alpha:1.0]
#define CLR_BUTTON_TXT [UIColor whiteColor]
//[UIColor colorWithRed:20/255. green:154/255. blue:243/255. alpha:1]

#define VOTECOLOR [UIColor colorWithRed:255./255. green:251./255. blue:229./255. alpha:1]
#define DAYCOLOR  [UIColor colorWithRed:169/255. green:203/255. blue:178/255. alpha:1]
#define DAYMASRKCOLOR [UIColor colorWithRed:155/255. green:167/255. blue:197/255. alpha:1]
#define DAYICONCOLOR [UIColor colorWithRed:60/255. green:18/255. blue:16/255. alpha:1]
#define PLACEHOLDERCOLOR [UIColor colorWithRed:201./255 green:201./255 blue:201./255 alpha:1]
#define PLACEHOLDERFONT [UIFont systemFontOfSize:13]

/*!
 kHeightOfTopScrollView
 */
#define SLIDSWITCH_SECTIONS_HEIGHT 44.0f

#define LINE_LAYERBOARD_NOTCGCOLOR [UIColor colorWithWhite:0.8 alpha:1.0f]
#define LINE_LAYERBOARDCOLOR [UIColor colorWithWhite:0.8 alpha:1.0f].CGColor
#define LINE_LAYERBOARDWIDTH 0.5f


#undef	FORUMCELLDIDADDHOMECOLOR
#define FORUMCELLDIDADDHOMECOLOR [UIColor colorWithRed:20/255. green:155/255. blue:242/255.  alpha:1] 

#define MODELOBJECTKEY(...)  [@[__VA_ARGS__] componentsJoinedByString:@"."]


#undef	PER_PAGE
#define PER_PAGE	(20)
