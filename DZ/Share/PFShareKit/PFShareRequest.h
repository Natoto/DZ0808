//
//  PFShareRequest.h
//  PFShareKit
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFShareKit;
@class PFShareRequest;

/**
 * @brief 第三方应用访问API时实现此协议，当SDK完成API的访问后通过传入的此类对象完成接口访问结果的回调，应用在协议实现的相应方法中接收访问结果并做对应处理。
 */
@protocol PFShareRequestDelegate <NSObject>

@optional

/**
 * @brief 获取请求的响应
 * @param response: 具体的响应对象
 */
- (void)request:(PFShareRequest *)request didReceiveResponse:(NSURLResponse *)response;

/**
 * @brief 请求完成
 * @param data: 返回结果
 */
- (void)request:(PFShareRequest *)request didFinishLoadingWithDataResult:(NSData *)data;

/**
 * @brief 请求完成
 * @param result: 返回结果
 */
- (void)request:(PFShareRequest *)request didFinishLoadingWithResult:(id)result;

/**
 * @brief 获取请求失败的响应
 * @param error: 错误信息
 */
- (void)request:(PFShareRequest *)request didFailWithError:(NSError *)error;

@end

@interface PFShareRequest : NSObject
{
    NSString            *url;               //请求的接口
    NSString            *httpMethod;        //http类型，GET或POST
    NSDictionary        *params;            //请求的参数，如发微博所带的文字内容等
    
    NSURLConnection     *connection;
    NSMutableData       *responseData;      //返回的数据
}

@property (nonatomic, assign) PFShareKit    *pfShare;
@property (nonatomic, retain) NSString      *url;           //请求的接口
@property (nonatomic, retain) NSString      *httpMethod;    //http类型，GET或POST
@property (nonatomic, retain) NSDictionary  *params;        //请求的参数，如发微博所带的文字内容等
@property (nonatomic, assign) id<PFShareRequestDelegate> delegate;

/**
 * @brief
 */
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

/**
 * @brief
 */
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

/**
 * @brief 微博API的请求接口，方法中自动完成token信息的拼接
 * @param url: 请求的接口
 * @param httpMethod: http类型，GET或POST
 * @param params: 请求的参数，如发微博所带的文字内容等
 * @param delegate: 处理请求结果的回调的对象，PFShareRequestDelegate类
 * @return 完成实际请求操作的PFShareRequest对象
 */
+ (PFShareRequest *)requestWithURL:(NSString *)url
                        httpMethod:(NSString *)httpMethod
                            params:(NSDictionary *)params
                          delegate:(id<PFShareRequestDelegate>)delegate;

/**
 * @brief 请求获取认证
 * @param url: 请求的接口
 * @param httpMethod: http类型，GET或POST
 * @param params: 请求的参数，如发微博所带的文字内容等
 * @param delegate: 处理请求结果的回调的对象，PFShareRequestDelegate类
 */
+ (PFShareRequest *)requestWithAccessToken:(NSString *)accessToken
                                       url:(NSString *)url
                                httpMethod:(NSString *)httpMethod
                                    params:(NSDictionary *)params
                                  delegate:(id<PFShareRequestDelegate>)delegate;

/**
 * @brief 连接网络
 */
- (void)connect;

/**
 * @brief 断开网络
 */
- (void)disconnect;

@end
