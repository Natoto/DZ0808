//
//  D2_Setting_Nightmode_Cell.m
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_Setting_Nightmode_Cell.h"

@implementation D2_Setting_Nightmode_Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=@"夜间模式";
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:13];
        [self addSubview:label];
        switcher=[[BeeUISwitch alloc] init];
        switcher.center=CGPointMake(280, 30);
        switcher.on=NO;
        [self addSubview:switcher]; 
        // #333 0.1;
    }
    return self;
}

ON_SIGNAL2(BeeUISwitch, signal)
{
    BOOL tyes=(BOOL)signal.sourceCell.data;
    if ([signal is:BeeUISwitch.STATE_CHANGED]) {
        BeeLog(@"状态改变了");
    }
}

-(void)dataDidChanged
{
    BOOL ison=[self.data boolValue];
    switcher.on=ison;
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
