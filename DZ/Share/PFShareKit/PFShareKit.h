//
//  PFShareKit.h
//  PFShareKit
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFShareAuthorizeView.h"
#import "PFShareConstants.h"
#import "PFShareRequest.h"

typedef NS_ENUM (NSInteger, PFShareTarget)
{
    PFShareTargetSinaWeibo = 0,
    PFShareTargetTencentWeibo = 1,
    PFShareTargetDouban = 2,
    PFShareTargetRenren = 3 
};

@protocol PFShareDelegate;                          //接入代理

@interface PFShareKit : NSObject <PFShareAuthorizeViewDelegate, PFShareRequestDelegate>
{
    PFShareTarget shareTarget;                      //分享的目标
    PFShareKit *shareInstance;                      //分享的实例
    
    NSString *userID;                               //用户ID
    NSString *accessToken;                          //访问令牌
    NSDate *expirationDate;                         //请求的期限
    //    id<PFShareDelegate> delegate;                  //申请代理
    
    NSString *appKey;
    NSString *appSecret;
    NSString *appRedirectURI;
    NSString *ssoCallbackSheme;                     //返回的App Url地址
    
    PFShareRequest *request;
    NSMutableSet *requestSet;
    BOOL ssoLoggingIn;                              //判断是否已经登录
}

@property (nonatomic, retain) NSString *userID;                     //用户ID
@property (nonatomic, retain) NSString *accessToken;                //访问口令
@property (nonatomic, retain) NSDate *expirationDate;               //认证过期时间
@property (nonatomic, retain) NSString *refreshToken;               //刷新令牌
@property (nonatomic, retain) NSString *ssoCallbackScheme;          //返回的App Url地址
@property (nonatomic, assign) id<PFShareDelegate> delegate;        //申请代理
@property (nonatomic) PFShareTarget shareTarget;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *appRedirectURI;

/**
 * @brief 设置分享的目标
 */
+ (id)shareInstanceWithTarget:(PFShareTarget)target;

/**
 * @brief 初始化构造函数，返回采用默认sso回调地址构造的PFShareKit对象
 * @param appKey: 分配给第三方应用的appkey
 * @param appSecrect: 分配给第三方应用的appsecrect
 * @param appRedirectURI: 微博开放平台中授权设置的应用回调页
 * @return PFShareKit对象
 */
- (id)initWithAppKey:(NSString *)appKey
           appSecret:(NSString *)appSecret
      appRedirectURI:(NSString *)appRedirectURI
         andDelegate:(id<PFShareDelegate>)delegate;

/**
 * @brief 初始化构造函数，返回采用默认sso回调地址构造的PFShareKit对象
 * @param appKey: 分配给第三方应用的appkey
 * @param appSecrect: 分配给第三方应用的appsecrect
 * @param ssoCallbackScheme: sso回调地址，此值应与URL Types中定义的保持一致。若为nil,则初始化为默认格式 PFShareSSO.your_app_key;
 * @param appRedirectURI: 微博开放平台中授权设置的应用回调页
 * @return PFShareKit对象
 */
- (id)initWithAppKey:(NSString *)appKey
           appSecret:(NSString *)appSecret
      appRedirectURI:(NSString *)appRedirectURI
   ssoCallbackScheme:(NSString *)ssoCallbackScheme
         andDelegate:(id<PFShareDelegate>)delegate;

/**
 * @brief 当应用从后台唤起时，应调用此方法，需要完成退出当前登录状态的功能
 */
- (void)applicationDidBecomeActive;

/**
 * @brief sso回调方法，官方客户端完成sso授权后，回调唤起应用，应用中应调用此方法完成sso登录
 * @param url: 官方客户端回调给应用时传回的参数，包含认证信息等
 * @return YES
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 * @brief 获取认证信息
 */
- (void)getAuthorizeData;

/**
 * @brief 清空认证信息
 */
- (void)removeAuthorizeData;

/**
 * @brief 登录入口，当初始化PFShareKit对象完成后直接调用此方法完成登录
 */
- (void)logIn;

/**
 * @brief 注销方法，需要退出时直接调用此方法
 */
- (void)logOut;

/**
 * @brief 判断是否登录
 * @return YES为已登录，NO为未登录
 */
- (BOOL)isLoggedIn;

/**
 * @brief 判断授权是否过期
 * @return YES为已过期，NO为未过期
 */
- (BOOL)isAuthorizeExpired;

/**
 * @brief 判断登录是否有效，当已登录并且登录未过期时为有效状态
 * @return YES为有效；NO为无效
 */
- (BOOL)isAuthorizeValid;

/**
 * @brief 微博API的请求接口，方法中自动完成token信息的拼接
 * @param url: 请求的接口
 * @param httpMethod: http类型，GET或POST
 * @param params: 请求的参数，如发微博所带的文字内容等
 * @param delegate: 处理请求结果的回调的对象，PFShareRequestDelegate类
 * @return 完成实际请求操作的PFShareRequest对象
 */
- (PFShareRequest *)requestWithURL:(NSString *)url
                        httpMethod:(NSString *)httpMethod
                            params:(NSMutableDictionary *)params
                          delegate:(id<PFShareRequestDelegate>)delegate;

@end

@protocol PFShareDelegate <NSObject>

@optional

/**
 * @brief 登录
 */
- (void)shareDidLogIn:(PFShareKit *)shareKit;

/**
 * @brief 注销
 */
- (void)shareDidLogOut:(PFShareKit *)shareKit;

/**
 * @brief 取消登录
 */
- (void)shareLogInDidCancel:(PFShareKit *)shareKit;

/**
 * @brief 即将发送请求
 */
- (void)shareWillBeginRequest:(PFShareRequest *)request;

/**
 * @brief 登录出错
 */
- (void)share:(PFShareKit *)shareKit logInDidFailWithError:(NSError *)error;

/**
 * @brief 认证无效或失效
 */
- (void)share:(PFShareKit *)shareKit accessTokenInvalidOrExpired:(NSError *)error;

@end

extern BOOL PFShareIsDeviceIPad();  //判断设备是否为iPad
