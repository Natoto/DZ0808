//
//  PFShareKit.m
//  PFShareKit
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFShareKit.h"

#import "PFShareConstants.h"

static PFShareKit *shareInstance;

@implementation PFShareKit

@synthesize userID;
@synthesize accessToken;
@synthesize expirationDate;
@synthesize refreshToken;
@synthesize ssoCallbackScheme;
@synthesize delegate;
@synthesize appKey;
@synthesize appSecret;
@synthesize appRedirectURI;
@synthesize shareTarget;

#pragma mark - Data Management Methods

+ (id)shareInstanceWithTarget:(PFShareTarget)target
{
    if (shareInstance == nil)
    {
        shareInstance = [[[self class] alloc] init];
    }
    
    shareInstance.shareTarget = target;
    
    [shareInstance getAuthorizeData];
    
    return shareInstance;
}

- (void)getAuthorizeData
{
    NSDictionary *PFShareAuthInfo;
    
    if(shareTarget == PFShareTargetSinaWeibo)
    {
        appKey = kSinaWeiboAppKey;
        appSecret = kSinaWeiboAppSecret;
        appRedirectURI = kSinaWeiboAppRedirectURI;
        PFShareAuthInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-SinaWeibo"];
    }
    else if(shareTarget == PFShareTargetTencentWeibo)
    {
        appKey = kTencentWeiboAppKey;
        appSecret = kTencentWeiboAppSecret;
        appRedirectURI = kTencentWeiboAppRedirectURI;
        PFShareAuthInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-TencentWeibo"];
    }
    else if(shareTarget == PFShareTargetDouban)
    {
        appKey = kDoubanBroadAppKey;
        appSecret = kDoubanBroadAppSecret;
        appRedirectURI = kDoubanBroadAppRedirectURI;
        PFShareAuthInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-Douban"];
    }
    else
    {//人人
        appKey = kRenrenBroadAppKey;
        appSecret = kRenrenBroadAppSecret;
        appRedirectURI = kRenrenBroadAppRedirectURI;
        PFShareAuthInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-Renren"];
    }
    
    if ([PFShareAuthInfo objectForKey:@"AccessTokenKey"] && [PFShareAuthInfo objectForKey:@"ExpirationDateKey"] && [PFShareAuthInfo objectForKey:@"UserIDKey"])
    {
        accessToken = [PFShareAuthInfo objectForKey:@"AccessTokenKey"];
        expirationDate = [PFShareAuthInfo objectForKey:@"ExpirationDateKey"];
        userID = [PFShareAuthInfo objectForKey:@"UserIDKey"];
    }
    else
    {
        accessToken = nil;
        expirationDate = nil;
        userID = nil;
    }
}

//网页分享
- (id)initWithAppKey:(NSString *)_appKey appSecret:(NSString *)_appSecret
      appRedirectURI:(NSString *)_appRedirectURI
         andDelegate:(id<PFShareDelegate>)_delegate
{
    return [self initWithAppKey:_appKey
                      appSecret:_appSecret
                 appRedirectURI:_appRedirectURI
              ssoCallbackScheme:nil
                    andDelegate:_delegate];
}

//SSO分享（打开相对应的应用）
- (id)initWithAppKey:(NSString *)_appKey appSecret:(NSString *)_appSecret
      appRedirectURI:(NSString *)_appRedirectURI
   ssoCallbackScheme:(NSString *)_ssoCallbackScheme
         andDelegate:(id<PFShareDelegate>)_delegate
{
    if ((self = [super init]))
    {
        self.appKey = _appKey;
        self.appSecret = _appSecret;
        self.appRedirectURI = _appRedirectURI;
        self.delegate = _delegate;
        
        if (!_ssoCallbackScheme) {
            _ssoCallbackScheme = [NSString stringWithFormat:@"PFShareSSO.%@://", self.appKey];
        }
        self.ssoCallbackScheme = _ssoCallbackScheme;
        
        requestSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)storeAuthorizeData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              accessToken, @"AccessTokenKey",
                              expirationDate, @"ExpirationDateKey",
                              userID, @"UserIDKey",
                              refreshToken, @"refresh_token", nil];
    
    if(shareTarget == PFShareTargetSinaWeibo) {
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-Sina"];
 
    }
    else if(shareTarget == PFShareTargetTencentWeibo) {
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-Tencent"];
 
    }
    else if(shareTarget == PFShareTargetDouban) {
 
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-Douban"];
    }
    else if(shareTarget == PFShareTargetRenren) {
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-Renren"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//移除认证数据
- (void)removeAuthorizeData
{
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSString *url;
    if(shareTarget == PFShareTargetSinaWeibo) {
        url = @"https://open.weibo.cn";
    }
    else if(shareTarget == PFShareTargetTencentWeibo) {
        url = @"https://open.t.qq.com";
    }
    else if(shareTarget == PFShareTargetDouban) {
        url = @"https://www.douban.com";
    } else {
        url = @"https://graph.renren.com";
    }
    
    NSArray* PFShareCookies = [cookies cookiesForURL:
                               [NSURL URLWithString:url]];
    
    for (NSHTTPCookie* cookie in PFShareCookies) {
        [cookies deleteCookie:cookie];
    }
}

#pragma mark - Private Methods

//请求认证口令和认证码
- (void)requestAccessTokenWithAuthorizationCode:(NSString *)code
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.appKey, @"client_id",
                            self.appSecret, @"client_secret",
                            @"authorization_code", @"grant_type",
                            self.appRedirectURI, @"redirect_uri",
                            code, @"code", nil];
    [request disconnect];
    
    NSString *AccessTokenURL;
    
    if(shareTarget == PFShareTargetSinaWeibo) {
        AccessTokenURL = kSinaWeiboWebAccessTokenURL;
    }
    else if(shareTarget == PFShareTargetTencentWeibo) {
        AccessTokenURL = kTencentWeiboWebAccessTokenURL;
    }
    else if(shareTarget == PFShareTargetDouban) {
        AccessTokenURL = kDoubanBroadWebAccessTokenURL;
    } else {
        AccessTokenURL = kRenrenBroadWebAccessTokenURL;
    }
    
    request = [PFShareRequest requestWithURL:AccessTokenURL
                                  httpMethod:@"POST"
                                      params:params
                                    delegate:self];
    [request connect];
}

//请求完成
- (void)requestDidFinish:(PFShareRequest *)_request
{
    [requestSet removeObject:_request];
    _request.pfShare = nil;
}

//请求失败（无效的口令）
- (void)requestDidFailWithInvalidToken:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(share:accessTokenInvalidOrExpired:)]) {
        [delegate share:self accessTokenInvalidOrExpired:error];
    }
}

- (void)notifyTokenExpired:(id<PFShareRequestDelegate>)_delegate
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Token expired", NSLocalizedDescriptionKey, nil];
    NSString *SDKErrorDomain;
    if(shareTarget == PFShareTargetSinaWeibo) {
        SDKErrorDomain = kSinaWeiboSDKErrorDomain;
    }
    else if(shareTarget == PFShareTargetTencentWeibo) {
        SDKErrorDomain = kTencentWeiboSDKErrorDomain;
    }
    else if(shareTarget == PFShareTargetDouban) {
        SDKErrorDomain = kDoubanBroadSDKErrorDomain;
    } else {
        SDKErrorDomain = kRenrenBroadSDKErrorDomain;
    }
    
    NSError *error = [NSError errorWithDomain:SDKErrorDomain
                                         code:21315
                                     userInfo:userInfo];
    
    if ([delegate respondsToSelector:@selector(share:accessTokenInvalidOrExpired:)])
    {
        [delegate share:self accessTokenInvalidOrExpired:error];
    }
    
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)])
	{
		[_delegate request:nil didFailWithError:error];
	}
}

- (void)logInDidCancel
{
    if ([delegate respondsToSelector:@selector(shareLogInDidCancel:)])
    {
        [delegate shareLogInDidCancel:self];
    }
}

- (void)logInDidFinishWithAuthInfo:(NSDictionary *)authInfo
{
    NSLog(@"auto:%@",authInfo);
    
    //新浪的比较特别，所以不在这个函数中获得access_token
    NSString *access_token = [authInfo objectForKey:@"access_token"];
    NSString *uid = [authInfo objectForKey:@"uid"];
    NSString *remind_in = [authInfo objectForKey:@"remind_in"];
    NSString *refresh_token = [authInfo objectForKey:@"refresh_token"];
 
    if(shareTarget == PFShareTargetTencentWeibo)
 
    {
        uid = [authInfo objectForKey:@"openid"];
        remind_in = [authInfo objectForKey:@"expires_in"];
    }
    
    else if(shareTarget == PFShareTargetDouban)
    {
        uid = [authInfo objectForKey:@"douban_user_id"];
        remind_in = [authInfo objectForKey:@"expires_in"];
    }
    
    else if(shareTarget == PFShareTargetRenren)
    {
        uid = [[authInfo objectForKey:@"user"] objectForKey:@"id"];
        remind_in = [authInfo objectForKey:@"expires_in"];
    }
    
    if (access_token && uid)
    {
        if (remind_in != nil)
        {
            int expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        
        self.accessToken = access_token;
        self.userID = uid;
        self.refreshToken = refresh_token;
        
        [self storeAuthorizeData];
        
        if ([delegate respondsToSelector:@selector(shareDidLogIn:)])
        {
            [delegate shareDidLogIn:self];
        }
    }
}

- (void)logInDidFailWithErrorInfo:(NSDictionary *)errorInfo
{
    NSString *error_code = [errorInfo objectForKey:@"error_code"];
    if ([error_code isEqualToString:@"21330"])
    {
        [self logInDidCancel];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(share:logInDidFailWithError:)])
        {
            NSString *error_description = [errorInfo objectForKey:@"error_description"];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      errorInfo, @"error",
                                      error_description, NSLocalizedDescriptionKey, nil];
            
            NSString *SDKErrorDomain;
 
            if(shareTarget == PFShareTargetSinaWeibo)
            {
                SDKErrorDomain = kSinaWeiboSDKErrorDomain;
            }
            else if(shareTarget == PFShareTargetTencentWeibo)
            {
                SDKErrorDomain = kTencentWeiboSDKErrorDomain;
            }
            else if(shareTarget == PFShareTargetDouban)
            {
                SDKErrorDomain = kDoubanBroadSDKErrorDomain;
            } else {
                SDKErrorDomain = kRenrenBroadSDKErrorDomain;
            }
            
            NSError *error = [NSError errorWithDomain:SDKErrorDomain
                                                 code:[error_code intValue]
                                             userInfo:userInfo];
            [delegate share:self logInDidFailWithError:error];
        }
        
    }
}

#pragma mark - Validation Managament Methods

- (BOOL)isLoggedIn
{
    return userID && accessToken && expirationDate;
}

- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:expirationDate] == NSOrderedDescending);
}

- (BOOL)isAuthorizeValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

#pragma mark - LogIn / LogOut Management Methods

- (void)logIn
{
    if ([self isAuthorizeValid])
    {
        if ([delegate respondsToSelector:@selector(shareDidLogIn:)]) {
            [delegate shareDidLogIn:self];
        }
    }
    else
    {
        ssoLoggingIn = NO;
        
        // open sina weibo app
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)] &&
            [device isMultitaskingSupported])
        {
            NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    self.appKey, @"client_id",
                                    self.appRedirectURI, @"redirect_uri",
                                    self.ssoCallbackScheme, @"callback_uri", nil];
            
            //先用iPad微博打开
            NSString *appAuthorizeBaseURL = kSinaWeiboAppAuthURL_iPad;
            if (PFShareIsDeviceIPad())
            {
                NSString *appAuthorizeURL = [PFShareRequest serializeURL:appAuthorizeBaseURL
                                                                  params:params
                                                              httpMethod:@"GET"];
                ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthorizeURL]];
            }
            
            //再用iPhone微博打开
            if (!ssoLoggingIn)
            {
                appAuthorizeBaseURL = kSinaWeiboAppAuthURL_iPhone;
                NSString *appAuthURL = [PFShareRequest serializeURL:appAuthorizeBaseURL
                                                             params:params
                                                         httpMethod:@"GET"];
                ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
            }
        }
        if (!ssoLoggingIn)
        {
            //打开认证界面
            NSDictionary *params = @{@"client_id": self.appKey,
                                     @"response_type": @"code",
                                     @"redirect_uri": self.appRedirectURI,
                                     @"display": @"mobile"};
            PFShareAuthorizeView *authorizeView = [[PFShareAuthorizeView alloc] initWithAuthParams:params delegate:self];
            [authorizeView show];
        }
    }
}

- (void)logOut
{
    [self removeAuthorizeData];
    
    if ([delegate respondsToSelector:@selector(shareDidLogOut:)]) {
        [delegate shareDidLogOut:self];
    }
}

#pragma mark - Send Request With Token

- (PFShareRequest *)requestWithURL:(NSString *)url
                        httpMethod:(NSString *)httpMethod
                            params:(NSMutableDictionary *)params
                          delegate:(id<PFShareRequestDelegate>)_delegate
{
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    if ([self isAuthorizeValid])
    {
        [params setValue:self.accessToken forKey:@"access_token"];
        
        NSString *SDKDomain;
        if(shareTarget == PFShareTargetSinaWeibo) {
            SDKDomain = kSinaWeiboSDKAPIDomain;
        }
        else if(shareTarget == PFShareTargetTencentWeibo) {
            SDKDomain = kTencentWeiboSDKAPIDomain;
        }
        else if(shareTarget == PFShareTargetDouban) {
            SDKDomain = kDoubanBroadSDKAPIDomain;
        } else {
            SDKDomain = kRenrenBroadSDKAPIDomain;
        }
        
        NSString *fullURL = [SDKDomain stringByAppendingString:url];
        
        PFShareRequest *_request = [PFShareRequest requestWithURL:fullURL
                                                       httpMethod:httpMethod
                                                           params:params
                                                         delegate:_delegate];
        _request.pfShare = self;
        [requestSet addObject:_request];
        if([self.delegate respondsToSelector:@selector(shareWillBeginRequest:)]) {
            [self.delegate shareWillBeginRequest:request];
        }
        [_request connect];
        return _request;
    }
    else
    {
        //notify token expired in next runloop
        [self performSelectorOnMainThread:@selector(notifyTokenExpired:)
                               withObject:_delegate
                            waitUntilDone:NO];
        return nil;
    }
}

#pragma mark - PFShareAuthorizeViewDelegate

- (void)authorizeView:(PFShareAuthorizeView *)authView didRecieveAuthorizationCode:(NSString *)code
{
    [self requestAccessTokenWithAuthorizationCode:code];
}

- (void)authorizeView:(PFShareAuthorizeView *)authView didFailWithErrorInfo:(NSDictionary *)errorInfo
{
    [self logInDidFailWithErrorInfo:errorInfo];
}

- (void)authorizeViewDidCancel:(PFShareAuthorizeView *)authView
{
    [self logInDidCancel];
}

#pragma mark - PFShareRequestDelegate

- (void)request:(PFShareRequest *)_request didFailWithError:(NSError *)error
{
    if (_request == request) {
        if ([delegate respondsToSelector:@selector(share:logInDidFailWithError:)]) {
            [delegate share:self logInDidFailWithError:error];
        }
    }
}

- (void)request:(PFShareRequest *)_request didFinishLoadingWithResult:(id)result
{
    if (_request == request) {
        [self logInDidFinishWithAuthInfo:result];
    }
}

#pragma mark - Application life cycle

- (void)applicationDidBecomeActive
{
    if (ssoLoggingIn)
    {
        // user open the app manually
        // clean sso login state
        ssoLoggingIn = NO;
        
        if ([delegate respondsToSelector:@selector(shareLogInDidCancel:)]) {
            [delegate shareLogInDidCancel:self];
        }
    }
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:self.ssoCallbackScheme])
    {
        if (!ssoLoggingIn)
        {
            // sso callback after user have manually opened the app
            // ignore the request
        }
        else
        {
            ssoLoggingIn = NO;
            
            if ([PFShareRequest getParamValueFromUrl:urlString paramName:@"sso_error_user_cancelled"]) {
                if ([delegate respondsToSelector:@selector(shareLogInDidCancel:)]) {
                    [delegate shareLogInDidCancel:self];
                }
            }
            else if ([PFShareRequest getParamValueFromUrl:urlString paramName:@"sso_error_invalid_params"])
            {
                if ([delegate respondsToSelector:@selector(share:logInDidFailWithError:)])
                {
                    NSString *error_description = @"Invalid sso params";
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              error_description, NSLocalizedDescriptionKey, nil];
                    NSString *SDKErrorDomain;
                    if(shareTarget == PFShareTargetSinaWeibo) {
                        SDKErrorDomain = kSinaWeiboSDKErrorDomain;
                    }
                    else if(shareTarget == PFShareTargetTencentWeibo) {
                        SDKErrorDomain = kTencentWeiboSDKErrorDomain;
                    }
                    else if(shareTarget == PFShareTargetDouban) {
                        SDKErrorDomain = kDoubanBroadSDKErrorDomain;
                    } else {
                        SDKErrorDomain = kRenrenBroadSDKErrorDomain;
                    }
                    
                    NSError *error = [NSError errorWithDomain:SDKErrorDomain
                                                         code:kSinaWeiboSDKErrorCodeSSOParamsError
                                                     userInfo:userInfo];
                    [delegate share:self logInDidFailWithError:error];
                }
            }
            else if ([PFShareRequest getParamValueFromUrl:urlString paramName:@"error_code"])
            {
                NSString *error_code = [PFShareRequest getParamValueFromUrl:urlString paramName:@"error_code"];
                NSString *error = [PFShareRequest getParamValueFromUrl:urlString paramName:@"error"];
                NSString *error_uri = [PFShareRequest getParamValueFromUrl:urlString paramName:@"error_uri"];
                NSString *error_description = [PFShareRequest getParamValueFromUrl:urlString paramName:@"error_description"];
                
                NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           error, @"error",
                                           error_uri, @"error_uri",
                                           error_code, @"error_code",
                                           error_description, @"error_description", nil];
                
                [self logInDidFailWithErrorInfo:errorInfo];
            }
            else
            {
                NSString *access_token = [PFShareRequest getParamValueFromUrl:urlString paramName:@"access_token"];
                NSString *expires_in = [PFShareRequest getParamValueFromUrl:urlString paramName:@"expires_in"];
                NSString *remind_in = [PFShareRequest getParamValueFromUrl:urlString paramName:@"remind_in"];
                NSString *uid = [PFShareRequest getParamValueFromUrl:urlString paramName:@"uid"];
                NSString *refresh_token = [PFShareRequest getParamValueFromUrl:urlString paramName:@"refresh_token"];
                
                NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
                if (access_token) [authInfo setObject:access_token forKey:@"access_token"];
                if (expires_in) [authInfo setObject:expires_in forKey:@"expires_in"];
                if (remind_in) [authInfo setObject:remind_in forKey:@"remind_in"];
                if (refresh_token) [authInfo setObject:refresh_token forKey:@"refresh_token"];
                if (uid) [authInfo setObject:uid forKey:@"uid"];
                
                [self logInDidFinishWithAuthInfo:authInfo];
            }
        }
    }
    return YES;
}

@end

//判断设备是否为iPad
BOOL PFShareIsDeviceIPad()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}
