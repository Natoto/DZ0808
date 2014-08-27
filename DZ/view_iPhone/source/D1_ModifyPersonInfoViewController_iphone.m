//
//  D1_ModifyPersonInfoViewController_iphone.m
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import "D1_ModifyPersonInfoViewController_iphone.h"
#import "Bee.h"
#import "AppBoard_iPhone.h"
#import "LXActionSheet.h"
#import "SEPhotoView.h"
#import "C0_HairPost_SelectPlates.h"
#import "D1_BirthdaySelector.h"
#import "D1_CitySelector.h"
#import "ModifyPersonalInfoModel.h"
#import "UserModel.h"
#import "ModeavatarModel.h"
#import "HBImagePickerControllerEx.h"
#import "MaskView.h"
#import "D0_Mine_iphone.h"

#define DIANXUANICON @"dianxuan"
#define WEIDIANXUAN  @"weidianxuan"
#define BIRTHDAYSELECTORTAG 102230
#define CITYSELECTORTAG 102232

@interface D1_ModifyPersonInfoViewController_iphone ()<LXActionSheetDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, MaskViewDelegate>
{
    UIView * genderSelectView;
    MaskView *maskView;
}

@property(nonatomic,strong) UIView *belowview;
//@property(nonatomic,strong) C0_HairPost_SelectPlates * locateView;
@property(nonatomic,strong) D1_BirthdaySelector      * brithdaySelector;
@property(nonatomic,strong) D1_CitySelector          * cityselector;
@property(nonatomic,strong) ModifyPersonalInfoModel  * modifyModel;
@property(nonatomic,strong) ModeavatarModel          * modavatarModel;
@end

@implementation D1_ModifyPersonInfoViewController_iphone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationBarTitle = @"个人资料";
    self.modifyreq = [[REQ_MODIFYPROFILE_SHOTS alloc] init];
    [self showBarButton:BeeUINavigationBar.RIGHT title:@"确定"];
    [self layoutHeaderViews:CGRectMake(0, 10, 320, 50)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage bundleImageNamed:@"index_body_bg"]];
    _belowview = [self layoutUsernamePassword:CGRectMake(0, 80, 320, 200)];
    [self.view addSubview:_belowview];
    _brithdaySelector = [[D1_BirthdaySelector alloc] initWithTitle:@"选择出生年月" delegate:self];
    _brithdaySelector.tag = BIRTHDAYSELECTORTAG;
    _cityselector = [[D1_CitySelector alloc] initWithTitle:@"选择地区" delegate:self];
    _cityselector.tag=CITYSELECTORTAG;
    
    self.modifyModel=[ModifyPersonalInfoModel modelWithObserver:self];
    self.modavatarModel=[ModeavatarModel modelWithObserver:self];

    maskView = [[MaskView alloc] initWithFrame:self.view.frame];
    maskView.delegate = self;
}

- (void)dealloc
{
    [self.modifyModel removeObserver:self];
    [self.modavatarModel removeObserver:self];
}

#pragma mark - 提交修改信息
ON_RIGHT_BUTTON_TOUCHED(signal)
{
    //先上传头像，成功后在提交其他的修改
    self.modavatarModel.uid=[UserModel sharedInstance].session.uid;
    self.modavatarModel.imgdata=UIImageJPEGRepresentation(self.imgavtor.image, 0.3);
    [_modavatarModel load];
    [_modavatarModel firstPage];
    [self presentLoadingTips:[NSString stringWithFormat:@"正在上传头像..."]];
}

ON_SIGNAL3(ModeavatarModel, RELOADED, signal)
{
    [self dismissTips];
    self.modifyreq.uid=[UserModel sharedInstance].session.uid;

    //性别
    self.modifyreq.gender = [[BeeUserDefaults sharedInstance] objectForKey:@"gender"];

    //生日
    self.modifyreq.birthyear = [[BeeUserDefaults sharedInstance] objectForKey:@"birthyear"];
    self.modifyreq.birthmonth = [[BeeUserDefaults sharedInstance] objectForKey:@"birthmonth"];
    self.modifyreq.birthday = [[BeeUserDefaults sharedInstance] objectForKey:@"birthday"];

    //省市
    if (!self.modifyreq.resideprovince || [self.modifyreq.resideprovince isEqualToString:@""])
        self.modifyreq.resideprovince = [[BeeUserDefaults sharedInstance] objectForKey:@"resideprovince"];
    if (!self.modifyreq.residecity || [self.modifyreq.residecity isEqualToString:@""])
        self.modifyreq.residecity = [[BeeUserDefaults sharedInstance] objectForKey:@"residecity"];

    self.modifyModel.modifyReq=self.modifyreq;
    [self.modifyModel firstPage];
    [self presentLoadingTips:@"提交修改中..."];
}

ON_SIGNAL3(ModeavatarModel, FAILED, signal)
{
    [self dismissTips];
}

ON_SIGNAL3(ModifyPersonalInfoModel, FAILED, signal)
{
    [self dismissTips];
    [self presentFailureTips:@"修改失败"];
}

ON_SIGNAL3(ModifyPersonalInfoModel, RELOADED, signal)
{
    [self dismissTips];
    BeeUITipsView *tipsView= [self presentSuccessTips:@"资料修改成功"];
    tipsView.tag=143329;
}

ON_SIGNAL3(BeeUITipsView, WILL_DISAPPEAR, signal)
{    
    BeeUITipsView *tipsView =(BeeUITipsView *)signal.sourceView;
    if (tipsView.tag==143329)
    {
        [[D0_Mine_iphone sharedInstance] refreshView];
        if (self.firstLogin)
        {
             [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//ON_SIGNAL3(D1_ModifyPersonInfoViewController_iphone, refresh, signal)
//{
//    //获取服务器数据并添加
//    if ([UserModel sharedInstance].profile)
//    {
//        _lblyourarea.text = [NSString stringWithFormat:@"%@ %@", [UserModel sharedInstance].profile.resideprovince, [UserModel sharedInstance].profile.residecity];
//        _lblbirthyearmonth.text = [NSString stringWithFormat:@"%@-%@", [UserModel sharedInstance].profile.birthyear, [UserModel sharedInstance].profile.birthmonth];
//    }
//}

//#pragma mark - 个人资料加载成功
//ON_SIGNAL3(UserModel, PROFILE_RELOADED, signal)
//{
//    NSLog(@"%@%@", [UserModel sharedInstance].profile.birthyear, [UserModel sharedInstance].profile.birthmonth);
//    _lblbirthyearmonth.text = [NSString stringWithFormat:@"%@-%@", [UserModel sharedInstance].profile.birthyear, [UserModel sharedInstance].profile.birthmonth];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (![UserModel sharedInstance].firstUse) {
        [bee.ui.appBoard hideTabbar];
    }
}
-(void)layoutHeaderViews:(CGRect)frame
{
 /* 不能修改昵称 
  UIImageView *topimgview=[[UIImageView alloc] initWithFrame:frame];
//    topimgview.image=[UIImage bundleImageNamed:@"cell_bg_single"];
    topimgview.backgroundColor = [UIColor whiteColor];
    topimgview.layer.borderWidth = LINE_LAYERBOARDWIDTH;
    topimgview.layer.borderColor = LINE_LAYERBOARDCOLOR;
    [self.view addSubview:topimgview];
  
  BeeUITextField *txtname=[[BeeUITextField alloc] initWithFrame:CGRectMake(frame.origin.x+10, frame.origin.y,frame.size.width-20, frame.size.height)];
    txtname.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtname.placeholder = @"Your Name";
    txtname.enabled = NO;
    self.txtusername=txtname;
    self.txtusername.text=self.username;
    [self.view addSubview:txtname];*/
}

- (UIView *)layoutUsernamePassword:(CGRect)frame
{
    UIView *bgview=[[UIView alloc] initWithFrame:frame];
    UIImageView *topimgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
//    topimgview.image=[UIImage bundleImageNamed:@"cell_bg_header.png"];
    topimgview.backgroundColor = [UIColor whiteColor];
//    topimgview.layer.borderWidth = LINE_LAYERBOARDWIDTH;
//    topimgview.layer.borderColor = LINE_LAYERBOARDCOLOR;
    [bgview addSubview:topimgview];
    
    UIImageView *cell_bg_contentview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 50)];
//    cell_bg_contentview.image=[UIImage bundleImageNamed:@"cell_bg_content"];
    cell_bg_contentview.backgroundColor = [UIColor whiteColor];
    cell_bg_contentview.layer.borderWidth = LINE_LAYERBOARDWIDTH;
    cell_bg_contentview.layer.borderColor = LINE_LAYERBOARDCOLOR;
    [bgview addSubview:cell_bg_contentview];
    
    UIImageView *cell_bg_contentview2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 100, frame.size.width, 50)];
//    cell_bg_contentview2.image=[UIImage bundleImageNamed:@"cell_bg_content"];
    
    cell_bg_contentview2.backgroundColor = [UIColor whiteColor];
//    cell_bg_contentview2.layer.borderWidth = LINE_LAYERBOARDWIDTH;
//    cell_bg_contentview2.layer.borderColor = LINE_LAYERBOARDCOLOR;
    [bgview addSubview:cell_bg_contentview2];
    
    
    UIImageView *footimgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 50)];
//    footimgview.image=[UIImage bundleImageNamed:@"cell_bg_footer.png"];
    footimgview.backgroundColor = [UIColor whiteColor];
    footimgview.layer.borderWidth = LINE_LAYERBOARDWIDTH;
    footimgview.layer.borderColor = LINE_LAYERBOARDCOLOR;
    [bgview addSubview:footimgview];
    
    
    BeeUIImageView *profile=[[BeeUIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    profile.backgroundColor=[UIColor grayColor];
    profile.image=[UIImage bundleImageNamed:@"profile.jpg"];
    profile.contentMode=UIViewContentModeScaleToFill;
    KT_CORNER_PROFILE(profile);
    self.imgavtor=profile;
    profile.data=self.profile.avatar;
    [bgview addSubview:profile];


    //头像
    UILabel *touxiang=[[UILabel alloc] initWithFrame:CGRectMake(55, 10, frame.size.width-55, 30)];
    touxiang.text=@"头像";
    [bgview addSubview:touxiang];
    UIButton *profileBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame=CGRectMake(0, 0, frame.size.width, 50);
    [profileBtn addTarget:self action:@selector(profileBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:profileBtn];

    //性别
    UILabel *xingbie=[[UILabel alloc] initWithFrame:CGRectMake(10, 60, 60, 30)];
    xingbie.text=@"性别:";
    [bgview addSubview:xingbie];
    genderSelectView = [self layoutgenderSelector:CGRectMake(105, 55, 220, 50)];
    [bgview addSubview:genderSelectView];


    //生日
    UILabel *shengri=[[UILabel alloc] initWithFrame:CGRectMake(10, 110, 40, 30)];
    shengri.text=@"生日:";
    [bgview addSubview:shengri];
    _lblbirthyearmonth = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shengri.frame),CGRectGetMinY(shengri.frame) ,frame.size.width - CGRectGetMaxX(shengri.frame) - 25, 30)];
    _lblbirthyearmonth.textAlignment = NSTextAlignmentRight;
    _lblbirthyearmonth.textColor=[UIColor grayColor];
    if ([UserModel sharedInstance].profile) {
        [[BeeUserDefaults sharedInstance] setObject:[UserModel sharedInstance].profile.birthyear forKey:@"birthyear"];
        [[BeeUserDefaults sharedInstance] setObject:[UserModel sharedInstance].profile.birthmonth forKey:@"birthmonth"];
        [[BeeUserDefaults sharedInstance] setObject:[UserModel sharedInstance].profile.birthday forKey:@"birthday"];
    }
    //获取服务器数据并添加
    if ([UserModel sharedInstance].profile)
        _lblbirthyearmonth.text = [NSString stringWithFormat:@"%@-%@-%@", [UserModel sharedInstance].profile.birthyear, [UserModel sharedInstance].profile.birthmonth, [UserModel sharedInstance].profile.birthday];
    else if ([[BeeUserDefaults sharedInstance] objectForKey:@"birthyear"])
        _lblbirthyearmonth.text = [NSString stringWithFormat:@"%@-%@-%@", [[BeeUserDefaults sharedInstance] objectForKey:@"birthyear"], [[BeeUserDefaults sharedInstance] objectForKey:@"birthmonth"], [[BeeUserDefaults sharedInstance] objectForKey:@"birthday"]];
    else
        _lblbirthyearmonth.text = @"1988-09-01";
    NSLog(@"%@-%@-%@", [UserModel sharedInstance].profile.birthyear, [UserModel sharedInstance].profile.birthmonth, [UserModel sharedInstance].profile.birthday);
    NSLog(@"我的UID是：%@", [UserModel sharedInstance].session.uid);
    [bgview addSubview:_lblbirthyearmonth];
    UIButton *shengriBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shengriBtn.frame=CGRectMake(0, 100, frame.size.width, 50);
    [shengriBtn addTarget:self action:@selector(shengriBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:shengriBtn];



    //地区
    UILabel *diqu = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 40, 30)];
    diqu.text = @"地区:";
    [bgview addSubview:diqu];
    _lblyourarea = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(diqu.frame), 160, frame.size.width - CGRectGetMaxX(diqu.frame) - 25, 30)];
    _lblyourarea.textAlignment = NSTextAlignmentRight;
    _lblyourarea.textColor=[UIColor grayColor];
    _lblyourarea.backgroundColor = [UIColor clearColor];
    if ([UserModel sharedInstance].profile) {
        [[BeeUserDefaults sharedInstance] setObject:[UserModel sharedInstance].profile.resideprovince forKey:@"resideprovince"];
        [[BeeUserDefaults sharedInstance] setObject:[UserModel sharedInstance].profile.residecity forKey:@"residecity"];
    }
    //获取服务器数据并添加
    if ([UserModel sharedInstance].profile)
        _lblyourarea.text = [NSString stringWithFormat:@"%@ %@", [UserModel sharedInstance].profile.resideprovince, [UserModel sharedInstance].profile.residecity];
    else if ([[BeeUserDefaults sharedInstance] objectForKey:@"resideprovince"])
        _lblyourarea.text = [NSString stringWithFormat:@"%@ %@", [[BeeUserDefaults sharedInstance] objectForKey:@"resideprovince"], [[BeeUserDefaults sharedInstance] objectForKey:@"residecity"]];
    else
        _lblyourarea.text = @"广东省 广州市";
    NSLog(@"%@%@", [UserModel sharedInstance].profile.resideprovince, [UserModel sharedInstance].profile.residecity);
    [bgview addSubview:_lblyourarea];
    UIButton *diquBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    diquBtn.frame=CGRectMake(0, 150, frame.size.width, 50);
    [diquBtn addTarget:self action:@selector(diquBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:diquBtn];


    float ARRORHEIGHT = 12;
    float MARGIN_RIGHT =10;
    //箭头
    UIImageView *arrows1 = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"tiaozhuan001"]];
    arrows1.contentMode = UIViewContentModeScaleAspectFit;
    arrows1.frame = CGRectMake(CGRectGetMaxX(frame) - MARGIN_RIGHT- ARRORHEIGHT, CGRectGetMidY(_lblbirthyearmonth.frame)-ARRORHEIGHT/2., ARRORHEIGHT, ARRORHEIGHT);
    [bgview addSubview:arrows1];

    UIImageView *arrows2 = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"tiaozhuan001"]];
    arrows2.frame = CGRectMake(CGRectGetMaxX(frame) - MARGIN_RIGHT - ARRORHEIGHT, CGRectGetMidY(_lblyourarea.frame)-ARRORHEIGHT/2., ARRORHEIGHT, ARRORHEIGHT);
    arrows2.contentMode = UIViewContentModeScaleAspectFit;
    [bgview addSubview:arrows2];

    UIImageView *arrows3 = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"tiaozhuan001"]];
    arrows3.frame = CGRectMake(CGRectGetMaxX(frame) - MARGIN_RIGHT- ARRORHEIGHT, CGRectGetMidY(touxiang.frame)-ARRORHEIGHT/2. /*- ARRORHEIGHT/2.*/, ARRORHEIGHT, ARRORHEIGHT);
    arrows3.contentMode = UIViewContentModeScaleAspectFit;
    [bgview addSubview:arrows3];

    return bgview;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BeeLog(@"actionsheet tag = %d",actionSheet.tag);
    if (actionSheet.tag == 255) {
        
    }
    else if(actionSheet.tag == BIRTHDAYSELECTORTAG)
    {//buttonIndex == 0 取消
        if (buttonIndex == 1) {
            [self selectBirthYearMonth:actionSheet andclickedButtonAtIndex:buttonIndex];
        }
    }
    else if (actionSheet.tag == CITYSELECTORTAG)
    {
        if (buttonIndex == 1) {
            [self selectCity:actionSheet andclickedButtonAtIndex:buttonIndex];
        }
    }
}

//选择城市
-(void)selectCity:(UIActionSheet *)actionSheet andclickedButtonAtIndex:(NSInteger)buttonIndex
{
    D1_CitySelector *selector = (D1_CitySelector *)actionSheet;
    LocationCity  *location = selector.locate;
    self.modifyreq.resideprovince = location.provice;
    self.modifyreq.residecity = location.city;
    _lblyourarea.text = [NSString stringWithFormat:@"%@ %@", location.provice, location.city];
}

//选择生日
-(void)selectBirthYearMonth:(UIActionSheet *)actionSheet andclickedButtonAtIndex:(NSInteger)buttonIndex
{
    D1_BirthdaySelector *selector = (D1_BirthdaySelector *)actionSheet;
    BirthYearMonth *birth = selector.locate;
//    self.modifyreq.birthyear = [NSNumber numberWithInt:birth.year.integerValue];
//    self.modifyreq.birthmonth = [NSNumber numberWithInt:birth.month.integerValue];
//    self.modifyreq.birthday = [NSNumber numberWithInt:birth.day.integerValue];
    _lblbirthyearmonth.text = [NSString stringWithFormat:@"%@-%02d-%02d", birth.year, birth.month.integerValue, birth.day.integerValue];
    BeeLog(@"%@-%@-%@", birth.year, birth.month, birth.day);

    [[BeeUserDefaults sharedInstance] setObject:[NSNumber numberWithInt:birth.year.intValue] forKey:@"birthyear"];
    [[BeeUserDefaults sharedInstance] setObject:[NSNumber numberWithInt:birth.month.intValue] forKey:@"birthmonth"];
    [[BeeUserDefaults sharedInstance] setObject:[NSNumber numberWithInt:birth.day.intValue] forKey:@"birthday"];
}

-(void)selectPlates:(UIActionSheet *)actionSheet andclickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    C0_HairPost_SelectPlates *locateView = (C0_HairPost_SelectPlates *)actionSheet;
    //    LoacateChild *location = locateView.locate;
    //    if (location.child) {
    //        NSLog(@"name:%@ fid:%@ lastpost:%@", location.child.name, location.child.fid, location.child.lastpost);
    //        NSString *key=[NSString stringWithFormat:@"%@ / %@",location.parent.name,location.child.name];
    //        self.selectfid=location.child.fid;
    //        [self.selectforumbtn setTitle:key forState:UIControlStateNormal];
    //    }
    //    //You can uses location to your application.
    //    if(buttonIndex == 0) {
    //        NSLog(@"Cancel");
    //    }else {
    //        NSLog(@"Select");
    //    }
}
#pragma mark - 显示和隐藏
ON_SIGNAL3(D1_CitySelector, DIDSHOW, signal)
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if ((self.view.frame.size.height-200-260) < 80) {
        _belowview.frame=CGRectMake(0, self.view.frame.size.height-200-260, 320, 200);        
    }
    [UIView commitAnimations];

}

ON_SIGNAL3(D1_CitySelector, DIDHIDE, signal)
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    _belowview.frame=CGRectMake(0, 80, 320, 200);
    [UIView commitAnimations];

}

ON_SIGNAL3(D1_BirthdaySelector, DIDSHOW, signal)
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if ((self.view.frame.size.height-200-260) < 80) {
        _belowview.frame=CGRectMake(0, self.view.frame.size.height-200-260, 320, 200);
    }
    [UIView commitAnimations];
}

ON_SIGNAL3(D1_BirthdaySelector, DIDHIDE, signal)
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    _belowview.frame=CGRectMake(0, 80, 320, 200);
    [UIView commitAnimations];
}
-(IBAction)profileBtnTap:(id)sender
{
    BeeLog(@"选择头像");
//    [self.txtusername resignFirstResponder];
    
    LXActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        sheet  = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照", @"从手机相册选择"]];
    else
        sheet = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从手机相册选择"]];
    sheet.tag = 255;
    [sheet showInView:self.view];
    [self.view bringSubviewToFront:sheet];
}
#pragma mark - 修改名字
ON_SIGNAL3(BeeUITextField, WILL_ACTIVE, signal)
{
//    [_locateView cancel:nil];
    [_cityselector cancel:nil];
    [_brithdaySelector cancel:nil];
}
#pragma mark -选择生日
-(IBAction)shengriBtnTap:(id)sender
{
    BeeLog(@"选择生日");
//    [self.txtusername resignFirstResponder];
    [_cityselector cancel:nil];
    [_brithdaySelector showInView:self.view YearMonth:self.lblbirthyearmonth.text];
    [maskView showInView:self.view belowSubview:_brithdaySelector];
}
#pragma mark - 选择地区
-(IBAction)diquBtnTap:(id)sender
{
    BeeLog(@"选择地区");
//    [self.txtusername resignFirstResponder];
    [_brithdaySelector cancel:nil];
    [_cityselector showInView:self.view Provicename:nil cityname:nil];
    [maskView showInView:self.view belowSubview:_cityselector];
//    [_locateView showInView:self.view];
}
#pragma mark - 性别修改

-(UIView *)layoutgenderSelector:(CGRect)frame
{
    UIView *bgview=[[UIView alloc] initWithFrame:frame];

    NSString *gender = [[[NSNumberFormatter alloc] init] stringFromNumber:self.profile.gender];
    if (gender)
        [[BeeUserDefaults sharedInstance] setObject:gender forKey:@"gender"];

    //男
    if (self.profile.gender && [self.profile.gender isEqualToNumber:[NSNumber numberWithInt:1]])
        [self addGenderItem:bgview btnframe:CGRectMake(0, 0, 20, 40) andlabelframe:CGRectMake(25, 0, 40, 40) imgname:DIANXUANICON gender:@"男" tag:115101 target:@selector(genderBtnTap:)];
    else if ([[[BeeUserDefaults sharedInstance] objectForKey:@"gender"] isEqualToString:@"1"])
        [self addGenderItem:bgview btnframe:CGRectMake(0, 0, 20, 40) andlabelframe:CGRectMake(25, 0, 40, 40) imgname:DIANXUANICON gender:@"男" tag:115101 target:@selector(genderBtnTap:)];
    else
        [self addGenderItem:bgview btnframe:CGRectMake(0, 0, 20, 40) andlabelframe:CGRectMake(25, 0, 40, 40) imgname:WEIDIANXUAN gender:@"男" tag:115101 target:@selector(genderBtnTap:)];

    //女
    if (self.profile.gender && [self.profile.gender isEqualToNumber:[NSNumber numberWithInt:2]])
        [self addGenderItem:bgview btnframe:CGRectMake(70, 0, 20, 40) andlabelframe:CGRectMake(95, 0, 40, 40) imgname:DIANXUANICON gender:@"女" tag:115103 target:@selector(genderBtnTap:)];
    else if ([[[BeeUserDefaults sharedInstance] objectForKey:@"gender"] isEqualToString:@"2"])
        [self addGenderItem:bgview btnframe:CGRectMake(70, 0, 20, 40) andlabelframe:CGRectMake(95, 0, 40, 40) imgname:DIANXUANICON gender:@"女" tag:115103 target:@selector(genderBtnTap:)];
    else
        [self addGenderItem:bgview btnframe:CGRectMake(70, 0, 20, 40) andlabelframe:CGRectMake(95, 0, 40, 40) imgname:WEIDIANXUAN gender:@"女" tag:115103 target:@selector(genderBtnTap:)];


    //保密
    if (self.profile.gender && [self.profile.gender isEqualToNumber:[NSNumber numberWithInt:0]])
        [self addGenderItem:bgview btnframe:CGRectMake(140, 0, 20, 40) andlabelframe:CGRectMake(165, 0, 40, 40) imgname:DIANXUANICON gender:@"保密" tag:115105 target:@selector(genderBtnTap:)];
    else if ([[[BeeUserDefaults sharedInstance] objectForKey:@"gender"] isEqualToString:@"0"])
        [self addGenderItem:bgview btnframe:CGRectMake(140, 0, 20, 40) andlabelframe:CGRectMake(165, 0, 40, 40) imgname:DIANXUANICON gender:@"保密" tag:115105 target:@selector(genderBtnTap:)];
    else
        [self addGenderItem:bgview btnframe:CGRectMake(140, 0, 20, 40) andlabelframe:CGRectMake(165, 0, 40, 40) imgname:WEIDIANXUAN gender:@"保密" tag:115105 target:@selector(genderBtnTap:)];

    return bgview;
}

-(IBAction)genderBtnTap:(id)sender
{
    UIButton *button=(UIButton *)sender;
    if (button.tag==115101 || button.tag==115102)
    {
        UIButton *male=(UIButton *)[genderSelectView viewWithTag:115101];
        [male setImage:[UIImage bundleImageNamed:DIANXUANICON] forState:UIControlStateNormal];
        UIButton *female=(UIButton *)[genderSelectView viewWithTag:115103];
        [female setImage:[UIImage bundleImageNamed:WEIDIANXUAN] forState:UIControlStateNormal];
        UIButton *nogender=(UIButton *)[genderSelectView viewWithTag:115105];
        [nogender setImage:[UIImage bundleImageNamed:WEIDIANXUAN] forState:UIControlStateNormal];
//        self.modifyreq.gender=[NSNumber numberWithInt:1];
        [[BeeUserDefaults sharedInstance] setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
    }
    else if (button.tag==115103 || button.tag==115104)
    {
        UIButton *male=(UIButton *)[genderSelectView viewWithTag:115101];
        [male setImage:[UIImage bundleImageNamed:WEIDIANXUAN] forState:UIControlStateNormal];
        UIButton *female=(UIButton *)[genderSelectView viewWithTag:115103];
        [female setImage:[UIImage bundleImageNamed:DIANXUANICON] forState:UIControlStateNormal];
        UIButton *nogender=(UIButton *)[genderSelectView viewWithTag:115105];
        [nogender setImage:[UIImage bundleImageNamed:WEIDIANXUAN] forState:UIControlStateNormal];
//        self.modifyreq.gender=[NSNumber numberWithInt:2];
        [[BeeUserDefaults sharedInstance] setObject:[NSNumber numberWithInt:2] forKey:@"gender"];
    }
    else if (button.tag==115105 || button.tag==115106)
    {
        UIButton *male=(UIButton *)[genderSelectView viewWithTag:115101];
        [male setImage:[UIImage bundleImageNamed:WEIDIANXUAN] forState:UIControlStateNormal];
        UIButton *female=(UIButton *)[genderSelectView viewWithTag:115103];
        [female setImage:[UIImage bundleImageNamed:WEIDIANXUAN] forState:UIControlStateNormal];
        UIButton *nogender=(UIButton *)[genderSelectView viewWithTag:115105];
        [nogender setImage:[UIImage bundleImageNamed:DIANXUANICON] forState:UIControlStateNormal];
//        self.modifyreq.gender=[NSNumber numberWithInt:0];
        [[BeeUserDefaults sharedInstance] setObject:[NSNumber numberWithInt:0] forKey:@"gender"];
    }
}

-(void)setModifyreq:(REQ_MODIFYPROFILE_SHOTS *)modifyreq
{
    if (modifyreq!=_modifyreq) {
        _modifyreq=modifyreq;
    }
}


-(void)addGenderItem:(UIView *)bgview btnframe:(CGRect)btnframe andlabelframe:(CGRect)labelframe imgname:(NSString *)imgname gender:(NSString *)gender tag:(int)tag target:(SEL)target
{
    UIButton *malebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [malebtn setImage:[UIImage bundleImageNamed:imgname] forState:UIControlStateNormal];
//    [malebtn setBackgroundImage:[UIImage bundleImageNamed:imgname] forState:UIControlStateNormal];
    malebtn.frame=btnframe;
    malebtn.tag=tag;
    [bgview addSubview:malebtn];
    
    UIButton *label=[UIButton buttonWithType:UIButtonTypeCustom];
    [label setTitle:gender forState:UIControlStateNormal];
    [label setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    label.frame=labelframe;
    label.tag=tag+1;
    [bgview addSubview:label];
    
    [malebtn addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    [label addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    NSLog(@"%d", (int)buttonIndex);
    [self selectpicture:nil andclickedButtonAtIndex:(int)buttonIndex];
}

- (void)didClickOnDestructiveButton
{
    NSLog(@"destructuctive");
}

- (void)didClickOnCancelButton
{
    NSLog(@"cancelButton");
}

#pragma mark - 选择头像
-(void)selectpicture:(UIActionSheet *)actionSheet andclickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 2:
                // 取消
                return;
            case 0:
                // 相机
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
                HBImagePickerControllerEx *m_imagePicker = [[HBImagePickerControllerEx alloc] init];
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    m_imagePicker.sourceType = sourceType; //UIImagePickerControllerSourceTypePhotoLibrary;
                    [m_imagePicker setDelegate:self];
                    [m_imagePicker setAllowsEditing:YES];
                    
                    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
                    [self presentViewController:m_imagePicker animated:YES completion:^{}];
                    break;
                    return;
                }
            }
            case 1:
                // 相册
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                HBImagePickerControllerEx *picker = [[HBImagePickerControllerEx alloc] init];
                picker.delegate = self;
                [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
                [self presentViewController:picker animated:YES completion:^{}];
            }
        }
    }
    else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            HBImagePickerControllerEx *m_imagePicker = [[HBImagePickerControllerEx alloc] init];
            if ([HBImagePickerControllerEx isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypePhotoLibrary]) {
                m_imagePicker.sourceType = sourceType; //UIImagePickerControllerSourceTypePhotoLibrary;
                [m_imagePicker setDelegate:self];
                [m_imagePicker setAllowsEditing:YES];
                [self presentViewController:m_imagePicker animated:YES completion:^{}];
            }
        }
    }
}



#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:@"public.image"]){
            [self handleCanmearInfo:info];
        }
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [self handleAblumInfo:info];
    }
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)handleAblumInfo:(NSDictionary *)info
{
    //    BeeLog(@"%@",self.fastTextView.attributedText);
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        NSString *fileName = [representation filename];
        NSLog(@"fileName : %@",fileName);
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        SEPhotoView *photoView = [[SEPhotoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
        CGImageRef iref = [representation fullResolutionImage];
        if (iref) {
            photoView.image = image;
            self.imgavtor.image=image;
        }
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
}
-(void)handleCanmearInfo:(NSDictionary *)info
{
    NSData *data;
    //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片压缩，因为原图都是很大的，不必要传原图
    UIImage *scaleImage = [HBImagePickerControllerEx scaleImage:originImage toScale:0.5];
    
    //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
    if (UIImagePNGRepresentation(scaleImage) == nil) {
        //将图片转换为JPG格式的二进制数据
        data = UIImageJPEGRepresentation(scaleImage, 0.5);
    } else {
        //将图片转换为PNG格式的二进制数据
        data = UIImagePNGRepresentation(scaleImage);
    } //        //将二进制数据生成UIImage
    UIImage *image = [UIImage imageWithData:data];
    
    UIImageWriteToSavedPhotosAlbum(image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    SEPhotoView *photoView = [[SEPhotoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
//    photoView.image = image;
//    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[[NSDate date] stringWithDateFormat:@"yyyy_MM_dd_HH_MM_SS"]];
    self.imgavtor.image=image;
//    self.fastTextView.addobj_name=fileName;
//    self.fastTextView.addobj_type=@"1";
//    [self.fastTextView insertObject:photoView size:photoView.bounds.size];
    [self dismissViewControllerAnimated:YES completion:NULL];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
}

#pragma mark - MaskViewDelegate

- (void)MaskViewDidTaped:(id)object
{
    [_cityselector cancel:nil];
    [_brithdaySelector cancel:nil];
    [maskView hiddenMask];
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
