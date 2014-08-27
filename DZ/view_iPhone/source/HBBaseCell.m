//
//  HBBaseCell.m
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "HBBaseCell.h"

@implementation HBBaseCell

@synthesize leftlabel;
@synthesize rightlabel;

DEF_SIGNAL(cellSelected)
DEF_SIGNAL(ABOUTUS)

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        bgview.backgroundColor=[UIColor whiteColor];
        [self addSubview:bgview];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 320, 60);
        [button addTarget:self action:@selector(cellButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        leftlabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 30)];
        leftlabel.backgroundColor = [UIColor clearColor];
        leftlabel.textAlignment = NSTextAlignmentLeft;
        leftlabel.text = @"";
        leftlabel.textColor = [UIColor blackColor];
        leftlabel.font = [UIFont systemFontOfSize:13];

        [self addSubview:leftlabel];
        
        rightlabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, 100, 30)];
        rightlabel.backgroundColor = [UIColor clearColor];
        rightlabel.textAlignment = NSTextAlignmentRight;
        rightlabel.text = @"";
        rightlabel.textColor = [UIColor blackColor];
        rightlabel.font = [UIFont systemFontOfSize:13];

        [self addSubview:rightlabel];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(25, 50, 270, 1)];
//        line.backgroundColor = [UIColor colorWithRed:226/255 green:226/255 blue:226/255 alpha:0.2];
//        [self addSubview:line];
    }
    return self;
}
-(void)dataDidChanged
{
    
}
-(IBAction)cellButtonTap:(id)sender
{
    [self sendUISignal:self.cellSelected];
    [self sendUISignal:self.ABOUTUS];
}

@end
