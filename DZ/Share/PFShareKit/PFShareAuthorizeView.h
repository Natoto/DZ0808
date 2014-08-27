//
//  PFShareAuthorizeView.h
//  PFShareKit
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFShareAuthorizeViewDelegate;

@interface PFShareAuthorizeView : UIView <UIWebViewDelegate>
{
    UIWebView *webView;
    UIButton *closeButton;
    UIView *modalView;
    UIActivityIndicatorView *indicatorView;
    UIInterfaceOrientation previousOrientation;
    
    NSString *appRedirectURI;
    NSDictionary *authParams;
}

@property (nonatomic, assign) id<PFShareAuthorizeViewDelegate> delegate;

- (id)initWithAuthParams:(NSDictionary *)params
                delegate:(id<PFShareAuthorizeViewDelegate>) delegate;

/**
 * @brief 显示
 */
- (void)show;

/**
 * @brief 隐藏
 */
- (void)hide;

@end

@protocol PFShareAuthorizeViewDelegate <NSObject>

/**
 * @brief
 */
- (void)authorizeView:(PFShareAuthorizeView *)authView didRecieveAuthorizationCode:(NSString *)code;

/**
 * @brief
 */
- (void)authorizeView:(PFShareAuthorizeView *)authView didFailWithErrorInfo:(NSDictionary *)errorInfo;

/**
 * @brief 取消显示
 */
- (void)authorizeViewDidCancel:(PFShareAuthorizeView *)authorizeView;

@end
