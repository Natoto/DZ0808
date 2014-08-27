//
//  PFShareRequest.m
//  PFShareKit
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFShareRequest.h"
#import "PFShareConstants.h"
#import "PFShareKit.h"

#define kSinaWeiboRequestTimeOutInterval   120.0
#define kSinaWeiboRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

@interface NSString (SinaWeiboEncode)

- (NSString *)URLEncodedString;

@end

@implementation NSString (SinaWeiboEncode)

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
}

- (NSString *)URLEncodedString
{
	return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

@end

@interface PFShareKit (PFShareRequest)

//请求成功
- (void)requestDidFinish:(PFShareRequest *)request;

//请求失败（使用无效的认证）
- (void)requestDidFailWithInvalidToken:(NSError *)error;

@end

@interface PFShareRequest (Private)

//添加UTF8的字符串
- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString;

//发送请求的原始参数
- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData;

//处理返回的数据
- (void)handleResponseData:(NSData *)data;

//解析JSON数据
- (id)parseJSONData:(NSData *)data error:(NSError **)error;

//错误代码
- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

//请求失败的错误原因
- (void)failedWithError:(NSError *)error;

@end

@implementation PFShareRequest

@synthesize pfShare;
@synthesize url;
@synthesize httpMethod;
@synthesize params;
@synthesize delegate;

#pragma mark - Private Methods

//解码
- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData
{
    NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kSinaWeiboRequestStringBoundary];
    NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kSinaWeiboRequestStringBoundary];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    NSMutableData *body = [NSMutableData data];
    [self appendUTF8Body:body dataString:bodyPrefixString];
    
    for (id key in [params keyEnumerator])
    {
        if (([[params valueForKey:key] isKindOfClass:[UIImage class]]) || ([[params valueForKey:key] isKindOfClass:[NSData class]])) {
            [dataDictionary setObject:[params valueForKey:key] forKey:key];
            continue;
        }
        
        [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, [params valueForKey:key]]];
        [self appendUTF8Body:body dataString:bodyPrefixString];
    }
    
    if ([dataDictionary count] > 0)
    {
        *hasRawData = YES;
        for (id key in dataDictionary) {
            NSObject *dataParam = [dataDictionary valueForKey:key];
            
            if([key isEqual:@"upload"])
            {
                NSData* imageData;
                if ([dataParam isKindOfClass:[UIImage class]])
                {
                    imageData = UIImagePNGRepresentation((UIImage *)dataParam);
                }
                else if ([dataParam isKindOfClass:[NSData class]])
                {
                    imageData = (NSData *)dataParam;
                }
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\";filename=no.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kSinaWeiboRequestStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type:\"image/jpeg\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kSinaWeiboRequestStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                if ([dataParam isKindOfClass:[UIImage class]])
                {
                    NSData* imageData = UIImagePNGRepresentation((UIImage *)dataParam);
                    [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\n", key,dataParam]];
                    [self appendUTF8Body:body dataString:@"Content-Type:\"image/jpeg\"\r\n\r\n"];
                    [body appendData:imageData];
                }
                else if ([dataParam isKindOfClass:[NSData class]])
                {
                    [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file\"\r\n", key]];
                    [self appendUTF8Body:body dataString:@"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
                    [body appendData:(NSData*)dataParam];
                }
            }
            [self appendUTF8Body:body dataString:bodySuffixString];
        }
    }
    return body;
}

//管理接收的数据
- (void)handleResponseData:(NSData *)data
{
    if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithDataResult:)]) {
        [delegate request:self didFinishLoadingWithDataResult:data];
    }
	
	NSError *error = nil;
	id result = [self parseJSONData:data error:&error];
    
    NSString *tmpStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 
    if(result == nil && [tmpStr hasPrefix:@"access_token="] && [(PFShareKit *)delegate shareTarget] == PFShareTargetTencentWeibo)
    {
        result = [NSMutableDictionary dictionary];
        for(NSString *tmpString in [tmpStr componentsSeparatedByString:@"&"])
        {
            [result setValue:[[tmpString componentsSeparatedByString:@"="] lastObject]
                      forKey:[[tmpString componentsSeparatedByString:@"="] objectAtIndex:0]];
        }
    }
    
	if (!result)
	{
		[self failedWithError:error];
	}
	else
	{
        NSInteger error_code = 0;
        if([result isMemberOfClass:[NSDictionary class]])
        {
            [[result objectForKey:@"error_code"] intValue];
        }
        
        if (error_code != 0)
        {
            NSString *error_description = [result objectForKey:@"error"];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      result, @"error",
                                      error_description, NSLocalizedDescriptionKey, nil];
            NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain
                                                 code:[[result objectForKey:@"error_code"] intValue]
                                             userInfo:userInfo];
            
            if (error_code == 21314     //access_token已经被使用
                || error_code == 21315  //access_token已经过期
                || error_code == 21316  //access_token不合法
                || error_code == 21317  //access_token不合法
                || error_code == 21327  //access_token过期
                || error_code == 21332) //access_token无效
            {
                [pfShare requestDidFailWithInvalidToken:error];
            }
            else
            {
                [self failedWithError:error];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
            {
                [delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
            }
        }
	}
}

//解析JSON数据
- (id)parseJSONData:(NSData *)data error:(NSError **)error
{
    NSError *parseError = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
	
	if (parseError && (error != nil))
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  parseError, @"error",
                                  @"Data parse error", NSLocalizedDescriptionKey, nil];
        *error = [self errorWithCode:kSinaWeiboSDKErrorCodeParseError
                            userInfo:userInfo];
	}
	return result;
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:kSinaWeiboSDKErrorDomain code:code userInfo:userInfo];
}

- (void)failedWithError:(NSError *)error
{
	if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) {
		[delegate request:self didFailWithError:error];
	}
}

#pragma mark - Public Methods

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]]) || ([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            if ([httpMethod isEqualToString:@"GET"]) {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */(CFStringRef)[params objectForKey:key], NULL, /* charactersToLeaveUnescaped */(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (PFShareRequest *)requestWithURL:(NSString *)url
                        httpMethod:(NSString *)httpMethod
                            params:(NSDictionary *)params
                          delegate:(id<PFShareRequestDelegate>)delegate
{
    PFShareRequest *request = [[PFShareRequest alloc] init];
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.delegate = delegate;
    
    return request;
}

+ (PFShareRequest *)requestWithAccessToken:(NSString *)accessToken
                                       url:(NSString *)url
                                httpMethod:(NSString *)httpMethod
                                    params:(NSDictionary *)params
                                  delegate:(id<PFShareRequestDelegate>)delegate
{
    // add the access token field
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableParams setObject:accessToken forKey:@"access_token"];
    return [PFShareRequest requestWithURL:url
                               httpMethod:httpMethod
                                   params:mutableParams
                                 delegate:delegate];
}

- (void)connect
{
    NSString* urlString = [[self class] serializeURL:url params:params httpMethod:httpMethod];
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:kShareRequestTimeOutInterval];
    NSLog(@"%@",urlString);
    
    [request setHTTPMethod:self.httpMethod];
    if ([self.httpMethod isEqualToString: @"POST"])
    {
        BOOL hasRawData = NO;
        [request setHTTPBody:[self postBodyHasRawData:&hasRawData]];
        
        if (hasRawData)
        {
            NSString* contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", kSinaWeiboRequestStringBoundary];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        }
    }
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)disconnect
{
    [connection cancel];
}

#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	[self failedWithError:error];
	
    [connection cancel];
    
    [pfShare requestDidFinish:self];
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
	
	if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
		[delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
	[self handleResponseData:responseData];
    
    [connection cancel];
    
    [pfShare requestDidFinish:self];
}

@end
