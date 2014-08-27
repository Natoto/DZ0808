//
//  D2_Setting_Visions.m
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_Setting_VisionsCell.h"
#import "DZ_SystemSetting.h"
@implementation D2_Setting_VisionsCell
DEF_SIGNAL(versions)
DEF_SIGNAL(CHECKING)
DEF_SIGNAL(CHECKEDSUCCESS)
DEF_SIGNAL(CHECKEDFAILED)

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code 
        self.leftlabel.text = @"版本号";
        self.rightlabel.text =[DZ_SystemSetting sharedInstance].appversion; //@"V 1.0.0";
        self.visionlbl = rightlabel;
        self.leftlabel.font = [UIFont systemFontOfSize:15];
        self.rightlabel.textColor = [UIColor darkGrayColor];
        self.leftlabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

ON_SIGNAL3(D2_Setting_VisionsCell, cellSelected, signal)
{
    [self sendUISignal:self.CHECKING];

    [self sendUISignal:self.CHECKEDFAILED];
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
