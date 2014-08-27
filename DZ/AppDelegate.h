//
//  AppDelegate.h
//  DZ
//
//  Created by Nonato on 14-3-31.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "bee.h"
//#import "WeiboApi.h"

@interface AppDelegate :  BeeUIApplication <WXApiDelegate,WeiboSDKDelegate>

//@property  (nonatomic , retain) WeiboApi *wbapi;

/*
- (BOOL)checkWeChat;

- (BOOL)checkSinaWeibo;
 */

@end
