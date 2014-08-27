//
//  D1_Msg_InstationTableViewCell.m
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_Msg_StrangerTableViewCell.h"
#import "allpm.h"
#define DEFAULTFONT [UIFont systemFontOfSize:18]
@implementation D1_Msg_StrangerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        avatar=[[BeeUIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        KT_IMGVIEW_CIRCLE(avatar, 1);
        avatar.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:avatar];
        
        name=[[UILabel alloc] init];
        KT_LABELEWIFRAM(name, CGRectMake(70, 5, 200, 25), @"", 18, [UIColor clearColor], [UIColor grayColor], NSTextAlignmentLeft, NO);
        [self.contentView addSubview:name];
        
        message=[[RCLabel alloc] init];
        message.backgroundColor = [UIColor clearColor];
        message.frame = CGRectMake(70, 30, 200, 40);
        [self.contentView addSubview:message];
        
        time=[[UILabel alloc] init];
        KT_LABELEWIFRAM(time, CGRectMake(200, 20, 100, 40), @"", 15, [UIColor clearColor], [UIColor grayColor], NSTextAlignmentRight, NO);
        [self.contentView addSubview:time];
         
    }
    return self;
}

-(void)dataChange:(strangerms *)astrangerms
{
    avatar.data = astrangerms.avatar;
    name.text = astrangerms.author;
    
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:astrangerms.message];
    message.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [message optimumSize];
    message.font = DEFAULTFONT;
    CGRect frame = message.frame;
    message.frame=CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), optimumSize.height);
    [self setNeedsDisplay];
}


//-(void)setAmatic:(automatic *)amatic
//{
//    _amatic=amatic;
//    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:amatic.note];
//    rtLabel.componentsAndPlainText = componentsDS;
//    CGSize optimumSize = [rtLabel optimumSize];
//    rtLabel.frame=CGRectMake(10, 5, 300, optimumSize.height);
//}

+(float)heightOfCell:(NSString *)txtMessage
{
    if (txtMessage.length) {
        RCLabel *tempRtLabel=[[RCLabel alloc] init];
        tempRtLabel.font = DEFAULTFONT; //[UIFont systemFontOfSize:18];
        tempRtLabel.frame = CGRectMake(0, 0, 200, 40);
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:txtMessage];
        tempRtLabel.componentsAndPlainText = componentsDS;
        CGSize optimumSize = [tempRtLabel optimumSize];
        float height = (optimumSize.height+10)>50?(optimumSize.height+10):50;
        return height + 35;
    }
    else
    {
        return 50.0;
    }

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
