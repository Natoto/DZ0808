//
//  TopicTableViewCell.m
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "TopicTableViewCell.h"

@implementation TopicTableViewCell
-(void)isOwner:(BOOL)owner
{
    UILabel *lzhu=(UILabel *)[self viewWithTag:1410];
    lzhu.hidden=owner;
    _lbllandlord.hidden=owner;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        float CELLICONHEIGHT=70;
        float CELLICONWITH=50;
        
        UIImageView *bgimgview=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, 90)];
        bgimgview.backgroundColor=[UIColor whiteColor];
        [self addSubview:bgimgview];
        _cellicon=[[BeeUIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-CELLICONWITH-10, 10, CELLICONWITH,CELLICONHEIGHT)];
        _cellicon.backgroundColor=[UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1];
        _cellicon.contentMode=UIViewContentModeScaleAspectFill;
        
        _cellicon.indicatorColor=[UIColor whiteColor];
        [self addSubview:_cellicon];
        
        _lbltitle=[[UILabel alloc] init];
        int TITLEHEIGHT=40;
        int MARGINV=0;
        CGRect rect= CGRectMake(5, 0, self.frame.size.width-60, TITLEHEIGHT);
        KT_LABELEWIFRAM(_lbltitle,rect, @"主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题", 15,[UIColor clearColor] , [UIColor blackColor], NSTextAlignmentLeft,YES)
        [self addSubview:_lbltitle];
        
        
        float LABELHEIGHT=20;
        float MARGELEFT=5;
        int  labelFontSize=10;
        
        UILabel *lzhu=[[UILabel alloc] init];
        lzhu.tag=1410;
        CGRect louzhuframe=CGRectMake(MARGELEFT, TITLEHEIGHT + MARGINV, 30, LABELHEIGHT);
        KT_LABELEWIFRAM(lzhu,louzhuframe, @"楼主:", labelFontSize,[UIColor clearColor] , [UIColor grayColor], NSTextAlignmentRight,NO)
        [self addSubview:lzhu];
        
        _lbllandlord=[[UILabel alloc] init];//楼主
        CGRect ldrect=CGRectMake(MARGELEFT + 30 , TITLEHEIGHT + MARGINV, 40, LABELHEIGHT);
        KT_LABELEWIFRAM(_lbllandlord,ldrect, @"bobo", labelFontSize,[UIColor clearColor] , [UIColor grayColor], NSTextAlignmentLeft,NO)
        [self addSubview:_lbllandlord];
        
        _lblreadl=[[UILabel alloc] init];//查看
        CGRect readrect= CGRectMake(self.frame.size.width-CELLICONWITH-5-40, MARGINV + TITLEHEIGHT, 40, LABELHEIGHT);
        KT_LABELEWIFRAM(_lblreadl,readrect, @"100", labelFontSize,[UIColor clearColor] , [UIColor grayColor], NSTextAlignmentLeft,NO)
        [self addSubview:_lblreadl];
        
        UILabel *chakan=[[UILabel alloc] init];
        CGRect chakanframe=CGRectMake(self.frame.size.width-CELLICONWITH-5-30-40, TITLEHEIGHT + MARGINV, 30, LABELHEIGHT);
        KT_LABELEWIFRAM(chakan,chakanframe, @"查看:", labelFontSize,[UIColor clearColor] , [UIColor grayColor], NSTextAlignmentRight,NO)
        [self addSubview:chakan];
        
        //回复
        UILabel *reply=[[UILabel alloc] init];
        CGRect replyframe=CGRectMake(MARGELEFT, TITLEHEIGHT + MARGINV+ LABELHEIGHT, 30, LABELHEIGHT);
        KT_LABELEWIFRAM(reply,replyframe, @"回复:", labelFontSize,[UIColor clearColor] , [UIColor grayColor], NSTextAlignmentRight,NO)
        [self addSubview:reply];
        _lblreply=[[UILabel alloc] init];
        CGRect lblreplyframe=CGRectMake(MARGELEFT+30, TITLEHEIGHT + MARGINV + LABELHEIGHT,30 , LABELHEIGHT);
        KT_LABELEWIFRAM(_lblreply,lblreplyframe, @"20", labelFontSize,[UIColor clearColor] , [UIColor grayColor], NSTextAlignmentLeft,NO)
        [self addSubview:_lblreply];
        
        //回复的时间
        _lbltime=[[UILabel alloc] init];
        CGRect lbltimeframe=CGRectMake(290-200-CELLICONWITH,TITLEHEIGHT+MARGINV+LABELHEIGHT,200, LABELHEIGHT);
        KT_LABELEWIFRAM(_lbltime,lbltimeframe, @"14:47:57", labelFontSize,[UIColor clearColor] , [UIColor grayColor], NSTextAlignmentRight,NO)
        [self addSubview:_lbltime];
    }
    return self;
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
