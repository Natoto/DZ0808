//
//  C0_HairPost_SelectPlates.m
//  DZ
//
//  Created by Nonato on 14-5-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "Bee.h"
#import "C0_HairPost_SelectPlates.h"
//#define kDuration 0.3
@implementation LoacateChild
@synthesize parent;
@synthesize child;
@end


#define HAIRPOSTTITAG 104452
@implementation C0_HairPost_SelectPlates

//@synthesize titleLabel;
//@synthesize locatePicker;
//@synthesize childAry;
//@synthesize forumAry;

#warning 给这个UIPickerView一个默认值
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
    [self addSubview:leftbtn];*/
    
    UIButton *rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setImage:[UIImage imageNamed:@"btn_020"] forState:UIControlStateNormal];
    rightbtn.frame=CGRectMake(277, 1, 42, 42);
    [rightbtn addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightbtn];
    
    self.locatePicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
 
    self.locate=[[LoacateChild alloc] init];
    [self addSubview:self.locatePicker];
    
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.delegate = delegate;
        self.titlelabel.text = title;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        self.fmModel=[ForumlistModel modelWithObserver:self];
        [self.fmModel loadCache];
        [self.fmModel firstPage];
        
        self.forumAry=self.fmModel.shots;
        if (self.forumAry.count) {
            forums *aforum=[self.forumAry objectAtIndex:0];
            self.childAry=aforum.child;
//            [self performSelector:@selector(initSelection) withObject:nil afterDelay:0.2];
        }
        forums *aforum=[self.childAry objectAtIndex:0];
        if (aforum.child.count) {
            self.subchildAry=aforum.child;
        }
     }
    return self;
}
-(void)initSelection
{ 
    [self pickerView:self.locatePicker didSelectRow:0 inComponent:0];
    [self pickerView:self.locatePicker didSelectRow:0 inComponent:1];
}
ON_SIGNAL3(ForumlistModel, RELOADED, signal)
{
    BeeLog(@"%@",self.fmModel);
    self.forumAry=self.fmModel.shots;
    forums *aforum=[_forumAry objectAtIndex:0];
    self.childAry=aforum.child;
    [self.locatePicker reloadComponent:0];
    
    forums *achile = [self.childAry objectAtIndex:0];
    if ([[achile class] isSubclassOfClass:[forums class]] && achile.child.count) {
        self.subchildAry = [self readsubchildAry:achile.child];
        [self.locatePicker reloadComponent:2];
    }
    
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
        return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_forumAry count];
            break;
        case 1:
        { 
            return [_childAry count];
            break;
        }
        case 2:
        {
            return [_subchildAry count];
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
            forums *aforums=[_forumAry objectAtIndex:row];
            return aforums.name;
            break;
        }
        case 1:
        {
            forums *achild=[_childAry objectAtIndex:row];
            return achild.name;
            break;
        }
        case 2:
        {
            child *achild=[_subchildAry objectAtIndex:row];
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
             forums *aforums=[_forumAry objectAtIndex:row];
            _childAry =aforums.child;  //[[aforums.child objectAtIndex:row] objectForKey:@"Cities"];
            [self.locatePicker reloadComponent:1];
            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
            self.locate.child=[_childAry objectAtIndex:0];
            self.locate.parent=aforums;
            
            if ([[self.locate.child.child class] isSubclassOfClass:[NSArray class]] && self.locate.child.child.count) {
                if ([[self.locate.child class]  isSubclassOfClass:[self.locate.child class]] && self.locate.child.child.count) {
                    self.subchildAry = [self readsubchildAry:self.locate.child.child];// self.locate.child.child;
                     self.locate.subchild = [self.subchildAry objectAtIndex:0];
                }
                else
                {
                    self.subchildAry = nil;
                    self.locate.subchild = nil;
                }
            }
            else
            {
                self.locate.subchild = nil;
                self.subchildAry = nil;
            }
            [self.locatePicker reloadComponent:1];
            [self.locatePicker reloadComponent:2];
            [self.locatePicker selectRow:0 inComponent:1 animated:YES];
            break;
        }
        case 1:
        {
            if (!self.locate.parent) {
                forums *aforums=[_forumAry objectAtIndex:0];
                _childAry =aforums.child;
                self.locate.parent = aforums;
            }
            self.locate.child =[_childAry objectAtIndex:row];
            if ([[self.locate.child.child class]  isSubclassOfClass:[NSArray class]] && self.locate.child.child.count) {
                self.subchildAry = [self readsubchildAry:self.locate.child.child];// self.locate.child.child;
                self.locate.subchild = [self.subchildAry objectAtIndex:0];                
                [self.locatePicker reloadComponent:2];
            }
            else
            {
                self.locate.subchild = nil;
                self.subchildAry = nil;
            }
            [self.locatePicker reloadComponent:2];
            [self.locatePicker selectRow:0 inComponent:2 animated:YES];
            break;
        }
        case 2:
        {
            self.locate.subchild = [_subchildAry objectAtIndex:row];
            break;
        }
        default:
            break;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
}

-(NSArray *)readsubchildAry:(NSArray *)dic
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for(int index = 0 ;index< dic.count;index ++ )
    {
        NSDictionary * aforumsdic = [dic objectAtIndex:index];
        forums *aforums = [forums objectFromDictionary:(NSDictionary *)aforumsdic];
        [array addObject:aforums];
    }
    return array;
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

}
-(void)resignFirstResponder
{
    [self cancel:nil];
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
    UIView *aview =[view viewWithTag:HAIRPOSTTITAG];
    if (!aview) {
        [view addSubview:self];
    }
    [view addSubview:self];
    //第一次显示默认选择
    if (!self.locate.child && !self.locate.parent) {
        if (self.forumAry.count) {
            [self initSelection];
        }
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
