//
//  D2_Feedback.m
//  DZ
//
//  Created by user on 14-5-26.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_Feedback.h"
#import "AppBoard_iPhone.h"
#import "Bee.h"
#import "FeedbackModel.h"
#import <QuartzCore/QuartzCore.h>
#import "UITextView_Boarder.h"
#import "DZ_UITextField.h"
@interface D2_Feedback ()
{
    UITextField *qqText;
}

@end

@implementation D2_Feedback

@synthesize appId       = _appId;
@synthesize appVersion  = _appVersion;
@synthesize content     = _content;
@synthesize QQ          = _QQ;

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

    [self setNavigationBarTitle:@"用户反馈"];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    self.feedbackModel = [FeedbackModel modelWithObserver:self];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBarRight = submit;

    feedbackText = [[UITextView_Boarder alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    feedbackText.backgroundColor = [UIColor whiteColor];
    feedbackText.delegate = self;
    feedbackText.scrollEnabled = YES;
//    feedbackText.text = @"123";
    feedbackText.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:feedbackText];
    
    feedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(feedbackText.frame)-10, 50)];
    feedbackLabel.text = @"请输入您宝贵的意见，您的意见是我们前进的动力哦！";
    feedbackLabel.textColor = PLACEHOLDERCOLOR; //[UIColor colorWithRed:201./255 green:201./255 blue:201./255 alpha:1];
//    feedbackLabel.enabled = YES;
    feedbackLabel.backgroundColor = [UIColor clearColor];
    feedbackLabel.font = [UIFont systemFontOfSize:14];
    feedbackLabel.lineBreakMode = UILineBreakModeWordWrap;  //自动换行
    feedbackLabel.numberOfLines = 0;
    [feedbackText addSubview:feedbackLabel];
 
    qqText = [[DZ_UITextField alloc] initWithFrame:CGRectMake(10, 230, 300, 40)];
    qqText.placeholder = @"为了更好沟通，请留下您的QQ联系方式（选填）";
    qqText.font = [UIFont systemFontOfSize:13];
    qqText.backgroundColor = [UIColor whiteColor];
    qqText.layer.borderColor = LINE_LAYERBOARDCOLOR;//[UIColor colorWithWhite:0.8 alpha:1].CGColor;
    qqText.layer.borderWidth = LINE_LAYERBOARDWIDTH;
    qqText.layer.cornerRadius = 0.0f;
//    [qqText.layer setMasksToBounds:YES];
    qqText.delegate = self;
    [self.view addSubview:qqText];
}

-(void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}

#pragma mark - BeeFramework Macro

ON_SIGNAL3(FeedbackModel, FEEDBACK_RELOADING, signal)
{
    [self dismissTips];
     [self presentLoadingTips:@"正在反馈..."];
    NSLog(@"123312");
}

ON_SIGNAL3(FeedbackModel, FEEDBACK_RELOADED, signal)
{
    [self dismissTips];
    BeeUITipsView *tips = [self presentMessageTips:@"反馈成功"];
    tips.tag = 1830;

    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:YES];
    });
}

ON_SIGNAL3(FeedbackModel, FEEDBACK_FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:@"反馈失败，请重试"];
}

ON_SIGNAL3(BeeUITipsView, WILL_DISAPPEAR, signal)
{
    if (signal.sourceView.tag == 1830) {
        [self.navigationController  popViewControllerAnimated:YES];
    }
}
#pragma mark - Event

- (void)submit
{
    feedbackText.text = feedbackText.text.trim;
    NSLog(@"提交");
    if (feedbackText.text.length == 0 || feedbackText.text == nil) {
//        UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"请输入您的意见"
//                                                         message:nil
//                                                        delegate:nil
//                                               cancelButtonTitle:@"确定"
//                                               otherButtonTitles:nil];
//        [prompt show];
        [self presentMessageTips:@"请输入您的意见"];
        return;
    } else {
        self.feedbackModel.appId = self.appId;
        self.feedbackModel.appVersion = self.appVersion;
        self.feedbackModel.content = feedbackText.text;
        self.feedbackModel.QQ = qqText.text;
        NSLog(@"%@", feedbackText.text);
        NSLog(@"%@", qqText.text);
        NSLog(@"%@", self.feedbackModel.content);
        NSLog(@"%@", self.feedbackModel.QQ);

        if (![qqText.text isQQ]) {
            [self presentMessageTips:@"请输入正确的QQ"];
            return;
        }
        [self.feedbackModel feedback];
    }
}

#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0 || textView.text == nil) {
        feedbackLabel.text = @"请输入您宝贵的意见，您的意见是我们前进的动力哦！";
    } else {
        feedbackLabel.text = nil;
    }
//    [feedbackText sizeToFit];
}

//点击 UITextView 输入文字时，光标都从最初点开始（光标一直在前面）
//-(void)textViewDidChangeSelection:(UITextView*)textView
//{
//    NSRange range;
//    range.location = 0;
//    range.length = 0;
//    textView.selectedRange = range;
//}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.80f;
    CGRect frame = self.view.frame;
    frame.origin.y -= 50;
    frame.size.height += 50;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];

    /*
     //动画不用block
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.5];
     [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
     forView:containerView cache:YES];
     [containerView addSubview:subview];
     [UIView commitAnimations];

     //动画用block
     [UIView transitionWithView:containerView duration:0.5
     options:UIViewAnimationOptionTransitionCurlDown
     animations:^ { [containerView addSubview:subview]; }
     completion:nil];
     */
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.8f;
    CGRect frame = self.view.frame;
    frame.origin.y += 50;
    frame.size.height -= 50;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
