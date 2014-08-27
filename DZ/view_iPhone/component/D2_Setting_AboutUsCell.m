//
//  D2_Setting_AboutUsCell.m
//  DZ
//
//  Created by PFei_He on 14-6-23.
//
//

#import "D2_Setting_AboutUsCell.h"

@implementation D2_Setting_AboutUsCell

DEF_SIGNAL(aboutUs)

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftlabel.text = @"关于我们";
        self.leftlabel.font = [UIFont systemFontOfSize:15];
        self.leftlabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

ON_SIGNAL3(D2_Setting_AboutUsCell, ABOUTUS, signal)
{
    [self sendUISignal:self.aboutUs];
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
