//
//  DZ_SystemSetting.m
//  DZ
//
//  Created by Nonato on 14-6-10.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import "DZ_SystemSetting.h"
#import "UserModel.h"
#import "TouchXML.h"
#import <objc/runtime.h>
#pragma mark - 程序外配置信息
@implementation DZ_CONFIG_NAVIGATIONBAR
@end

@implementation DZ_CONFIG_TABBAR
@end

@implementation DZ_CONFIGURATION
@end

#pragma  mark - 程序内配置信息
@implementation DZ_SYS_IGNORE
@end

#pragma mark - 是否保存密码
@implementation DZ_SYS_SAVESCR
@end

@implementation DZ_AboutUs
@end

@implementation DZ_SystemSetting
DEF_SINGLETON(DZ_SystemSetting)

-(id)init
{
    self=[super init];
    if (self) {
        NSString *folderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [folderPath stringByAppendingPathComponent:@"DZ_Config.xml"];
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:filePath])//文件存在 则加载该文件
        {
            filePath=[[NSBundle mainBundle] pathForResource:@"DefaultConfigure" ofType:@"xml"];
        }//文件不存在加载默认配置文件
        NSData *XMLData = [NSData dataWithContentsOfFile:filePath];
        //生成CXMLDocument对象
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:XMLData
                                                            options:0
                                                              error:nil];
        
        NSDictionary *diction= [self parseRoot:document];
        self.websiteurl = [[diction valueForKey:@"websiteurl"] valueForKey:@"text"];
        self.idourl = [[diction valueForKey:@"idourl"] valueForKey:@"text"];
        self.forumurl =  [[diction valueForKey:@"forumurl"] valueForKey:@"text"];
        self.weixinappid = [[diction valueForKey:@"weixinappid"] valueForKey:@"text"];
        self.sinaweiboappkey = [[diction valueForKey:@"sinaweiboappkey"] valueForKey:@"text"];
        self.downloadurl = [[diction valueForKey:@"downloadurl"] valueForKey:@"text"];
        
        self.feedbackurl =[NSString stringWithFormat:@"%@/feedback.php",self.idourl];
        self.logurl =[NSString stringWithFormat:@"%@/log.php",self.idourl];
        
        self.appid =[[diction valueForKey:@"appid"] valueForKey:@"text"];
        self.appname =[[diction valueForKey:@"appname"] valueForKey:@"text"];
        self.appversion = [[diction valueForKey:@"appversion"] valueForKey:@"text"];
        self.configration = [DZ_CONFIGURATION objectFromDictionary:diction];
    }
    return self;
}



-(UIColor *)navigationBarColor
{
    if (!_navigationBarColor) {
        unsigned long red = strtoul([self.configration.navigationbar.backgroundColor UTF8String], 0, 16);
        UIColor *color=KT_HEXCOLORA(red,0.98);
        _navigationBarColor = color;
    }
    return _navigationBarColor;
}

-(UIColor *)tabbarbackgroundColor
{
    if (!_tabbarbackgroundColor) {
        unsigned long red = strtoul([self.configration.tabbar.backgroundColor UTF8String], 0, 16);
        UIColor *color=KT_HEXCOLORA(red,0.95);
        _tabbarbackgroundColor = color;
    }
    return _tabbarbackgroundColor;
}

-(UIColor *)tabBarHighLightColor
{
    if (!_tabBarHighLightColor) {
        unsigned long red = strtoul([self.configration.tabbar.HighLightColor UTF8String],0,16);
        UIColor *color=KT_HEXCOLOR(red);
        _tabBarHighLightColor = color;
    }
    return _tabBarHighLightColor;
}
-(UIColor *)tabbarselectediconcolor
{
    if (!_tabbarselectediconcolor) {
        unsigned long red = strtoul([self.configration.tabbar.selectediconcolor UTF8String],0,16);
        UIColor *color=KT_HEXCOLOR(red);
        _tabbarselectediconcolor = color;
    }
    return _tabbarselectediconcolor;
}
-(UIColor *)tabBarIconColor
{
    if (!_tabBarIconColor) {
        unsigned long red = strtoul([self.configration.tabbar.iconcolor UTF8String],0,16);
        UIColor *color=KT_HEXCOLOR(red);
        _tabBarIconColor = color;
    }
    return _tabBarIconColor;
}

-(UIColor *)tabBarColor
{
    if (!_tabBarColor) {
        unsigned long red = strtoul([self.configration.tabbar.backgroundColor UTF8String],0,16);
        UIColor *color=KT_HEXCOLOR(red);
        _tabBarColor = color;
    }
    return _tabBarColor;
}
//获得一个类中的所有变量和函数名
//传递一个变量名称stringxing和类名称string型 得到其对应的值
- (NSString *)nameWithInstance:(id)instance target:(id)target
{
    unsigned int numIvars = 0;
    NSString *myvalue= [[NSString alloc] init];
    Ivar * ivars = class_copyIvarList([target class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        
        NSString *key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        NSString *instance2 = [NSString stringWithFormat:@"_%@",instance];
        // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ([key isEqualToString:instance] || [key isEqualToString:instance2]) {
            //　获取变量值
            id value = [target valueForKey:key];
            myvalue = value;
            break;
        } 
    }
    free(ivars);
    return myvalue;
    
}

+(NSMutableArray *)classtoarray:(id)cls
{
    unsigned int numIvars = 0;
//    NSString *myvalue= [[NSString alloc] init];
    NSMutableArray * array =[[NSMutableArray alloc] init];
    Ivar * ivars = class_copyIvarList([cls class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        
        NSString *key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
//        if ([key isEqualToString:instance] || [key isEqualToString:instance2]) {
            //　获取变量值
        id value = [cls valueForKey:key];
        [array addObject:value];
//            myvalue = value;
//            break;
//        }
    }
    free(ivars);
    return array;
}

-(NSString *)aboutus:(NSString *)para
{
//    NSString *classstr=[NSString stringWithFormat:@"self.configration.aboutus.%@",para];
    NSString *string = [self nameWithInstance:para target:self.configration.aboutus];//(NSString *) NSClassFromString(classstr);
    return string;
}
#pragma mark - 解析xml配置数据
- (NSDictionary *) parseRoot:(CXMLDocument *) document
{
    CXMLElement *root = [document rootElement];
    NSArray *books = [root children];
   
    NSMutableDictionary *nodeitem = [[NSMutableDictionary alloc] init];
    for (CXMLElement *element in books)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [element childCount]; i++)
            {
                
                if ([[[element children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
                    if ([[element name] isEqualToString:@"navigationbar"])
                    {
                        [item setObject:[[element childAtIndex:i] stringValue] forKey:[[element childAtIndex:i] name]];
                        NSLog(@"1--%@", [[element childAtIndex:i] stringValue] );
                    }
                    if ([[element name] isEqualToString:@"tabbar"])
                    {
                        [item setObject:[[element childAtIndex:i] stringValue] forKey:[[element childAtIndex:i] name]];
                        NSLog(@"2--%@", [[element childAtIndex:i] stringValue] );
                    }
                    if ([[element name] isEqualToString:@"aboutus"])
                    {
                        [item setObject:[[element childAtIndex:i] stringValue] forKey:[[element childAtIndex:i] name]];
                        NSLog(@"2--%@", [[element childAtIndex:i] stringValue] );
                    }
                }
                    [item setObject:[[element childAtIndex:i] stringValue] forKey:[[element childAtIndex:i] name]];
                    NSLog(@"3--%@", [[element childAtIndex:i] stringValue] );
            }
            if (item) {
                [nodeitem setObject:item forKey:[element name]];
            }
        }
    }
    NSLog(@"%@", nodeitem);
    return nodeitem;
}


- (void) parseDire:(CXMLDocument *) document
{
    NSArray *books = NULL;
    books = [document nodesForXPath:@"//navigationbar" error:nil];
    for (CXMLElement *element in books)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [element childCount]; i++)
            {
                if ([[[element children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
                    [item setObject:[[element childAtIndex:i] stringValue]
                             forKey:[[element childAtIndex:i] name]
                     ];
                    NSLog(@"%@", [[element childAtIndex:i] stringValue]);
                }
            }
            //NSLog(@"%@", item);
        }
    }
    //
    books = [document nodesForXPath:@"//tabbar" error:nil];
    for (CXMLElement *element in books)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [element childCount]; i++)
            {
                if ([[[element children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
                    [item setObject:[[element childAtIndex:i] stringValue]
                             forKey:[[element childAtIndex:i] name]
                     ];
                    NSLog(@"%@", [[element childAtIndex:i] stringValue]);
                }
            }
            //NSLog(@"%@", item);
        }
    }
}


#pragma mark - 是否保存密码
-(BOOL)saveUserSecret
{
    NSString *key=KEY_REMEMBERSECRET;
    DZ_SYS_SAVESCR *ignore=[DZ_SYS_SAVESCR readObjectForKey:key];
    return ignore.save.boolValue;
    
}

-(void)saveUserSecret:(BOOL)save
{
    DZ_SYS_SAVESCR *ignore=[[DZ_SYS_SAVESCR alloc] init];
    ignore.save=[NSNumber numberWithBool:save];
    NSString *key=KEY_REMEMBERSECRET;
    [DZ_SYS_SAVESCR  saveObject:ignore forKey:key];
}

+(BOOL)saveUserSecret
{
    DZ_SystemSetting *setting=[[DZ_SystemSetting alloc] init];
    return [setting saveUserSecret];
}

+(void)saveUserSecret:(BOOL)save
{
     DZ_SystemSetting *setting=[[DZ_SystemSetting alloc] init];
    [setting saveUserSecret:save];
}

#pragma mark - 忽略系统消息

-(void)saveIgnoreSetting:(MSG_TYPE_FILTE) msg_type ignore:(BOOL)isignore
{
    DZ_SYS_IGNORE *ignore=[[DZ_SYS_IGNORE alloc] init];
    ignore.ignore=[NSNumber numberWithBool:isignore];
    
    NSString *key=MODELOBJECTKEY([UserModel sharedInstance].session.uid,[NSString stringWithFormat:@"%d",msg_type]);
    [DZ_SYS_IGNORE  saveObject:ignore forKey:key];
}

-(BOOL)readIgnoreSetting:(MSG_TYPE_FILTE) msg_type
{
     NSString *key=MODELOBJECTKEY([UserModel sharedInstance].session.uid,[NSString stringWithFormat:@"%d",msg_type]);
    DZ_SYS_IGNORE *ignore=[DZ_SYS_IGNORE readObjectForKey:key];
    return ignore.ignore.boolValue;
}

+(void)saveIgnoreSetting:(MSG_TYPE_FILTE)msg_type ignore:(BOOL)isignore
{
    DZ_SystemSetting *setting=[[DZ_SystemSetting alloc] init];
    [setting saveIgnoreSetting:msg_type ignore:isignore];
}

+(BOOL)readIgnoreSetting:(MSG_TYPE_FILTE) msg_type
{
    DZ_SystemSetting *setting=[[DZ_SystemSetting alloc] init];
    return [setting readIgnoreSetting:msg_type];
}
@end
