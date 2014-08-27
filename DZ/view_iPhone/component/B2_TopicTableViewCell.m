//
//  TopicTableViewCell.m
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B2_TopicTableViewCell.h"
#import "Constants.h"
#import "SettingModel.h"

#define   CELLICONHEIGHT 75
#define   CELLICONWITH   CELLICONHEIGHT

@implementation B2_TopicTableViewCell
@synthesize message;

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
        [self addbackgroundView:nil];
        // Initialization code        
        _cellicon=[[BeeUIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-CELLICONWITH-8, 8, CELLICONWITH,CELLICONHEIGHT)];
        _cellicon.backgroundColor=[UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1];
        _cellicon.contentMode=UIViewContentModeScaleAspectFill;
        _cellicon.indicatorColor=[UIColor whiteColor];
        [self addSubview:_cellicon];

        //帖子标题
        _lbltitle = [[UILabel alloc] init];
        int TITLEHEIGHT = 40;
        int MARGINV = 5;
        CGRect rect = CGRectMake(15, 0, self.frame.size.width-CELLICONWITH-30 - 15 -11 , TITLEHEIGHT);
        KT_LABELEWIFRAM(_lbltitle,rect, @"主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题主题帖子标题", 16, [UIColor clearColor] , [UIColor blackColor], NSTextAlignmentLeft, NO)
//        _lbltitle.font = GB_FontHelveticaNeue(15);
        _lbltitle.font = [UIFont systemFontOfSize:16];
#warning font
        _lbllandlord.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:_lbltitle];

        //帖子内容
        message = [[UILabel alloc] initWithFrame:CGRectMake(5, TITLEHEIGHT - 10, self.frame.size.width-60, TITLEHEIGHT)];
        CGRect msgrect = CGRectMake(5, TITLEHEIGHT, self.frame.size.width-60, TITLEHEIGHT);
        KT_LABELEWIFRAM(message, msgrect, @"", 12, [UIColor clearColor] , [UIColor grayColor], NSTextAlignmentLeft, NO)
        message.font = [UIFont systemFontOfSize:12];
        [self addSubview:message];
        
        float LABELHEIGHT = 20;
        float lbllandlordWidth = 60;
        float MARGELEFT = 5;
        int  labelFontSize = 12;
        
        UILabel *lzhu=[[UILabel alloc] init];
        lzhu.tag=1410;
        lzhu.font = [UIFont systemFontOfSize:labelFontSize];
//        CGRect louzhuframe=CGRectMake(MARGELEFT, TITLEHEIGHT + MARGINV, 30, LABELHEIGHT);
//        KT_LABELEWIFRAM(lzhu,louzhuframe, @"楼主:", labelFontSize,[UIColor clearColor] , [UIColor grayColor], NSTextAlignmentRight,NO)
//        [self addSubview:lzhu];

        //楼主
        _lbllandlord=[[UILabel alloc] init];
        CGRect ldrect=CGRectMake(MARGELEFT  , TITLEHEIGHT + MARGINV, lbllandlordWidth, LABELHEIGHT);
        KT_LABELEWIFRAM(_lbllandlord, ldrect, @"匿名", labelFontSize, [UIColor clearColor], KT_HEXCOLOR(0x6e6e6e), NSTextAlignmentLeft, NO)
//        _lbllandlord.textColor=[UIColor colorWithRed:74/255. green:155/255. blue:138/255. alpha:1];
        _lbllandlord.font = [UIFont systemFontOfSize:labelFontSize];
        [self addSubview:_lbllandlord];

        //查看
        _lblreadl = [[UILabel alloc] init];
        CGRect readrect = CGRectMake(self.frame.size.width - CELLICONWITH - 5 - lbllandlordWidth, MARGINV + TITLEHEIGHT, 40, LABELHEIGHT);
        KT_LABELEWIFRAM(_lblreadl, readrect, @"100", labelFontSize, [UIColor clearColor], KT_HEXCOLOR(0x6e6e6e), NSTextAlignmentLeft, NO)
        _lblreadl.font = [UIFont systemFontOfSize:labelFontSize];
        [self addSubview:_lblreadl];
        //查看的图片（眼睛）
        chakan = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect chakanframe = CGRectMake(self.frame.size.width - CELLICONWITH - 5 - 30 - 40, TITLEHEIGHT + MARGINV, 30, LABELHEIGHT);
        chakan.frame = chakanframe;
        [chakan setImage:[UIImage bundleImageNamed:@"chakan"] forState:UIControlStateNormal];
//        KT_LABELEWIFRAM(chakan,chakanframe, @"查看:", labelFontSize,[UIColor clearColor], [UIColor grayColor], NSTextAlignmentRight, NO)
        [self addSubview:chakan];


        //回复的图片（气泡）
        reply = [UIButton buttonWithType:UIButtonTypeCustom];// alloc] init];
        CGRect replyframe = CGRectMake(MARGELEFT, TITLEHEIGHT + MARGINV + LABELHEIGHT, 30, LABELHEIGHT);
        [reply setImage:[UIImage bundleImageNamed:@"huitei"] forState:UIControlStateNormal];
        [reply addTarget:self action:@selector(replybtnTap:) forControlEvents:UIControlEventTouchUpInside];
        reply.frame = replyframe;
        [self addSubview:reply];
        //回复
        _lblreply = [[UILabel alloc] init];
        CGRect lblreplyframe = CGRectMake(MARGELEFT + 30, TITLEHEIGHT + MARGINV + LABELHEIGHT,30 , LABELHEIGHT);
        KT_LABELEWIFRAM(_lblreply, lblreplyframe, @"20", labelFontSize, [UIColor clearColor], KT_HEXCOLOR(0x6e6e6e), NSTextAlignmentLeft, NO)
        _lblreply.font = [UIFont systemFontOfSize:labelFontSize];
        [self addSubview:_lblreply];
        
        //回复的时间
        _lbltime = [[UILabel alloc] init];
//        CGRect lbltimeframe = CGRectMake(290 - 200 - CELLICONWITH + 3, TITLEHEIGHT+MARGINV+LABELHEIGHT, 200, LABELHEIGHT);
        CGRect lbltimeframe = CGRectMake(self.frame.size.width - 150 - 15, TITLEHEIGHT+MARGINV+LABELHEIGHT, 200, LABELHEIGHT);
        KT_LABELEWIFRAM(_lbltime, lbltimeframe, @"14:47:57", labelFontSize, [UIColor clearColor], KT_HEXCOLOR(0x6e6e6e), NSTextAlignmentLeft, NO)
        _lbltime.font = [UIFont systemFontOfSize:labelFontSize];
        [self addSubview:_lbltime];
        [self layoutSubviews:NO];
    }
    return self;
} 

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.lblreadl.text.integerValue > 999) {
        self.lblreadl.text = @"999+";
    }
    if (self.lblreadl.text.integerValue > 999) {
        self.lblreadl.text = @"999+";
    }
    if ([self.lbllandlord.text isEqualToString:@"(null)"]) {
        self.lbllandlord.text = @"匿名";
    }
}
-(void)datachanges:(topics *)atopic
{
    if (atopic.authorname.length) {
        self.lbllandlord.text = atopic.authorname;
    }
    self.message.text = atopic.message;
    self.lblreadl.text = atopic.views;
    //        cell.lblreadl.font = [UIFont systemFontOfSize];
    self.lblreply.text = atopic.replies;
    atopic.subject = [atopic.subject stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    self.lbltitle.text = atopic.subject;
    self.lbltime.text = [NSString stringWithFormat:@"%@", [ToolsFunc datefromstring:atopic.lastpost]];
    if (atopic.img.length) {
        self.cellicon.data = atopic.img;
        [self layoutSubviews:atopic.img.length];
    }
    else
    {
        [self layoutSubviews:NO];
    }
    
}

-(void)layoutSubviews:(BOOL)havePhote
{
    int TITLEHEIGHT = 30;
    float LABELHEIGHT = 20;
    float MARGELEFT = 15;
    float WUTUY = 53;
    float YOUTUY = 68;
//    float WUTURIGHT = 200;
    float CKPLWIDTH = 30;
  
    //2G3G的情况下根据设置显示无图或者有图
    if ( [BeeReachability isReachableViaWIFI] )
    {
        
    }
    else
    {
        if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_23G_NOTLOAD)
        {
            if (havePhote) {
                havePhote = NO;
            }
        }
    }
    
    if (havePhote) {//有图
        _cellicon.hidden=NO;
//        _cellicon.data=self.atopic.img;
        _cellicon.frame = CGRectMake(self.frame.size.width - CELLICONWITH - 15, 8, CELLICONWITH,CELLICONHEIGHT);
        _lbltitle.frame = CGRectMake(MARGELEFT, 0, self.frame.size.width - CELLICONWITH - MARGELEFT * 2 - 11, 40);
        message.hidden = YES;
        
        float lbllandlordWidth = 100;
        _lbllandlord.frame = CGRectMake(MARGELEFT, WUTUY, lbllandlordWidth, LABELHEIGHT);

//        _lbltime.frame = CGRectMake(self.frame.size.width - 150 - 15 - 11 - CELLICONWITH , YOUTUY, 150, LABELHEIGHT);
        _lbltime.frame = CGRectMake(MARGELEFT, YOUTUY, 150, LABELHEIGHT);
        _lbltime.textAlignment = 0;

#warning the frame was changed
        chakan.frame = CGRectMake(CGRectGetMaxX(_lbllandlord.frame) - 43 +  30 + 70, WUTUY, 20, LABELHEIGHT);
        _lblreadl.frame = CGRectMake(CGRectGetMaxX(chakan.frame), WUTUY, CKPLWIDTH, LABELHEIGHT);

        reply.frame = CGRectMake(CGRectGetMaxX(_lbllandlord.frame) - 43 + 30 + 70, YOUTUY, 20, LABELHEIGHT);
        _lblreply.frame = CGRectMake(CGRectGetMaxX(reply.frame), YOUTUY, CKPLWIDTH, LABELHEIGHT);
    }
    else//无图
    {
        _cellicon.hidden = YES;
        _lbltitle.frame = CGRectMake(15, 0, self.frame.size.width - 30, 40);

        message.frame = CGRectMake(15, TITLEHEIGHT, self.frame.size.width - 60, TITLEHEIGHT);
//        message.text = atopic.message;
        message.hidden = NO;
        
        _lbllandlord.frame = CGRectMake(MARGELEFT, YOUTUY, 60, LABELHEIGHT);

        _lbltime.frame = CGRectMake(self.frame.size.width - 150 - 15, YOUTUY, 150, LABELHEIGHT);
        _lbltime.textAlignment = 2;

        chakan.frame = CGRectMake(CGRectGetMaxX(_lbllandlord.frame) - 3 + 30, YOUTUY, 20, LABELHEIGHT);
        _lblreadl.frame = CGRectMake(CGRectGetMaxX(chakan.frame), YOUTUY, CKPLWIDTH, LABELHEIGHT);

        reply.frame = CGRectMake(_lblreadl.frame.origin.x + _lblreadl.frame.size.width + 20, YOUTUY, 20, LABELHEIGHT);
 
        _lblreply.frame = CGRectMake(CGRectGetMaxX(reply.frame) , YOUTUY, CKPLWIDTH, LABELHEIGHT);
    }
     [reply setImageEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
}

-(void)replybtnTap:(id)sender
{
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
//     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Configure the view for the selected state
} 

@end
