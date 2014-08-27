//
//  C0_ZhuTi_SelectPlates.m
//  DZ
//
//  Created by Nonato on 14-7-25.
//
//
#import "Bee.h"
#import "C0_ZhuTi_SelectPlates.h"
#import "ForumlistModel.h"
#define ZHUTITAG 104303
@implementation THTPS_SELECT
@end

@implementation C0_ZhuTi_SelectPlates
- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 260)];
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgview.image=[UIImage imageNamed:@"bg_023"];
    [self addSubview:imgview];
    self.tag = ZHUTITAG;
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

    self.locate=[[THTPS_SELECT alloc] init];
    [self addSubview:self.locatePicker];

    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.delegate = delegate;
        self.titlelabel.text = title;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
       
    }
    return self;
}
-(void)setArray:(NSArray *)array
{
    _array = array;
    [self.locatePicker reloadAllComponents];
}
-(void)initSelection
{
    [self pickerView:self.locatePicker didSelectRow:0 inComponent:0];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
     return [_array count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   NSString *name =[_array objectAtIndex:row];
    return name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            NSString *aforums=[_array objectAtIndex:row];
            self.locate.threadtypesitem = aforums;
            self.locate.typedid = [NSNumber numberWithInt:(row +1)];
//            self.locate.athreadtypes = self.athreadtypes;
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
//    if (self.show ==YES) {
//        return;
//    }
//    self.show = YES;
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    UIView *aview =[view viewWithTag:ZHUTITAG];
    if (!aview) {
        [view addSubview:self];
    }
    //第一次显示默认选择
    if (!self.locate.threadtypesitem) {
        if (self.array.count) {
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


@end
