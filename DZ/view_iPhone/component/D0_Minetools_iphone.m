//
//  E0_MINETOLLS_iphone.m
//  DZ
//
//  Created by Nonato on 14-4-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D0_MineTools_iphone.h"

@implementation D0_MineTools_iphone
@synthesize avatar;
@synthesize name;
@synthesize BUTTON;

DEF_SIGNAL(BUTTONTAP)


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        bgview.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgview];

        self.avatar = [[BeeUIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 25, 25)];
        self.avatar.contentMode = UIViewContentModeScaleToFill;
        KT_CORNER_RADIUS(self.avatar,4)
        [self addSubview:self.avatar];

        self.name = [[BeeUILabel alloc] initWithFrame:CGRectMake(60, 0, 100, 50)];
        self.name.text = @"设置";
//        self.name.font = GB_FontHelveticaNeue(15);
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = [UIColor blackColor];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.backgroundColor = [UIColor clearColor];
        [self addSubview:self.name];

//            self.BUTTON=[[BeeUIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//            [self addSubview:self.BUTTON];
//            [self.BUTTON setBackgroundColor:[UIColor clearColor]];
        self.backgroundColor = [UIColor clearColor];
        self.avatar.image = [UIImage bundleImageNamed:@"profile.jpg"];
        self.avatar.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleToFill;

        UIImageView *splitimg = [[BeeUIImageView alloc] initWithFrame:CGRectMake(15, 49, 290, LINE_LAYERBOARDWIDTH)];
        splitimg.backgroundColor =LINE_LAYERBOARD_NOTCGCOLOR;
        splitimg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:splitimg];
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



ON_SIGNAL3(BeeUIButton, TOUCH_UP_INSIDE, signal)
{
    [self sendUISignal:self.BUTTONTAP];
}

- (void)unload
{
}

- (void)dataDidChanged
{
    if (self.data) {
//     $(@"avatar").DATA(@"profile.png");
        self.avatar.image=[UIImage bundleImageNamed:@"profile.jpg"];
        self.name.text=self.data;
//        BeeLog(@"self.data=%@",self.data);
//        $(@"name").DATA(self.data);
//    $(@"time").DATA( [[NSData  asNSDate] stringWithDateFormat:@"MM.dd.yyyy"] );
    }
}

@end
