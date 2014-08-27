//
//  D1_FriendsInteractTableViewCell.m
//  DZ
//
//  Created by Nonato on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "ToolsFunc.h"
#import "D1_FriendsInteractTableViewCell.h"

@implementation D1_FriendsInteractTableViewCell

+(float)heightOfD1_FriendsInteractTableViewCell
{
    return 60;
}

-(void)dataChange:(automatic *)matic
{
    
    matic.note = [matic.note stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    self.lbltitle.text=[NSString stringWithFormat:@"%@",matic.note];
    self.lbltime.text=[NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:[NSString stringWithFormat:@"%@",matic.dateline]]];
    self.atopic = matic;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addbackgroundView:nil];
        // Initialization code
        float CELLICONWITH=50; 
        _lbltitle=[[UILabel alloc] init];
        int TITLEHEIGHT=20;
        CGRect rect= CGRectMake(10, 10, self.frame.size.width- CELLICONWITH, TITLEHEIGHT);
        KT_LABELEWIFRAM(_lbltitle,rect, @"", 15,[UIColor clearColor] , [UIColor blackColor], NSTextAlignmentLeft,YES)
        [self addSubview:_lbltitle];
        
        UIButton *addfriendbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addfriendbtn setTitle:@"添加" forState:UIControlStateNormal];
        [addfriendbtn addTarget:self action:@selector(addfriendBtnTap) forControlEvents:UIControlEventTouchUpInside];
         UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
        addfriendbtn.backgroundColor = color;
        addfriendbtn.frame = CGRectMake(self.frame.size.width - CELLICONWITH -10, 10, CELLICONWITH, 30);
        [self addSubview:addfriendbtn];
        
        
        float LABELHEIGHT=20;
        float MARGELEFT=10;
        int  labelFontSize=12;
        UILabel *lzhu=[[UILabel alloc] init];
        lzhu.tag=1410;
        
        //回复的时间
        _lbltime=[[UILabel alloc] init];
        CGRect lbltimeframe=CGRectMake(MARGELEFT,TITLEHEIGHT + 10,150, LABELHEIGHT);
        KT_LABELEWIFRAM(_lbltime,lbltimeframe, @"14:47:57", labelFontSize,[UIColor clearColor] , [UIColor grayColor], NSTextAlignmentLeft,NO)
        [self addSubview:_lbltime];
        
    }
    return self;
}

-(void)addfriendBtnTap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addFriend:)]) {
        [self.delegate addFriend:self];
    }
}
-(void)datachange:(id)object
{
    [super datachange:object];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
