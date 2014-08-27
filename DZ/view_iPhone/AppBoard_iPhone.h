//
//  AppBoard_iPhone.h
//  DZ
//
//  Created by Nonato on 14-3-31.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_UIBoard.h"
#import "Bee.h"
#import "AppBoardTab_iPhone.h" 

AS_UI( AppBoard_iPhone, appBoard )
@interface AppBoard_iPhone : BeeUIBoard<UIAlertViewDelegate>
AS_SINGLETON( AppBoard_iPhone ) 
//AS_OUTLET( AppBoardTab_iPhone,	tabbar);

/**
 * 底部菜单-首页，点击时会触发该事件
 */
 AS_SIGNAL(TAB_HOME)
          
/**
 * 底部菜单-论坛，点击时会触发该事件
 */
AS_SIGNAL( TAB_FORUM )
          
/**
 * 底部菜单-发帖，点击时会触发该事件
 */
 AS_SIGNAL( TAB_SENDHTM)

/**
 * 底部菜单-图片墙，点击时会触发该事件
 */
AS_SIGNAL( TAB_ALBUM)

/**
 * 底部菜单-个人中心，点击时会触发该事件
 */
AS_SIGNAL( TAB_MINE)


/**
 * 通知消息 - 前往
 */
 AS_SIGNAL( NOTIFY_FORWARD )
          
/**
 * 通知消息 - 忽略
 */
AS_SIGNAL( NOTIFY_IGNORE )

@property(nonatomic,assign) BOOL firstLogin;
//首次登陆

- (void)showSendHtm;
-(void)hideSendhtm;


- (void)showTabbar;
- (void)hideTabbar;

- (void)showLogin;
- (void)hideLogin;

-(void)showForumPlatesSelect:(id)delegate;
- (void)hideForumPlatesSelect:(id)delegate save:(BOOL)save;
@end
