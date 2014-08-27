//
//  AppDelegate.m
//  DZ
//
//  Created by Nonato on 14-3-31.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
//#import "bee.services.alipay.h"
//#import "bee.services.location.h"
#import "bee.services.share.tencentweibo.h"
#import "bee.services.wizard.h"
#import "bee.services.push.h"

#import "AppDelegate.h"
#import "model.h"
#import "AppBoard_iPhone.h"
#import "UIImage+Tint.h"
#import <CFNetwork/CFNetwork.h>
#import "DZ_SystemSetting.h"
#import "FaceBoard.h" 
#import "IDO_LogModel.h"
//#import "XHBaseNavigationController.h"
#import "UIImage+Bundle.h"
//最大号文字 34 导航
//30 导航右 文章标题
//22 灰
//table线 上30 下26灰
//记住密码页面26
//设置默认灰30 背景 按钮26 请登录22

static NSString *const ID_KEY = @"id";
#pragma mark -
#pragma mark Category 1
@interface AppDelegate()
{
    
}
@property(nonatomic,retain)IDO_LogModel *logmodel;
@end
@implementation AppDelegate 


#pragma mark -

- (void)load
{ 
    
    //    NSMutableArray *array =[[NSMutableArray alloc] init];
    /*<strong><font size='5'>为什么说广州是中国最特别的城市呢? </font></strong><br />by何建晔，资深财经媒体人。<br /><br /><strong>
    
    <font size='3'>爱的理由是相对的</font>*/
//    [FaceBoard getImageTextRange:@":)fasffafksfaf:handshakesdg:(" :array];
    NSString *str=@"<strong><font size='5'>为什么说广州是中国最特别的城市呢? </font></strong><br />by何建晔，资深财经媒体人。<br /><br /><strong>";
    [str isallHtmlMark];
    
	[UIApplication sharedApplication].statusBarHidden = NO;
	bee.ui.config.ASR = YES;
    if (IOS7_OR_LATER) {
        bee.ui.config.iOS7Mode = YES;
    }
    else
    {
        bee.ui.config.iOS6Mode = YES;
    }
    /*
     系统网络设置
     */
    DZ_SystemSetting *setting = [DZ_SystemSetting sharedInstance];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{       
            NSString *url4=  setting.websiteurl;
            if (!url4) {
                [self showalert:@"论坛URL为空"];
                return;
            }
            NSString *feedbackUrl = setting.feedbackurl;
            if (!feedbackUrl) {
                [self showalert:@"论坛反馈地址为空"];
            }
            [ServerConfig sharedInstance].url=url4;
            [ServerConfig sharedInstance].feedbackUrl = feedbackUrl;
            [ServerConfig sharedInstance].idowebsiteurl = setting.logurl;
    });
   /*
    启动画面
    */
//    [self configwizard];
    /*
     配置导航条
     */
    UIImage *imgnavigationbar=[UIImage bundleImageNamed:@"navigationbar.jpg"];
     imgnavigationbar =[imgnavigationbar imageWithTintColor:[setting navigationBarColor]];
    [BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
    [BeeUINavigationBar setBackgroundImage:imgnavigationbar];
    [[UIBarButtonItem appearance] setTitleTextAttributes: @{ UITextAttributeFont: [UIFont systemFontOfSize:16.0], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateHighlighted];
	
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //隐藏边框
    /*[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];*/
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    BeeLog(@": = %@",[[NSBundle mainBundle] resourcePath]);
    [self observeNotification:BeeReachability.CHANGED];
    [self observeNotification:BeeReachability.UNREACHABLE];
    
    NSLog(NSLocalizedString(@"NSLocalizedString", @"NSLocalizedString"));
    /*
     分享设置
     */
    //微信注册
    [WXApi registerApp:setting.weixinappid];
    //新浪微博注册 
    [WeiboSDK registerApp:setting.sinaweiboappkey];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //统计数据
         _logmodel =[IDO_LogModel modelWithObserver:self];
        [_logmodel firstPage];
    });
    
    self.window.rootViewController = [AppBoard_iPhone sharedInstance];
}

-(void)configwizard
{
    // 配置闪屏
	bee.services.wizard.config.showBackground = YES;
	bee.services.wizard.config.showPageControl = YES;
	bee.services.wizard.config.backgroundImage = [UIImage imageNamed:@"Default@2x"];
	bee.services.wizard.config.pageDotSize = CGSizeMake( 11.0f, 11.0f );
	bee.services.wizard.config.pageDotNormal = [UIImage imageNamed:@"tuitional-carousel-active-btn.png"];
	bee.services.wizard.config.pageDotHighlighted = [UIImage imageNamed:@"tuitional-carousel-btn.png"];
	bee.services.wizard.config.pageDotLast = [UIImage imageNamed:@"tuitional-carousel-btn-last.png"];
  
	bee.services.wizard.config.splashes[0] = @"wizard_1.xml";
	bee.services.wizard.config.splashes[1] = @"wizard_2.xml";
	bee.services.wizard.config.splashes[2] = @"wizard_3.xml";
	bee.services.wizard.config.splashes[3] = @"wizard_4.xml";
	bee.services.wizard.config.splashes[4] = @"wizard_5.xml";
// 配置提示框
//	{
//		[BeeUITipsCenter setDefaultContainerView:self.window];
//		[BeeUITipsCenter setDefaultBubble:[UIImage imageNamed:@"alertBox.png"]];
//		[BeeUITipsCenter setDefaultMessageIcon:[UIImage imageNamed:@"icon.png"]];
//		[BeeUITipsCenter setDefaultSuccessIcon:[UIImage imageNamed:@"icon.png"]];
//		[BeeUITipsCenter setDefaultFailureIcon:[UIImage imageNamed:@"icon.png"]];
//	}
}

ON_SIGNAL3(IDO_LogModel, RELOADED, signal)
{
    NSLog(@"统计数据完成...");
}

ON_SIGNAL3(IDO_LogModel, FAILED, signal)
{
    NSLog(@"统计数据失败...");
}

-(void)showalert:(NSString *)message
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"警告" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

- (void)unload
{
	[self unobserveAllNotifications];
    [self.logmodel removeAllObservers];
}

ON_NOTIFICATION3(BeeReachability, CHANGED, notify)
{
    if ([BeeReachability isReachableViaWIFI] ) {
//        [self presentMessageTips:@"已切换至WIFI状态"];
    }
    else if ([BeeReachability isReachableViaWLAN])
    {
//         [self presentMessageTips:@"已切换至数据网络,请注意流量"];
    }
}

ON_NOTIFICATION3(BeeReachability, UNREACHABLE, notify)
{
    [self presentMessageTips:@"网络出问题了额"];
}

#pragma mark -

- (void)updateConfig
{
    
}

#pragma mark - share

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self], /*[self.wbapi handleOpenURL:url],*/ [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"分享结果"];
        NSString *strMsg;
        if (resp.errCode == 0) {
            strMsg = [NSString stringWithFormat:@"发送成功"];
        } else {
            strMsg = [NSString stringWithFormat:@"发送失败"];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
}
/*
- (BOOL)checkWeChat
{
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (BOOL)checkSinaWeibo
{
    return [WeiboSDK isWeiboAppInstalled];
}
 */

@end
