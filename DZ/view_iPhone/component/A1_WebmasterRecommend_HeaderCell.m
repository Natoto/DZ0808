//
//  A1_WebmasterRecommend_HeaderCell.m
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "A1_WebmasterRecommend_HeaderCell.h"
#import "Constants.h"
#import "SettingModel.h"

#define   CELLICONHEIGHT 75
#define   CELLICONWITH   CELLICONHEIGHT

@implementation A1_WebmasterRecommend_HeaderCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addbackgroundView:nil];
        BeeUIImageView * ImgeView=[[BeeUIImageView alloc] initWithFrame:CGRectMake(15, 10, 290, 150)];
        ImgeView.backgroundColor=[UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1];
        ImgeView.contentMode = UIViewContentModeScaleAspectFill;
        self.ImgeView=ImgeView;
       [self addSubview:ImgeView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 160, 280, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"标题";
        label.font = [UIFont systemFontOfSize:16];
        self.label = label;
        [self addSubview:label];

#warning change
        //帖子标题
        _lbltitle = [[UILabel alloc] init];
        int MARGINV = 5;
        float LABELHEIGHT = 20;
        int  labelFontSize = 12;
        int TITLEHEIGHT = 30;
        float YOUTUY = 68;
        float CKPLWIDTH = 30;

        _lbllandlord = [[UILabel alloc] init];
        CGRect ldrect = CGRectMake(15, TITLEHEIGHT+MARGINV+LABELHEIGHT + 140, 60, LABELHEIGHT);
        KT_LABELEWIFRAM(_lbllandlord, ldrect, @"匿名", labelFontSize, [UIColor clearColor], KT_HEXCOLOR(0x6e6e6e), NSTextAlignmentLeft, NO)
        _lbllandlord.font = [UIFont systemFontOfSize:labelFontSize];
        [self addSubview:_lbllandlord];


        //查看的图片（眼睛）
        chakan = [UIButton buttonWithType:UIButtonTypeCustom];
        chakan.frame = CGRectMake(CGRectGetMaxX(_lbllandlord.frame) - 3 + 30, TITLEHEIGHT + MARGINV + LABELHEIGHT + 140 + 1, 20, LABELHEIGHT);
        [chakan setImage:[UIImage bundleImageNamed:@"chakan"] forState:UIControlStateNormal];
        [self addSubview:chakan];
        //查看
        _lblreadl = [[UILabel alloc] init];
        CGRect readrect = CGRectMake(CGRectGetMaxX(chakan.frame) , TITLEHEIGHT+MARGINV + LABELHEIGHT + 140, CKPLWIDTH, LABELHEIGHT);
        KT_LABELEWIFRAM(_lblreadl, readrect, @"100", labelFontSize, [UIColor clearColor], KT_HEXCOLOR(0x6e6e6e), NSTextAlignmentLeft, NO)
        _lblreadl.font = [UIFont systemFontOfSize:labelFontSize];
        [self addSubview:_lblreadl];



        //回复的图片（气泡）
        reply = [UIButton buttonWithType:UIButtonTypeCustom];
        reply.frame = CGRectMake(_lblreadl.frame.origin.x + _lblreadl.frame.size.width + 20, TITLEHEIGHT+MARGINV+LABELHEIGHT + 140+1, 20, LABELHEIGHT);
        [reply setImage:[UIImage bundleImageNamed:@"huitei"] forState:UIControlStateNormal];
        [reply addTarget:self action:@selector(replybtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reply];
        //回复
        _lblreply = [[UILabel alloc] init];
        CGRect lblreplyframe = CGRectMake(CGRectGetMaxX(reply.frame), TITLEHEIGHT + MARGINV+LABELHEIGHT + 140, CKPLWIDTH, LABELHEIGHT);
        KT_LABELEWIFRAM(_lblreply, lblreplyframe, @"20", labelFontSize, [UIColor clearColor], KT_HEXCOLOR(0x6e6e6e), NSTextAlignmentLeft, NO)
        _lblreply.font = [UIFont systemFontOfSize:labelFontSize];
        [self addSubview:_lblreply];


        //回复的时间
        _lbltime = [[UILabel alloc] init];
//        CGRect lbltimeframe = CGRectMake(290 - 200 - CELLICONWITH + 80, TITLEHEIGHT+MARGINV+LABELHEIGHT + 140, 200, LABELHEIGHT);
        CGRect lbltimeframe = CGRectMake(self.frame.size.width - 150 - 15, TITLEHEIGHT+MARGINV+LABELHEIGHT + 140, 150, LABELHEIGHT);
        KT_LABELEWIFRAM(_lbltime, lbltimeframe, @"14:47:57", labelFontSize, [UIColor clearColor], KT_HEXCOLOR(0x6e6e6e), NSTextAlignmentRight, NO)
        _lbltime.font = [UIFont systemFontOfSize:labelFontSize];
        [self addSubview:_lbltime];
    }
    return self;
}

-(void)replybtnTap:(id)sender
{

}

- (void)awakeFromNib
{ 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
