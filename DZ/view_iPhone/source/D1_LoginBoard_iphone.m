//
//  D1_LoginBoard.m
//  DZ
//
//  Created by Nonato on 14-4-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_LoginBoard_iphone.h"
#import "AppBoard_iPhone.h"
#import "D2_RegistViewController_iphone.h"
#import "DZ_SystemSetting.h"
#import "homeModel.h"

#define MARGIN_LEFT 20
@interface D1_LoginBoard_iphone ()
{
    UIView * inputview;
    BOOL    REMEMBERSCR;
    UIButton * btnremeber;
}
@end

@implementation D1_LoginBoard_iphone
DEF_SINGLETON(D1_LoginBoard_iphone)

DEF_MODEL( UserModel, userModel )

- (void)load
{
	self.userModel = [UserModel modelWithObserver:self];
}

- (void)unload
{
    [self.userModel removeObserver:self];
    
}

#pragma mark -
ON_SIGNAL2(BeeUIBoard,  signal)
{
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        REMEMBERSCR=YES;
        self.allowedSwipeToBack=YES;
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage bundleImageNamed:@"index_body_bg"]];
        self.titleString = __TEXT(@"member_signin");
        [BeeUINavigationBar setButtonSize:CGSizeMake(30, 30)];
       [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage bundleImageNamed:@"fanhui(xin)"]];
        int baseInsetHeight=bee.ui.config.baseInsets.top - 15;
        inputview=[self layoutUsernamePassword:CGRectMake(0, 10 + baseInsetHeight, 320, 80)];
        inputview.center=CGPointMake(160, baseInsetHeight+70);
        [self.view addSubview:inputview];
        
        
        baseInsetHeight=baseInsetHeight+80;
        UIView *rememberView=[self rememberSecret:CGRectMake(0, baseInsetHeight + 30, 120, 40)];
        [self.view addSubview:rememberView];
        
        /*
         UIButton *forgetsecret=[UIButton buttonWithType:UIButtonTypeCustom];
        [forgetsecret setTitle:@"忘记密码" forState:UIControlStateNormal];
        forgetsecret.titleLabel.font = [UIFont systemFontOfSize:15];
        forgetsecret.frame=CGRectMake(185, baseInsetHeight + 30, 120, 40);
        [forgetsecret setTitleColor:[UIColor colorWithRed:20/255. green:154/255. blue:243/255. alpha:1]  forState:UIControlStateNormal];
        [self.view addSubview:forgetsecret];
        */
        baseInsetHeight= baseInsetHeight + 40;
        UIButton *loginbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
        loginbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        loginbtn.frame=CGRectMake(10, baseInsetHeight + 30, 290, 40);
        loginbtn.center=CGPointMake(320/2, baseInsetHeight+30+30);
        [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [loginbtn setBackgroundColor:[UIColor colorWithRed:20/255. green:154/255. blue:243/255. alpha:1] ];
        [loginbtn setBackgroundImage:[UIImage bundleImageNamed:@"dengluanniu01"] forState:UIControlStateNormal];
        [loginbtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
//        KT_CORNER_RADIUS(loginbtn, 3);
        [self.view addSubview:loginbtn];
        
        baseInsetHeight= baseInsetHeight + 60;
        onoff *of =[homeModel readOnff];
        if (of.isregist.boolValue) {
            UIButton *logoutbtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [logoutbtn setTitle:@"没有账号,立即注册" forState:UIControlStateNormal];
            logoutbtn.frame=CGRectMake(10, baseInsetHeight + 30, 280, 40);
            logoutbtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [logoutbtn setTitleColor:[UIColor colorWithRed:20/255. green:154/255. blue:243/255. alpha:1]  forState:UIControlStateNormal];
            logoutbtn.center=CGPointMake(320/2, baseInsetHeight+30+30);
            [logoutbtn addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:logoutbtn];
        }
    }
}

-(IBAction)rememberBtnTap:(id)sender
{
    if (REMEMBERSCR==NO) {
        REMEMBERSCR=YES;
        [btnremeber setImage:[UIImage bundleImageNamed:@"gouxuan"] forState:UIControlStateNormal];
    }
    else
    {
        [btnremeber setImage:[UIImage bundleImageNamed:@"weigouxuan"] forState:UIControlStateNormal];
        REMEMBERSCR=NO;
        
    }
    if (sender) {
        [DZ_SystemSetting saveUserSecret:REMEMBERSCR];
    }
}

-(UIView *)rememberSecret:(CGRect)frame
{
    UIView *rememView=[[UIView alloc] initWithFrame:frame];
    UIButton *icon=[UIButton buttonWithType:UIButtonTypeCustom];
    [icon setImage:[UIImage bundleImageNamed:@"gouxuan"] forState:UIControlStateNormal];
    icon.frame=CGRectMake(MARGIN_LEFT, 13, 15, 15);
    [rememView addSubview:icon];
     btnremeber=icon;
    [icon addTarget:self action:@selector(rememberBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btnremember=[UIButton buttonWithType:UIButtonTypeCustom]; //[[UILabel alloc] initWithFrame:CGRectMake(35, 10, frame.size.width-35, frame.size.height-20)];
    
    btnremember.backgroundColor=[UIColor clearColor];
    [btnremember setTitle:@"自动登录" forState:UIControlStateNormal];
    btnremember.titleLabel.font = [UIFont systemFontOfSize:15];
     btnremember.frame=CGRectMake(CGRectGetMaxX(icon.frame), 5, frame.size.width-35, frame.size.height-10);
    [btnremember setTitleColor:[UIColor colorWithRed:20/255. green:154/255. blue:243/255. alpha:1]  forState:UIControlStateNormal];
    [rememView addSubview:btnremember];
    [btnremember addTarget:self action:@selector(rememberBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    REMEMBERSCR = [DZ_SystemSetting saveUserSecret];
    if (REMEMBERSCR) {
          [icon setImage:[UIImage bundleImageNamed:@"gouxuan"] forState:UIControlStateNormal];
    }
    else
    {
          [icon setImage:[UIImage bundleImageNamed:@"weigouxuan"] forState:UIControlStateNormal];
    }
    return rememView;
}

-(UIView *)layoutUsernamePassword:(CGRect)frame
{
    int MARGIN_X = 0;
    UIView *bgview=[[UIView alloc] initWithFrame:frame];
    UIImageView *topimgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/2)];
//    topimgview.image=[UIImage bundleImageNamed:@"cell_bg_content.png"];
     topimgview.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:topimgview];
   
    UIImageView *log_in_user_name_icon=[[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 10, 20, 20)];
    log_in_user_name_icon.image=[UIImage bundleImageNamed:@"log_in_user_name_icon.png"];
    [bgview addSubview:log_in_user_name_icon];
    
    BeeUITextField *field=[[BeeUITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(log_in_user_name_icon.frame) + MARGIN_X, 0, frame.size.width-CGRectGetMaxX(log_in_user_name_icon.frame) - MARGIN_X * 2, frame.size.height/2)];
    field.placeholder=@"用户名/Email";
    field.tag= USERNAMETAG;
    field.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.username=field;
    [bgview addSubview:field];
    
    UIImageView *line=[[UIImageView alloc] initWithFrame:CGRectMake(2, frame.size.height/2, frame.size.width-4, 1)];
    line.backgroundColor=[UIColor colorWithRed:234./255. green:234/255. blue:234/255. alpha:0.5];
    [bgview addSubview:line];
    
    UIImageView *footimgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2)];
//    footimgview.image=[UIImage bundleImageNamed:@"cell_bg_content.png"];
    footimgview.backgroundColor = [UIColor whiteColor];
    footimgview.layer.borderColor = LINE_LAYERBOARDCOLOR;
    footimgview.layer.borderWidth = LINE_LAYERBOARDWIDTH;
    [bgview addSubview:footimgview];
    
    UIImageView *log_in_user_password_icon=[[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT,frame.size.height/2+10, 20, 20)];
    log_in_user_password_icon.image=[UIImage bundleImageNamed:@"log_in_key_icon.png"];
    [bgview addSubview:log_in_user_password_icon];
    
    BeeUITextField *password=[[BeeUITextField alloc] initWithFrame:CGRectMake(MARGIN_X + CGRectGetMaxX(log_in_user_password_icon.frame), frame.size.height/2, frame.size.width - MARGIN_X * 2 - CGRectGetMaxX(log_in_user_password_icon.frame), frame.size.height/2)];
    password.clearButtonMode=UITextFieldViewModeWhileEditing;
    password.secureTextEntry=YES;
    password.tag= PASSWORDTAG;
    self.password=password;
    password.placeholder=@"密码";
    [bgview addSubview:password];
    
    SESSION2 *session= [self.userModel readsession:nil];
    self.username.text=session.username;
    self.password.text=session.password;
    return bgview;
}


ON_LEFT_BUTTON_TOUCHED(signal)
{
    [[AppBoard_iPhone sharedInstance] hideLogin];
//    [self.stack popBoardAnimated:YES];
}
ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self showNavigationBarAnimated:NO];
    if ([UserModel sharedInstance].firstUse) {//此处状态改变
        [bee.ui.appBoard hideLogin];
        [UserModel sharedInstance].firstUse = NO;
    }
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -
//ON_LEFT_BUTTON_TOUCHED( signal )
//{
////    [[AppBoard_iPhone sharedInstance] hideLogin];
//}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
//    [self doLogin];
}

#pragma mark - BeeUITextField
ON_SIGNAL3(BeeUITextField,WILL_ACTIVE, signal)
{
    BeeUITextField *field=(BeeUITextField *)signal.sourceView;
    if (field.tag== PASSWORDTAG) {
       NSString *psw=[self.userModel readsessionForKey:self.username.text.trim];
       self.password.text=psw;
    }
}
// 删除用户名时 密码自动删除
ON_SIGNAL3(BeeUITextField, CLEAR, signal)
{
    BeeUITextField *field=(BeeUITextField *)signal.sourceView;
    if (field.tag== USERNAMETAG ) {
         self.password.text=@"";
    }
}

ON_SIGNAL3( BeeUITextField, RETURN, signal )
{
	if ( self.username.isFirstResponder)
	{
		[self.password becomeFirstResponder];
		return;
	}
	else
	{
		[self doLogin];
	} 
	[self.view endEditing:YES];
}

#pragma mark - SigninBoard_iPhone

ON_SIGNAL3(D1_LoginBoard_iphone, remembersecr, signal)
{
    BeeLog(@"记住密码按钮~~~~~");
}

ON_SIGNAL3(D1_LoginBoard_iphone, forgetsecr, signal)
{
    BeeLog(@"忘记密码按钮~~~~~");
}

#pragma mark -注册
-(void)signup
{
    D2_RegistViewController_iphone *registctr=[[D2_RegistViewController_iphone alloc] init];
    [self.navigationController pushViewController:registctr animated:YES];
}
#pragma mark - 登录
- (void)doLogin
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    self.userModel.saveUser=REMEMBERSCR;
	NSString * userName = self.username.text.trim;
	NSString * password = self.password.text.trim;
	if ( 0 == userName.length )//|| NO == [userName isChineseUserName]
	{
		[self presentMessageTips:__TEXT(@"wrong_username")];
		return;
	}
    
	if ( userName.length < 2 )
	{
		[self presentMessageTips:__TEXT(@"username_too_short")];
		return;
	}
    
	if ( userName.length > 20 )
	{
		[self presentMessageTips:__TEXT(@"username_too_long")];
		return;
	}
    
	if ( 0 == password.length || NO == [password isPassword] )
	{
		[self presentMessageTips:__TEXT(@"wrong_password")];
		return;
	}
    
	if ( password.length < 6 )
	{
		[self presentMessageTips:__TEXT(@"password_too_short")];
		return;
	}
	
	if ( password.length > 20 )
	{
		[self presentMessageTips:__TEXT(@"password_too_long")];
		return;
	}
    
	[self.userModel signinWithUser:userName password:password];
    [self presentLoadingTips:__TEXT(@"signing_in")];
}

//ON_MESSAGE3( API, login, msg )
//{
//    if ( msg.sending )
//	{
//		[self presentLoadingTips:__TEXT(@"signing_in")];
//	}
//	else
//	{
//		[self dismissTips];
//	}
//}

#pragma mark -
ON_SIGNAL3(UserModel, LOGIN_FAILED, signal)
{
    [self dismissTips];
    NSString *msg=[NSString stringWithFormat:@"%@",signal.object];
    [self presentFailureTips:msg];
}

//UserModel.LOGIN_RELOADED
ON_SIGNAL3(UserModel, LOGIN_RELOADED, signal)
{
    [self dismissTips];
    if ( [UserModel sharedInstance].firstUse )
    {
    }
    if (REMEMBERSCR) {
 
    }
    [[UserModel sharedInstance] updateProfile];
//    [self postNotification:self.LOGINSUCCESS];
    BeeUITipsView *tips=[self presentSuccessTips:__TEXT(@"welcome_back")];
    tips.tag=30;
}

ON_SIGNAL3(BeeUITipsView,WILL_DISAPPEAR, signal)
{
    BeeUITipsView *tipsview=(BeeUITipsView *)signal.sourceView;
    if(tipsview.tag==30)
//        BOOL isfirtlogin=[UserModel defa] //bee.ui.appBoard.firstLogin;
        if (![UserModel sharedInstance].firstUse) {
            [bee.ui.appBoard hideLogin];
        }
}

@end
