//
//  B4_PreviewImageViewController.m
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B4_PreviewImageViewController.h"

@interface B4_PreviewImageViewController ()<UIGestureRecognizerDelegate>
{
    UIScrollView *scrollview;
}
@end

@implementation B4_PreviewImageViewController

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
    self.view.backgroundColor=[UIColor blackColor];
    scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 320, 450)];
    [self.view addSubview:scrollview];
    scrollview.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    BeeUIImageView *imgview=[[BeeUIImageView alloc] initWithFrame:CGRectMake(0, 5, 300, 480)];
    imgview.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    imgview.enableAllEvents=YES;
    imgview.clipsToBounds=NO;
    imgview.contentMode = UIViewContentModeScaleAspectFill;
    
//    imgview.contentMode = UIViewContentModeScaleAspectFit;
//    imgview.autoresizesSubviews = YES;
//    imgview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [scrollview addSubview:imgview];
    self.imgview=imgview;
 
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [imgview addGestureRecognizer:tapGestureRecognizer];
    
    
    UIButton *closebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closebtn.frame=CGRectMake(10, 20, 50, 40);
    [closebtn addTarget:self action:@selector(gestureRecognizerHandle:) forControlEvents:UIControlEventTouchUpInside];// :self action:@selector(gestureRecognizerHandle:)];
    [closebtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:closebtn];
}
/*
 LOAD_START )			// 加载开始
 AS_SIGNAL( LOAD_COMPLETED )		// 加载完成
 AS_SIGNAL( LOAD_FAILED )		// 加载失败
 AS_SIGNAL( LOAD_CANCELLED )		// 加载取消
 AS_SIGNAL( LOAD_CACHE
 */
ON_SIGNAL3(BeeUIImageView, LOAD_START, signal)
{
    [self presentLoadingTips:@""];
}

ON_SIGNAL3(BeeUIImageView, LOAD_FAILED, signal)
{
    [self dismissTips];
}

ON_SIGNAL3(BeeUIImageView, LOAD_COMPLETED, signal)
{
    [self dismissTips];
    CGFloat capWidth = _imgview.image.size.width ;
    CGFloat capHeight = _imgview.image.size.height;
    self.imgview.frame=CGRectMake(0, 0, capWidth, capHeight);
    self.imgview.center=CGPointMake(capWidth/2, capHeight/2);
    if (scrollview.contentSize.width < capWidth) {
        scrollview.contentSize=CGSizeMake(capWidth, capHeight);
    }
}
ON_SIGNAL3(BeeUIImageView, LOAD_CACHE, signal)
{
     CGFloat capWidth = _imgview.image.size.width ;
     CGFloat capHeight = _imgview.image.size.height;
    self.imgview.frame=CGRectMake(0, 0, capWidth, capHeight);
    
    self.imgview.center=CGPointMake(capWidth/2, capHeight/2);
    if (scrollview.contentSize.width < capWidth) {
        scrollview.contentSize=CGSizeMake(capWidth, capHeight);
    }
}
-(IBAction)gestureRecognizerHandle:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
