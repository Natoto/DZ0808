//
//  D2_RegistViewController_iphone.m
//  DZ
//
//  Created by Nonato on 14-5-13.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import "UserModel.h"
#import "D2_RegistViewController_iphone.h"
#import "D1_ModifyPersonInfoViewController_iphone.h"

@interface D2_RegistViewController_iphone ()
{
    UIScrollView   * scrollview;
}
@property(nonatomic,strong)BeeUITextField * username;
@property(nonatomic,strong)BeeUITextField * password;
@property(nonatomic,strong)BeeUITextField * confirmpassword;
@property(nonatomic,strong)BeeUITextField * email;
@property(nonatomic,strong)UIScrollView   * scrollview;
@property(nonatomic,strong)UserModel      * registermodel;
@property(nonatomic,strong)UserModel      * loginmodel;
@end

@implementation D2_RegistViewController_iphone
@synthesize scrollview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [self unobserveAllNotifications];
    [self.registermodel removeObserver:self];
    [self.loginmodel removeObserver:self];
}
- (void)viewDidLoad
{
    self.registermodel = [UserModel modelWithObserver:self];
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage bundleImageNamed:@"index_body_bg"]];
    scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelSingleTap:)];
    [scrollview addGestureRecognizer:singleTap];
    [singleTap setNumberOfTouchesRequired:1];//触摸点个数
    [singleTap setNumberOfTapsRequired:1];//点击次数
    [self.view addSubview:scrollview];
    self.scrollview=scrollview;
    self.title = @"注册";
     int TOPHEIGHT= 40;
     int MARGINV=0;
     int TEXTFIELDHEIGHT=40;
     int MARGIN_X=0;
    self.username=[self createTextFieldWithFrame:CGRectMake(MARGIN_X, TOPHEIGHT,320 - 2*MARGIN_X, TEXTFIELDHEIGHT) placeholder:@"请输入用户名" tag:1510 border:NO];
     self.password=[self createTextFieldWithFrame:CGRectMake(MARGIN_X,  TOPHEIGHT+(MARGINV+TEXTFIELDHEIGHT)*1, 320 - 2*MARGIN_X, TEXTFIELDHEIGHT) placeholder:@"请输入密码" tag:1512 border:NO];
    self.password.secureTextEntry=YES;
    self.confirmpassword=[self createTextFieldWithFrame:CGRectMake(MARGIN_X, TOPHEIGHT+(MARGINV+TEXTFIELDHEIGHT) *2, 320 - 2*MARGIN_X, TEXTFIELDHEIGHT) placeholder:@"请再次输入密码" tag:1513 border:YES];
    
    self.email=[self createTextFieldWithFrame:CGRectMake(MARGIN_X, TOPHEIGHT + (MARGINV + TEXTFIELDHEIGHT)*3, 320 - 2*MARGIN_X, TEXTFIELDHEIGHT) placeholder:@"请输入Email" tag:1511 border:YES];
    
    self.confirmpassword.secureTextEntry=YES;
    self.username.center=CGPointMake(320.0/2, TOPHEIGHT);
    self.email.center=CGPointMake(320.0/2, (TOPHEIGHT + MARGINV + TEXTFIELDHEIGHT));
    self.password.center=CGPointMake(320.0/2, TOPHEIGHT + (MARGINV + TEXTFIELDHEIGHT)*2);
    self.confirmpassword.center=CGPointMake(320.0/2, TOPHEIGHT + (MARGINV+TEXTFIELDHEIGHT)*3);
    
    
    UIButton *registBtn =[UIButton buttonWithType:UIButtonTypeCustom];
   //    [registBtn setTintColor:[UIColor blackColor]];
//    [registBtn setBackgroundColor:[UIColor colorWithRed:215./255 green:215./255. blue:215./255. alpha:1]];
    [registBtn setBackgroundImage:[UIImage bundleImageNamed:@"zhucheanniu01"] forState:UIControlStateNormal];
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [registBtn addTarget:self action:@selector(registBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    registBtn.frame=CGRectMake(15, TOPHEIGHT+(MARGINV+TEXTFIELDHEIGHT) *4 + 30, 290, TEXTFIELDHEIGHT);
    registBtn.center = CGPointMake(320.0/2, TOPHEIGHT + (MARGINV+TEXTFIELDHEIGHT)*4 + 30);
//    KT_CORNER_RADIUS(registBtn, 4);
    [scrollview addSubview:registBtn];
    
    [scrollview addSubview:self.username];
    [scrollview addSubview:self.password];
    [scrollview addSubview:self.email];
    [scrollview addSubview:self.confirmpassword];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    [self observeNotification:BeeUIKeyboard.SHOWN];
//    [self observeNotification:BeeUIKeyboard.HIDDEN];
    // Do any additional setup after loading the view.
}
- (void)keyBoardWillShow:(NSNotification *)notify{
    
        CGRect rect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat ty = rect.size.height;
        [UIView animateWithDuration:[notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            scrollview.contentSize = CGSizeMake(320, CGRectGetHeight(self.view.frame) + ty);
//            self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        }];
    
}
-(void)keyBoardWillHide:(NSNotification *)notify
{
    [UIView animateWithDuration:[notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.view.transform = CGAffineTransformIdentity;
    scrollview.contentSize = CGSizeMake(320, CGRectGetHeight(self.view.frame));
    }];
}

ON_SIGNAL3(BeeUITextField, RETURN, signal)
{
    BeeUITextField *textfield=(BeeUITextField *)signal.sourceView;
    if (textfield.tag<1513) {
        BeeUITextField *subtextfield=(BeeUITextField *)[self.scrollview viewWithTag:(textfield.tag+1)];
        [subtextfield becomeFirstResponder];
    }
    else
    {
        [self registBtnTap:nil];
    }
}

-(void)handelSingleTap:(UITapGestureRecognizer*)gestureRecognizer
{
    NSLog(@"%s",__FUNCTION__);
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.email resignFirstResponder];
    [self.confirmpassword resignFirstResponder];
}

-(IBAction)registBtnTap:(id)sender
{
    [self handelSingleTap:nil];
	NSString * userName = self.username.text.trim;//$(@"username").text.trim;
	NSString * password = self.password.text.trim; //$(@"password").text.trim;
    NSString * email=self.email.text.trim;
    NSString * confirmpassword=self.confirmpassword.text.trim;
	if ( 0 == userName.length )//|| NO == [userName isChineseUserName
	{
		[self presentMessageTips:__TEXT(@"wrong_username")];
		return;
	}
    
	if ( userName.length < 3 )
	{
		[self presentMessageTips:__TEXT(@"username_too_short")];
		return;
	}
    
	if ( userName.length > 15 )
	{
		[self presentMessageTips:__TEXT(@"username_too_long")];
		return;
	}
    
    if (![confirmpassword isEqualToString:password]) {
        [self presentMessageTips:__TEXT(@"password_not_match")];
        return;
    }
    
    
	if ( 0 == password.length )//|| NO == [password isPassword]
	{
		[self presentMessageTips:__TEXT(@"wrong_password")];
		return;
	}
    
	if ( password.length < 6 )
	{
		[self presentMessageTips:__TEXT(@"password_too_short")];
		return;
	}
	
	if ( password.length > 18 )
	{
		[self presentMessageTips:__TEXT(@"password_too_long")];
		return;
	}
    
    if (0 == email.length || NO ==[email  isEmail] ) {
        [self presentMessageTips:__TEXT(@"wrong_email")];
		return;
    }
    
    [self.registermodel signupWithUser:userName password:password email:email];
    [self presentLoadingTips:__TEXT(@"signing_up")];
}

ON_SIGNAL3(UserModel, REGIST_RELOADED, signal)
{
    [self dismissTips];
    BeeUITipsView *tipsview=[self presentLoadingTips:@"注册成功! 正在转入资料编辑界面..."];
    tipsview.tag=162759;
    [UserModel sharedInstance].firstUse = YES;//第一次登陆的判断
    self.loginmodel = [UserModel modelWithObserver:self];
    [self.loginmodel signinWithUser:self.username.text password:self.password.text];
    
}

ON_SIGNAL3(UserModel, REGIST_FAILED, signal)
{
    [self dismissTips];
    [self presentSuccessTips:self.registermodel.regist.emsg];
}

#pragma mark - 登陆 更新。。。

ON_SIGNAL3(UserModel,LOGIN_RELOADED , signal)
{
    [self.loginmodel updateProfile];
}

ON_SIGNAL3(UserModel, LOGIN_FAILED, signal)
{
   [self dismissTips];
}

ON_SIGNAL3(UserModel, PROFILE_RELOADED, signal)
{
    [self dismissTips]; 
    D1_ModifyPersonInfoViewController_iphone *ctr =[[D1_ModifyPersonInfoViewController_iphone alloc] init];
    ctr.firstLogin = YES;
    ctr.username=[UserModel sharedInstance].session.username;
    ctr.profile=self.loginmodel.profile;
    ctr.navigationBarTitle = @"完善资料";
    [self.navigationController pushViewController:ctr animated:YES];
}

ON_SIGNAL3(UserModel, PROFILE_FAILED, signal)
{
     [self dismissTips];
}

ON_SIGNAL3(BeeUITipsView, WILL_DISAPPEAR, signal)
{
//    BeeUITipsView *tipsview=(BeeUITipsView *)signal.sourceView;
//    if (tipsview.tag==162759) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BeeUITextField *)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder tag:(int)tag border:(BOOL)border
{
    BeeUITextField *textfield=[[BeeUITextField alloc] initWithFrame:frame];
    textfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    textfield.placeholder=placeholder;
    textfield.tag=tag;
    textfield.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    if (border) {
        textfield.layer.borderColor =LINE_LAYERBOARDCOLOR;  //[[UIColor colorWithRed:218./255.0 green:218./255.0 blue:218./255.0 alpha:1.0]CGColor];
        textfield.layer.borderWidth = LINE_LAYERBOARDWIDTH; // 1.0;
    }
//    textfield.layer.cornerRadius = 4.0f;
    [textfield.layer setMasksToBounds:YES];
    return textfield;
}
    
@end
    
