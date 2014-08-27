//
//  AppBoard_iPhone.m
//  DZ
//
//  Created by Nonato on 14-3-31.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "PullLoader.h"
#import "FootLoader.h" 
//#import "AppClosed_iPhone.h" 
#import "B0_ForumPlates_iphone.h"
#import "C0_HairPost_iphone.h"
#import "D0_Mine_iphone.h"
#import "A0_BaseHomeViewController.h"
#import "A0_HomePage1_iphone.h"
#import "A2_PlatesSelectBoard_iphone.h"
#import "E0_AlbumBoard_iphone.h"

DEF_UI( AppBoard_iPhone, appBoard )

@interface AppBoard_iPhone ()
@property(nonatomic,assign)BOOL firsLoad;
@end

@implementation AppBoard_iPhone
{
	NSInteger	_selectedIndex;
    CGFloat _tabbarOriginY;

}
 
DEF_SINGLETON( AppBoard_iPhone )
//SUPPORT_AUTOMATIC_LAYOUT( YES );
//SUPPORT_RESOURCE_LOADING( YES );
 
DEF_SIGNAL( TAB_HOME)
DEF_SIGNAL( TAB_FORUM )
DEF_SIGNAL( TAB_SENDHTM)
DEF_SIGNAL( TAB_MINE)
DEF_SIGNAL( TAB_ALBUM)
DEF_SIGNAL( NOTIFY_FORWARD )
DEF_SIGNAL( NOTIFY_IGNORE )
@synthesize firstLogin = _firstLogin;
#pragma mark -
ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [UIApplication sharedApplication].statusBarHidden = NO;
        self.view.backgroundColor = [UIColor whiteColor];
		bee.ui.router[self.TAB_HOME]	= [A0_HomePage1_iphone class];
		bee.ui.router[self.TAB_FORUM]	= [B0_ForumPlates_iphone class];
		bee.ui.router[self.TAB_SENDHTM]	= [C0_HairPost_iphone class];
		bee.ui.router[self.TAB_MINE]	= [D0_Mine_iphone class];
        bee.ui.router[self.TAB_ALBUM]	= [E0_AlbumBoard_iphone class];
        
		[self.view addSubview:bee.ui.router.view];
        [self.view addSubview:bee.ui.tabbar];
		[bee.ui.router open:self.TAB_HOME animated:YES];
        CGRect rect = [UIScreen mainScreen].bounds;
        bee.ui.tabbar.frame = CGRectMake( 0, CGRectGetHeight(rect)-TAB_HEIGHT, 320, TAB_HEIGHT);
        bee.ui.router.view.frame = CGRectMake( 0, 0, self.viewBound.size.width, self.viewBound.size.height );
//         self.navigationBarShown = YES;
//        [self.tabbar selectHomepage];
        [self.view bringSubviewToFront:bee.ui.tabbar];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        if(!self.firsLoad)
		{
            float Y=self.bounds.size.height-TAB_HEIGHT;
//            CGRect frame=bee.ui.tabbar.frame;
            bee.ui.tabbar.frame = CGRectMake( 0, Y, 320, TAB_HEIGHT);
            bee.ui.router.view.frame = CGRectMake( 0, 0, self.viewBound.size.width, self.viewBound.size.height );
            self.firsLoad=YES;
        }
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        //		[self.configModel reload];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_WILL_CHANGE] )
    {
		
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_DID_CHANGED] )
    {
        
    }
}

#pragma mark - 切换选项卡
ON_SIGNAL3(AppBoardTab_iPhone, homepage, signal )
{
    [bee.ui.router open:AppBoard_iPhone.TAB_HOME animated:YES];
    BeeLog(@"------->");
 	[self transitionFade];
}

ON_SIGNAL3( AppBoardTab_iPhone, forum, signal )
{
    [bee.ui.router open:AppBoard_iPhone.TAB_FORUM  animated:YES];
}

ON_SIGNAL3( AppBoardTab_iPhone, sendhtm, signal )
{
// 	[bee.ui.tabbar selectSendhtm];
//    [bee.ui.router open:AppBoard_iPhone.TAB_SENDHTM animated:YES];
    [self showSendHtm];
// 	[self transitionFade];
}

ON_SIGNAL3(AppBoardTab_iPhone, album, signal)
{
    [bee.ui.router open:AppBoard_iPhone.TAB_ALBUM animated:YES];
    [self transitionFade];
}
ON_SIGNAL3(AppBoardTab_iPhone, mine, signal )
{
//  	[bee.ui.tabbar selectMine];
    [bee.ui.router open:AppBoard_iPhone.TAB_MINE animated:YES];
    [self transitionFade]; 
}

#pragma mark -

ON_NOTIFICATION3( BeeNetworkReachability, WIFI_REACHABLE, notification )
{
	[self presentMessageTips:__TEXT(@"network_wifi")];
}

ON_NOTIFICATION3( BeeNetworkReachability, WLAN_REACHABLE, notification )
{
	[self presentMessageTips:__TEXT(@"network_wlan")];
}

ON_NOTIFICATION3( BeeNetworkReachability, UNREACHABLE, notification )
{
	[self presentMessageTips:__TEXT(@"network_unreachable")];
}

#pragma mark -
//
//ON_NOTIFICATION3( ConfigModel, SHOP_CLOSED, notification )
//{
//	if ( bee.ui.closed.hidden )
//	{
//		[self.view bringSubviewToFront:bee.ui.closed];
//        
//		[self transitionFlip];
//		
//		bee.ui.closed.frame = self.view.bounds;
//		bee.ui.closed.hidden = NO;
//	}
//}
//
//ON_NOTIFICATION3( ConfigModel, SHOP_OPENED, notification )
//{
//	if ( NO == bee.ui.closed.hidden )
//	{
//		[self.view bringSubviewToFront:bee.ui.closed];
//		
//		[self transitionFlip];
//		
//		bee.ui.closed.frame = self.view.bounds;
//		bee.ui.closed.hidden = YES;
//	}
//}

#pragma mark -

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1437) {
        if (buttonIndex==1) {
            [self showLogin];
        }
    }
}

- (void)showSendHtm
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有登录，是否现在登录？" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"好的", nil];
        alertview.tag=1437;
        [alertview show];
        return;
    }
    if ( self.modalStack )
    {
		return;
    }
    C0_HairPost_iphone *board = [[C0_HairPost_iphone alloc] init];    
//    [self  presentViewController:board animated:YES completion:^{
//        
//    }];
	[self presentModalStack:[BeeUIStack stackWithFirstBoard:(BeeUIBoard *)board] animated:YES];
   
}
-(void)hideSendhtm
{
    if ( nil == self.modalStack )
	{
		return;
	}
	[self dismissModalStackAnimated:YES];
}


- (void)showTabbar
{
    if (!self.firsLoad) {
        return;
    }
	_tabbarOriginY = self.bounds.size.height - TAB_HEIGHT;
    CGRect tabbarFrame = bee.ui.tabbar.frame;    
    tabbarFrame.origin.y = _tabbarOriginY;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
//        [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    bee.ui.tabbar.frame = tabbarFrame;
    [UIView commitAnimations];
  
}

- (void)hideTabbar
{
	_tabbarOriginY = self.bounds.size.height+TAB_HEIGHT;
    CGRect tabbarFrame = bee.ui.tabbar.frame;
    tabbarFrame.origin.y = _tabbarOriginY;
    
    [UIView beginAnimations:nil context:NULL];
 	[UIView setAnimationDuration:0.2];
//    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    bee.ui.tabbar.frame = tabbarFrame;
	
    [UIView commitAnimations];

}

-(void)showForumPlatesSelect:(id)delegate
{
    if ( self.modalStack )
    {
		return;
    }
    A2_PlatesSelectBoard_iphone *board=[A2_PlatesSelectBoard_iphone board];
    board.delegate=delegate;
    if ([NSStringFromClass([delegate class]) isEqualToString:NSStringFromClass([A0_HomePage1_iphone class])]) {
        A0_HomePage1_iphone *home=(A0_HomePage1_iphone *)delegate;
        board.ModeleBlocks = home.ModeleBlocks;
    }
	[self presentModalStack:[BeeUIStack stackWithFirstBoard:board] animated:YES];
}

- (void)hideForumPlatesSelect:(id)delegate save:(BOOL)save
{
	if ( nil == self.modalStack )
	{
		return;
	} 
	[self dismissModalStackAnimated:YES];
}

- (void)showLogin
{
	if ( self.modalStack )
    {
		return;
    }
	[self presentModalStack:[BeeUIStack stackWithFirstBoard:[D1_LoginBoard_iphone board]] animated:YES];
    [self transitionCube];
}

- (void)hideLogin
{
	if ( nil == self.modalStack )
	{
		return;
	}
	[self dismissModalStackAnimated:YES];
    [self transitionCube:BeeUITransitionDirectionLeft];
}

@end
