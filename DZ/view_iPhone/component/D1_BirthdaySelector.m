//
//  D1_BirthdaySelector.m
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_BirthdaySelector.h"
#import "Bee.h"
//#define kDuration 0.3

@implementation BirthYearMonth
@synthesize year;
@synthesize month;
@synthesize day;

-(id)init
{
    self=[super init];
    if (self) {
        year=@"2014";
        month=@"1";
        day=@"1";
    }
    return self;
}
@end


@implementation D1_BirthdaySelector
DEF_SIGNAL(DIDSHOW)
DEF_SIGNAL(DIDHIDE)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    //    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    self = [super initWithFrame:CGRectMake(0, 0, 320, 260)];
    
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgview.image=[UIImage imageNamed:@"bg_023"];
    [self addSubview:imgview];
    
    self.frame=CGRectMake(0, 0, 320, 260);
    self.titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 11, 320, 21)];
    self.titlelabel.textColor=[UIColor whiteColor];
    self.titlelabel.backgroundColor = [UIColor clearColor];
    self.titlelabel.center=CGPointMake(320.0/2, 21);
    self.titlelabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.titlelabel];
    /*
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setImage:[UIImage bundleImageNamed:@"btn_021"] forState:UIControlStateNormal];
    leftbtn.frame=CGRectMake(10, 1, 42, 42);
    [leftbtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftbtn];
    */
    UIButton *rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setImage:[UIImage imageNamed:@"btn_020"] forState:UIControlStateNormal];
    rightbtn.frame=CGRectMake(277, 1, 42, 42);
    [rightbtn addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightbtn];
    
    self.locatePicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
    
    [self addSubview:self.locatePicker];
    
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.delegate = delegate;
        self.titlelabel.text = title;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        self.locate=[[BirthYearMonth alloc] init];
        NSMutableArray *year=[[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 2014; i >= 1920; i--) {
            [year addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.firstLevelAry=year;
        
        NSMutableArray *month=[[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 1; i <= 12; i++) {
            [month addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.secondLevelAry=month;
/*        self.fmModel=[ForumlistModel modelWithObserver:self];
        [self.fmModel loadCache];
        [self.fmModel firstPage];
        
        self.forumAry=self.fmModel.shots;
        forums *aforum=[self.forumAry objectAtIndex:0];
        self.childAry=aforum.child;*/

        NSMutableArray *day = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 1; i <= 31; i++) {
            [day addObject:[NSString stringWithFormat:@"%d", i]];
        }
        self.thirdLevelAry = day;
    }
    return self;
}
/*
ON_SIGNAL3(ForumlistModel, RELOADED, signal)
{
    BeeLog(@"%@",self.fmModel);
    self.forumAry=self.fmModel.shots;
    forums *aforum=[_forumAry objectAtIndex:0];
    self.childAry=aforum.child;
    [self.locatePicker reloadComponent:1];
}*/

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.firstLevelAry count];
            break;
        case 1:
        {
            return [self.secondLevelAry count];
            break;
        }
        case 2:
            return [self.thirdLevelAry count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            NSString *name=[self.firstLevelAry objectAtIndex:row];
            return name;
            break;
        }
        case 1:
        {
            NSString *achild=[self.secondLevelAry objectAtIndex:row];
            return achild;
            break;
        }
        case 2:
        {
            NSString *achild = [self.thirdLevelAry objectAtIndex:row];
            return achild;
            break;
        }
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
//            NSString *item=[_firstLevelAry objectAtIndex:row];
//            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
//            [self.locatePicker reloadComponent:1];
//             self.locate.month = [self.secondLevelAry objectAtIndex:0];
//             self.locate.year = item;
            self.locate.year = [self.firstLevelAry objectAtIndex:row];
            break;
        }
        case 1:
        {
            self.locate.month=[self.secondLevelAry objectAtIndex:row];
            break;
        }
        case 2:
        {
            self.locate.day = [self.thirdLevelAry objectAtIndex:row];
            break;
        }
        default:
            break;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
}


-(IBAction)locate:(id)sender
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    [self sendUISignal:self.DIDHIDE];
}

-(IBAction)cancel:(id)sender
{    
    [self sendUISignal:self.DIDHIDE];
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}
-(void)showInView:(UIView *)view YearMonth:(NSString *)Year_Month
{
    //- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    NSArray *componts=[Year_Month componentsSeparatedByString:@"-"];
    if (componts.count==2) {
        NSString *year=[componts objectAtIndex:0];
        NSString *month=[componts objectAtIndex:1];
        int yearindex=[self.firstLevelAry indexOfObject:year];
        int monthindex=[self.secondLevelAry indexOfObject:[NSString stringWithFormat:@"%d",month.intValue]];
        if (yearindex!=NSNotFound && monthindex!=NSNotFound) {
            self.locate.year=year;
            self.locate.month=month;
            [self.locatePicker selectRow:yearindex inComponent:0 animated:YES];
            [self.locatePicker selectRow:monthindex inComponent:1 animated:YES];             
        }
    }
    
    [self sendUISignal:self.DIDSHOW];
}


- (void)showInView:(UIView *) view
{
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
    [self sendUISignal:self.DIDSHOW];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
