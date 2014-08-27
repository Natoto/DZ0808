//
//  D2_Share.h
//  DZ
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "PFShareKit.h"
#import "WXApi.h"
#import "PostlistModel.h"
#import "BeeUIBoard+ViewController.h"
//#import "WeiboApi.h"

@interface D2_Share :UIViewController <UIApplicationDelegate, ASIHTTPRequestDelegate/*, WeiboRequestDelegate, WeiboAuthDelegate*/>
{
    UIButton *shareButton;
}

AS_SINGLETON(shareImage)

@property (nonatomic, copy)     NSString                *title;
@property (nonatomic, copy)     NSString                *msg;
@property (nonatomic, copy)     NSString                *image;
@property (nonatomic, strong)   NSData                  *imageData;
@property (nonatomic, strong)   PostlistModel           *postlistModel;
@property (nonatomic, copy)     NSString                *tid;
@property (nonatomic, assign)   BOOL                     hasTid;

@end
