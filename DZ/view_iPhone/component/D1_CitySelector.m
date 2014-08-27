//
//  D1_CitySelector.m
//  DZ
//
//  Created by Nonato on 14-5-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_CitySelector.h"
//#define kDuration 0.3

@implementation LocationCity
@synthesize provice;
@synthesize city;

-(id)init
{
    self=[super init];
    if (self) {
        provice=@"北京市";
        city=@"东城区";
    }
    return self;
}


@end
@implementation D1_CitySelector
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
    self.titlelabel.center=CGPointMake(320.0/2, 21);
    self.titlelabel.backgroundColor = [UIColor clearColor];
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
        self.locate=[[LocationCity alloc] init];
        
        
        /*        self.fmModel=[ForumlistModel modelWithObserver:self];
         [self.fmModel loadCache];
         [self.fmModel firstPage];
         
         self.forumAry=self.fmModel.shots;
         forums *aforum=[self.forumAry objectAtIndex:0];
         self.childAry=aforum.child;*/        
        self.distrctModel=[DistrictsModel modelWithObserver:self];
        [self.distrctModel loadCache];
        [self.distrctModel firstPage];
        if (self.distrctModel.shots.count) {
            self.firstLevelAry=self.distrctModel.shots;
            districts *aforum=[self.firstLevelAry objectAtIndex:0];
            self.secondLevelAry=[NSMutableArray arrayWithArray:aforum.child];            
        }
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

ON_SIGNAL3(DistrictsModel, RELOADED, signal)
{
    BeeLog(@"%@",self.distrctModel);
    self.firstLevelAry=self.distrctModel.shots;
    districts *aforum=[_firstLevelAry objectAtIndex:0];
    self.secondLevelAry=[NSMutableArray arrayWithArray:aforum.child];
    [self.locatePicker reloadComponent:1];
}
#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
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
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            districts *adis =[self.firstLevelAry objectAtIndex:row];
            return adis.name;
            break;
        }
        case 1:
        {
             dis_child *achild=[self.secondLevelAry objectAtIndex:row];
            return achild.name;
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
            districts *item=[_firstLevelAry objectAtIndex:row];
            self.secondLevelAry=(NSMutableArray *)item.child;
            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
            [self.locatePicker reloadComponent:1];
            dis_child *achild=[self.secondLevelAry objectAtIndex:0];
            self.locate.dis_childcls=achild;
            self.locate.city=achild.name;
            self.locate.provice=item.name;
            break;
        }
        case 1:
        {
            dis_child *achild=[self.secondLevelAry objectAtIndex:row];
            self.locate.dis_childcls=achild;
            self.locate.city=achild.name;
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
    [self sendUISignal:self.DIDHIDE];
}

-(void)showInView:(UIView *)view Provicename:(NSString *)Provicename cityname:(NSString *)cityname
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
        
    int proviceindex=[self.distrctModel proviceIndexForname:Provicename];
    int cityindex=[self.distrctModel CityIndexForProvicename:Provicename andChildname:cityname];    
    if (proviceindex != NSNotFound && cityindex != NSNotFound) {
        [self.locatePicker selectRow:proviceindex inComponent:0 animated:YES];
        [self.locatePicker selectRow:cityindex inComponent:1 animated:YES];
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

@end
