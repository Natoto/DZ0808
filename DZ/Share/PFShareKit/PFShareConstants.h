//
//  PFShareConstants.h
//  PFShareKit
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#ifndef PFShare_ios_sdk_SinaWeiboConstants_h
#define PFShare_ios_sdk_SinaWeiboConstants_h

#pragma mark - AppKey Management

//新浪微博
#define kSinaWeiboAppKey                    @"2330639301"
#define kSinaWeiboAppSecret                 @"b40da38bc76d70a2ffcd1f4f7a754390"
#define kSinaWeiboAppRedirectURI            @"http://weibo.com/u/3195606297"

//腾讯微博
#define kTencentWeiboAppKey                 @"801291903"
#define kTencentWeiboAppSecret              @"0cba6f47ac642efc970877d03b2b1891"
#define kTencentWeiboAppRedirectURI         @"https://itunes.apple.com/cn/app/zhong-guo-ying-lou/id541608192?mt=8"

//QQ空间
#define kQzoneAppKey                        @""
#define kQzoneAppSecret                     @""
#define kQzoneAppRedirectURI                @""

//朋友圈
#define kWeChatTimelineAppKey               @""
#define kWeChatTimelineAppSecret            @""
#define kWeChatTimelineAppRedirectURI       @""

//微信
#define kWeChatSessionAppKey                @""
#define kWeChatSessionAppSecret             @""
#define kWeChatSessionAppRedirectURI        @""

//QQ
#define kQQAppKey                           @""
#define kQQAppSecret                        @""
#define kQQAppRedirectURI                   @""

//豆瓣
#define kDoubanBroadAppKey                  @"0077a5c719af2a470166f1554d0d7ed5"
#define kDoubanBroadAppSecret               @"e624d4fab3356f0a"
#define kDoubanBroadAppRedirectURI          @"http://www.qq.com"

//人人
#define kRenrenBroadAPPID                   @"223954"
#define kRenrenBroadAppKey                  @"bdc9de15d9084d3c81bfbcac2bb56425"
#define kRenrenBroadAppSecret               @"adc75e9663a64df292fbe75369b8167e"
#define kRenrenBroadAppRedirectURI          @"http://widget.renren.com/callback.html"

#pragma mark - SDK Management

//新浪微博
#define SinaWeiboSdkVersion                 @"2.0"
#define kSinaWeiboSDKErrorDomain            @"SinaWeiboSDKErrorDomain"
#define kSinaWeiboSDKErrorCodeKey           @"SinaWeiboSDKErrorCodeKey"
#define kSinaWeiboSDKAPIDomain              @"https://open.weibo.cn/2/"
#define kSinaWeiboSDKOAuth2APIDomain        @"https://open.weibo.cn/2/oauth2/"
#define kSinaWeiboWebAuthURL                @"https://open.weibo.cn/2/oauth2/authorize"
#define kSinaWeiboWebAccessTokenURL         @"https://open.weibo.cn/2/oauth2/access_token"
#define kSinaWeiboAppAuthURL_iPhone         @"sinaweibosso://login"
#define kSinaWeiboAppAuthURL_iPad           @"sinaweibohdsso://login"

//腾讯微博
#define TencentWeiboSdkVersion              @"2.0"
#define kTencentWeiboSDKErrorDomain         @"TCSDKErrorDomain"
#define kTencentWeiboSDKErrorCodeKey        @"TCSDKErrorCodeKey"
#define kTencentWeiboSDKAPIDomain           @"https://open.t.qq.com/api/"
#define kTencentWeiboSDKOAuth2APIDomain     @"https://open.t.qq.com/cgi-bin/oauth2/"
#define kTencentWeiboWebAuthURL             @"https://open.t.qq.com/cgi-bin/oauth2/authorize/ios"
#define kTencentWeiboWebAccessTokenURL      @"https://open.t.qq.com/cgi-bin/oauth2/access_token"
#define kTencentWeiboAppAuthURL_iPhone      @"sinaweibosso://login"
#define kTencentWeiboAppAuthURL_iPad        @"sinaweibohdsso://login"

//QQ空间
#define kQzoneWebAuthURL                    @""

//朋友圈
//#define kSinaWeiboWebAuthURL                @"https://open.weibo.cn/2/oauth2/authorize"

//微信
//#define kSinaWeiboWebAuthURL                @"https://open.weibo.cn/2/oauth2/authorize"

//QQ
//#define kSinaWeiboWebAuthURL                @"https://open.weibo.cn/2/oauth2/authorize"

//豆瓣
#define DoubanBroadSdkVersion               @"2.0"
#define kDoubanBroadSDKErrorDomain          @"DoubanSDKErrorDomain"
#define kDoubanBroadSDKErrorCodeKey         @"DoubanSDKErrorCodeKey"
#define kDoubanBroadSDKAPIDomain            @"https://api.douban.com/"
#define kDoubanBroadSDKOAuth2APIDomain      @"https://www.douban.com/service/auth2/"
#define kDoubanBroadWebAuthURL              @"https://www.douban.com/service/auth2/auth"
#define kDoubanBroadWebAccessTokenURL       @"https://www.douban.com/service/auth2/token"
#define kDoubanBroadAppAuthURL_iPhone       @"sinaweibosso://login"
#define kDoubanBroadAppAuthURL_iPad         @"sinaweibohdsso://login"

//人人
#define RenrenBroadSdkVersion               @"3.0"
#define kRenrenBroadSDKErrorDomain          @"RenrenSDKErrorDomain"
#define kRenrenBroadSDKErrorCodeKey         @"RenrenSDKErrorCodeKey"
#define kRenrenBroadSDKAPIDomain            @"https://api.renren.com/"
#define kRenrenBroadSDKOAuth2APIDomain      @"http://graph.renren.com/oauth/"
#define kRenrenBroadWebAuthURL              @"http://graph.renren.com/oauth/authorize"
#define kRenrenBroadWebAccessTokenURL       @"https://graph.renren.com/oauth/token"
#define kRenrenBroadAppAuthURL_iPhone       @""
#define kRenrenBroadAppAuthURL_iPad         @""

//请求延时
#define kShareRequestTimeOutInterval 120.0f

typedef enum
{
    kSinaWeiboSDKErrorCodeParseError       = 200,
	kSinaWeiboSDKErrorCodeSSOParamsError   = 202,
} SinaWeiboSDKErrorCode;

#endif
