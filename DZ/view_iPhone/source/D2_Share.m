//
//  D2_Share.m
//  DZ
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_Share.h"
#import "AppBoard_iPhone.h"
#import "AppDelegate.h"
#import "Bee_UIImageView.h"
#import "postlist.h"
#import "SettingModel.h"
#import "rmbdz.h"
#import "DZ_SystemSetting.h"

//#define kShareString @"小伙伴们，我刚刚下载安装了APP%@，非常好玩哦。下载地址:\n"
#define kShareString [NSString stringWithFormat:@"小伙伴们，我刚刚下载安装了APP%@，非常好玩哦。下载地址:\n%@", [DZ_SystemSetting sharedInstance].appname, [DZ_SystemSetting sharedInstance].downloadurl]
//#define AppName @"AppName"
//#define AppUrl @"AppUrl"

//#define WiressSDKDemoAppKey     @"801213517"
//#define WiressSDKDemoAppSecret  @"9819935c0ad171df934d0ffb340a3c2d"
//#define REDIRECTURI             @"http://www.ying7wang7.com"

@interface D2_Share ()
{
    enum WXScene scene;
    FONTSIZE_TYPE *fontSize;
}

@end

@implementation D2_Share

DEF_SINGLETON(shareImage)

@synthesize title = title_;
@synthesize msg = _msg;
@synthesize tid = _tid;
//@synthesize wbapi;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"%@", self.title);

    //解析html
//    for (int index = 0; i < self.content.count; index++) {
//        self.acontent = [self.content objectAtIndex:index];
//        if (self.acontent.type.integerValue == 0) {
//            self.acontent.msg = [self.acontent.msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            NSString *message = [NSString stringWithFormat:@"<font size=\"%d\">%@</font>", fontSize, self.acontent.msg];
//        }
//    }

//    if (self.wbapi == nil)
//    {
//        self.wbapi = [[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUri:REDIRECTURI andAuthModeFlag:0 andCachePolicy:0] ;
//    }

    [self setNavigationBarTitle:@"分享应用"];
    self.view.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1];

    CGSize size = CGSizeMake(300, 100);
    CGSize labelSize = [kShareString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, bee.ui.config.baseInsets.top + 10, 300, labelSize.height)];
    if (self.hasTid) title.text = self.title;
    else title.text = kShareString;
//    title.text = [NSString stringWithFormat:@"小伙伴们，我刚刚下载安装了APP%@，非常好玩哦。下载地址:\n%@", [DZ_SystemSetting sharedInstance].appname, [DZ_SystemSetting sharedInstance].downloadurl];
    title.backgroundColor = [UIColor whiteColor];
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = 0;
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:15];
    title.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    title.layer.borderWidth = 0.5;
    title.layer.cornerRadius = 5.0f;
    [title.layer setMasksToBounds:YES];
    [self.view addSubview:title];

    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame) + 20, 300, 240)];
    buttonView.backgroundColor = [UIColor whiteColor];
    buttonView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    buttonView.layer.borderWidth = 0.5;
    buttonView.layer.cornerRadius = 5.0f;
    [buttonView.layer setMasksToBounds:YES];
    [self.view addSubview:buttonView];

    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    buttonLabel.text = __TEXT(@"share_to");
    buttonLabel.backgroundColor = [UIColor whiteColor];
//    buttonLabel.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
//    buttonLabel.layer.borderWidth = 1.0;
//    buttonLabel.layer.cornerRadius = 5.0f;
//    [buttonLabel.layer setMasksToBounds:YES];
//    [buttonLabel sizeToFit];
    [buttonView addSubview:buttonLabel];

    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, buttonView.frame.size.width - 20, 0.5)];
    line.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/fengexian02@2x" ofType:@"png"]];
    [buttonView addSubview:line];

//    NSArray *sum = [[NSArray alloc] initWithObjects:@"微信会话", @"朋友圈", @"腾讯微博", @"新浪微博", @"QQ空间", @"人人", nil];
    NSArray *sum = @[@"微信会话", @"朋友圈", /*@"腾讯微博",*/ @"新浪微博"/*, @"QQ空间", @"人人"*/];

    /*
    NSMutableArray *sum = [[NSMutableArray alloc] initWithCapacity:6];
    if ([AppDelegate checkWeChat]) {
        [sum addObject:@"微信好友"];
        [sum addObject:@"朋友圈"];
    }
    if ([AppDelegate checkSinaWeibo]) {
        [sum addObject:@"新浪微博"];
    }
     */

    for (int i = 0; i < sum.count; i++) {
//        UIImage *shareImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:sum[i] ofType:@"png"]];
        UIImage *shareImage = [UIImage bundleImageNamed:sum[i]];
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:shareImage forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
        shareButton.tag = i;
        if (i < 3)
            shareButton.frame = CGRectMake(42.5 + 82.5 * i, 80, 50, 50);
        else
            shareButton.frame = CGRectMake(42.5 + 82.5 * (i - 3), 160, 50, 50);
        [buttonView addSubview:shareButton];
    }

    BeeUIImageView *img = [[BeeUIImageView alloc] init];
    [img GET:[D2_Share sharedInstance].image useCache:YES];
    self.imageData = UIImagePNGRepresentation(img.image);
}

#pragma mark - BeeFramework Constants

#pragma mark - Event

- (void)shareButton:(UIButton *)button
{
    switch (button.tag)
    {
        case 0:
            scene = WXSceneSession;
            [self shareToWeChat];
            break;
        case 1:
            scene = WXSceneTimeline;
            [self shareToWeChat];
            break;

        case 2:
//            [self shareToTencentWeibo];
            [self shareToSinaWeibo];
            break;
        /*
        case 3:
//            share = [PFShareKit shareInstanceWithTarget:PFShareTargetSinaWeibo];
//            [share logIn];
            [self shareToSinaWeibo];
            break;
        case 4:
            share = [PFShareKit shareInstanceWithTarget:PFShareTargetTencentWeibo];
            [share logIn];
            break;
        case 5:
            share = [PFShareKit shareInstanceWithTarget:PFShareTargetRenren];
            [share logIn];
            break;
         */
        default:
            break;
    }
}

- (void)shareToWeChat
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];


        if (self.title)
        {
            WXMediaMessage *message = [WXMediaMessage message];
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = [NSString stringWithFormat:@"%@?mod=viewthread&tid=%@", [DZ_SystemSetting  sharedInstance].forumurl, self.tid];

//            WXImageObject *ext = [WXImageObject object];
////            ext.imageData = UIImagePNGRepresentation(self.image);
//            ext.imageData = self.imageData;
//
            message.mediaObject = ext;
            message.title = self.title;
//            message.description = self.description;

            req.bText = NO;
            
            req.text = [NSString stringWithFormat:@"【%@】", self.title];
            req.message = message;
            req.scene = scene;
        }
        else
        {
            req.bText = YES;
//            req.text = [NSString stringWithFormat:@"小伙伴们，我刚刚下载安装了APP%@，非常好玩哦。下载地址:\n%@", [DZ_SystemSetting sharedInstance].appname, [DZ_SystemSetting sharedInstance].downloadurl];
            req.text = kShareString;
            req.scene = scene;
        }

//        if (self.title)
//            req.text = [NSString stringWithFormat:@"【%@】%@?action=postlist&tid=%@", self.title, [ServerConfig sharedInstance].url, self.tid];

        [WXApi sendReq:req];
    }
    else
    {
        [self presentMessageTips:@"您没有安装微信客户端"];
    }
}

//- (void)shareToTencentWeibo
//{
//    wbapi = [[WeiboApi alloc] init];
//    [wbapi checkAuthValid:TCWBAuthCheckServer andDelegete:self];
//}

//- (void)didCheckAuthValid:(BOOL)bResult suggest:(NSString *)strSuggestion、
//{
//    if (bResult == 1) {
//        UIImage *pic = [UIImage imageWithData:self.imageData];
//        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
//                                       [NSString stringWithFormat:@"【%@】http://114.215.178.111/amanmanceshi/forum.php?mod=viewthread&tid=%@", self.title, self.tid], @"content",
//                                       pic, @"pic",
//                                       nil];
//        [wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
//    }
//    else
//    {
//        [wbapi loginWithDelegate:self andRootController:self];
//    }
//}

/*
- (void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    [self presentMessageTips:@"授权成功"];
}*/

- (void)shareToSinaWeibo
{
    if ([WeiboSDK isWeiboAppInstalled])
    {
        WBMessageObject *message = [WBMessageObject message];

        if (self.title)
        {
            if (self.imageData)
            {
                WBImageObject *image = [WBImageObject object];
                image.imageData = self.imageData;
                message.imageObject = image;
            }
            message.text = [NSString stringWithFormat:@"【%@】http://114.215.178.111/amanmanceshi/forum.php?mod=viewthread&tid=%@", self.title, self.tid];
        }
        else {
            message.text = kShareString;
//            message.text = [NSString stringWithFormat:@"小伙伴们，我刚刚下载安装了APP%@，非常好玩哦。下载地址:\n%@", [DZ_SystemSetting sharedInstance].appname, [DZ_SystemSetting sharedInstance].downloadurl];
        }

        [WeiboSDK sendRequest:[WBSendMessageToWeiboRequest requestWithMessage:message]];
    }
    else
    {
        [self presentMessageTips:@"您没有安装新浪微博客户端"];
    }
}

/*
#pragma mark - PFShareKit Methods

- (void)removeAuthorizeData
{
    if(share.shareTarget == PFShareTargetSinaWeibo) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-Sina"];
    }
    else if(share.shareTarget == PFShareTargetTencentWeibo) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-Tencent"];
    }
    else if(share.shareTarget == PFShareTargetDouban) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-Douban"];
    }
    else if(share.shareTarget == PFShareTargetRenren) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-Renren"];
    }
}

#pragma mark - PFShareDelegate Methods

- (void)shareDidLogIn:(PFShareKit *)shareKit
{
    if(shareKit.shareTarget == PFShareTargetSinaWeibo)
    {
        [shareKit requestWithURL:@"statuses/upload.json"
                      httpMethod:@"POST"
                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringWithFormat:share_string, AppName, AppUrl], @"status",
                                  [UIImage bundleImageNamed:@"Default.png"], @"pic", nil]
                        delegate:self];
    }
    else if(shareKit.shareTarget == PFShareTargetTencentWeibo)
    {
        [shareKit requestWithURL:@"t/add_pic"
                      httpMethod:@"POST"
                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"这是我分享的图片", @"content",
                                  @"json",@"format",
                                  @"221.232.172.30",@"clientip",
                                  @"all",@"scope",
                                  shareKit.userID,@"openid",
                                  @"ios-sdk-2.0-publish",@"appfrom",
                                  @"0",@"compatibleflag",
                                  @"2.a",@"oauth_version",
                                  kTencentWeiboAppKey,@"oauth_consumer_key",
                                  [UIImage bundleImageNamed:@"Default.png"], @"pic", nil]
                        delegate:self];
    }
    //    else if (shareKit.shareTarget == PFShareTargetQzoneBlog) {
    //        shareKit requestWithURL:<#(NSString *)#> httpMethod:<#(NSString *)#> params:<#(NSMutableDictionary *)#> delegate:<#(id<PFShareRequestDelegate>)#>
    //    }
    //    else if (shareKit.shareTarget == PFShareTargetWeChatTimelineBlog) {

    //    }
    //    else if (shareKit.shareTarget == PFShareTargetWeChatSessionBlog) {

    //    }
    //    else if(shareKit.shareTarget == PFShareTargetDouban)
    //    {
    //        [shareKit requestWithURL:@"shuo/v2/statuses/"
    //                      httpMethod:@"POST"
    //                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                  @"这是我分享的图片", @"text",
    //                                  kDoubanBroadAppKey,@"source",
    //                                  [UIImage bundleImageNamed:@"Default.png"], @"image", nil]
    //                        delegate:self];
    //    }
    else if(shareKit.shareTarget == PFShareTargetRenren)
    {
        [shareKit requestWithURL:@"restserver.do"
                      httpMethod:@"POST"
                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"1.0", @"v",
                                  @"这是我分享的图片", @"caption",
                                  @"json", @"format",
                                  @"photos.upload", @"method",
                                  [UIImage bundleImageNamed:@"Default.png"], @"upload",
                                  kRenrenBroadAppKey,@"api_key",
                                  nil]
                        delegate:self];
    }
}

- (void)shareDidLogOut:(PFShareKit *)shareKit
{
    [self removeAuthorizeData];
}

- (void)shareLogInDidCancel:(PFShareKit *)shareKit
{
    NSLog(@"用户取消了登录");
}

- (void)share:(PFShareKit *)shareKit logInDidFailWithError:(NSError *)error
{
    NSLog(@"登录失败");
}

- (void)share:(PFShareKit *)shareKit accessTokenInvalidOrExpired:(NSError *)error
{
    [self removeAuthorizeData];
}

- (void)shareWillBeginRequest:(PFShareRequest *)request
{
    NSLog(@"开始请求");
}

-(void)request:(PFShareRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        NSLog(@"发表微博失败");
        NSLog(@"Post image status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        NSLog(@"发表微博失败");
        NSLog(@"Post image status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        //发表人人网相片回调
        NSLog(@"发表人人网相片失败");
        NSLog(@"Post image status failed with error : %@", error);
    }
}

- (void)request:(PFShareRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        //新浪微博响应
        if([[result objectForKey:@"error_code"] intValue]==20019) {
            NSLog(@"发送频率过高，请您过会再发");
        }
        else if([[result objectForKey:@"error_code"] intValue]==0) {
            NSLog(@"发送微博成功");
        }
    }
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        //腾讯微博响应
        if([[result objectForKey:@"errcode"] intValue]==0) {
            NSLog(@"发表微博成功");
        } else {
            NSLog(@"发表微博失败");
        }
    }
    else if ([request.url hasSuffix:@"shuo/v2/statuses/"])
    {
        //豆瓣说响应
        if([[result objectForKey:@"code"] intValue]==0) {
            NSLog(@"发表豆瓣说成功");
        } else {
            NSLog(@"%@",result);
            NSLog(@"发表豆瓣说失败");
        }
    }
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        //发表人人网相片回调
        if([[result objectForKey:@"error_code"] intValue]==0) {
            NSLog(@"发表人人网相片成功");
        } else {
            NSLog(@"发表人人网相片失败");
        }
    }
}
 */

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.imageData = nil;
    self.title = nil;
    self.tid = nil;
    [D2_Share sharedInstance].image = nil;
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
