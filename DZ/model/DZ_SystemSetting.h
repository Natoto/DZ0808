//
//  DZ_SystemSetting.h
//  DZ
//
//  Created by Nonato on 14-6-10.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "PMModel.h"

#define KEY_REMEMBERSECRET @"key.remembersecret"
@interface DZ_CONFIG_NAVIGATIONBAR :NSObject
@property(nonatomic,retain)NSString *backgroundColor;
@property(nonatomic,retain)NSString *backgroundimg;
@end

@interface DZ_CONFIG_TABBAR :NSObject
@property(nonatomic,retain)NSString * iconcolor;
@property(nonatomic,retain)NSString * backgroundColor;
@property(nonatomic,retain)NSString * backgroundimg;
@property(nonatomic,retain)NSString * HighLightImage;
@property(nonatomic,retain)NSString * HighLightColor;
@property(nonatomic,retain)NSString * selectediconcolor;
@end

@interface DZ_AboutUs : NSObject
@property(nonatomic,retain)NSString * abstract;
@property(nonatomic,retain)NSString * email;
@property(nonatomic,retain)NSString * qq;
@property(nonatomic,retain)NSString * website;
@property(nonatomic,retain)NSString * clientversion;
@end
@interface DZ_CONFIGURATION :NSObject
@property(nonatomic, retain)DZ_CONFIG_NAVIGATIONBAR * navigationbar;
@property(nonatomic, retain)DZ_CONFIG_TABBAR        * tabbar;
@property(nonatomic, retain)DZ_AboutUs              * aboutus;
@end


@interface DZ_SYS_IGNORE : NSObject
@property(nonatomic,retain) NSNumber *ignore;
@end

@interface DZ_SYS_SAVESCR : NSObject
@property(nonatomic,retain) NSNumber *save;
@end


@class DZ_CONFIGURATION;
@interface DZ_SystemSetting : BeeStreamViewModel

AS_SINGLETON(DZ_SystemSetting)

@property (nonatomic, strong) DZ_CONFIGURATION * configration;
@property (nonatomic, strong) NSString * websiteurl;
@property (nonatomic, strong) NSString * feedbackurl;
@property (nonatomic, strong) NSString * appid;
@property (nonatomic, strong) NSString * appname;
@property (nonatomic, strong) NSString * appversion;
@property (nonatomic, strong) NSString * launchImage;
@property (nonatomic, strong) NSString * idourl;
@property (nonatomic, strong) NSString * logurl;
@property (nonatomic, strong) NSString * forumurl;
@property (nonatomic, strong) NSString * weixinappid;
@property (nonatomic, strong) NSString * sinaweiboappkey;
@property (nonatomic, strong) NSString * downloadurl;

//读取颜色配置
@property (nonatomic, strong) UIColor * navigationBarColor;
@property (nonatomic, strong) UIColor * tabBarColor;
@property (nonatomic, strong) UIColor * tabBarHighLightColor;
@property (nonatomic, strong) UIColor * tabbarselectediconcolor;
@property (nonatomic, strong) UIColor * tabbarbackgroundColor;
@property (nonatomic, strong) UIColor * tabBarIconColor;
//忽略消息
-(void)saveIgnoreSetting:(MSG_TYPE_FILTE) msg_type ignore:(BOOL)isignore;
-(BOOL)readIgnoreSetting:(MSG_TYPE_FILTE) msg_type;

+(BOOL)readIgnoreSetting:(MSG_TYPE_FILTE) msg_type;
+(void)saveIgnoreSetting:(MSG_TYPE_FILTE) msg_type ignore:(BOOL)isignore;

+(NSMutableArray *)classtoarray:(id)cls;
//保存密码
-(BOOL)saveUserSecret;
-(void)saveUserSecret:(BOOL)save;

+(BOOL)saveUserSecret;
+(void)saveUserSecret:(BOOL)save;
//读取颜色配置
//-(UIColor *)tabBarIconColor;
//-(UIColor *)navigationBarColor;
//-(UIColor *)tabBarColor;
//-(UIColor *)tabBarHighLightColor;
//-(UIColor *)tabbarselectediconcolor;
//-(UIColor *)tabbarbackgroundColor;

-(NSString *)aboutus:(NSString *)para;
@end
