//
//  D1_Msg_InstationTableViewCell.m
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_Msg_InstationTableViewCell.h"

@implementation D1_Msg_InstationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        RCLabel *lblmessage =[[RCLabel alloc] initWithFrame:CGRectMake(10, 5, 300, 50)];
        rtLabel=lblmessage;
        rtLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:lblmessage];
    }
    return self;
}


-(void)setTxtMessage:(NSString *)txtMessage
{
    _txtMessage=txtMessage;
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:txtMessage];
    rtLabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [rtLabel optimumSize];
    rtLabel.frame=CGRectMake(10, 5, 300, optimumSize.height);
}

-(void)setAmatic:(automatic *)amatic
{
    _amatic=amatic;
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:amatic.note];
    rtLabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [rtLabel optimumSize];
    rtLabel.frame=CGRectMake(10, 5, 300, optimumSize.height);
}
+(float)heightOfCell:(NSString *)txtMessage
{
    RCLabel *tempRtLabel=[[RCLabel alloc] init];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:txtMessage];
    tempRtLabel.frame=CGRectMake(10, 5, 300, 50);
    tempRtLabel.font = [UIFont systemFontOfSize:14];
    tempRtLabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [tempRtLabel optimumSize];
    return (optimumSize.height+10)>50?(optimumSize.height+10):50;
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
