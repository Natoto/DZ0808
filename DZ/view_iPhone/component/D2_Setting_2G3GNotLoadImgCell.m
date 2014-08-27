//
//  D2_Setting_2G3GNotLoadImgCell.m
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_Setting_2G3GNotLoadImgCell.h"
#import "SettingModel.h"
#import "DZ_SystemSetting.h"
@implementation D2_Setting_2G3GNotLoadImgCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        label=leftlabel;
        label.text=@"2G/3G模式下不加载图片";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkGrayColor];

        switcher=[[BeeUISwitch alloc] init];
        switcher.on=![SettingModel sharedInstance].photoMode;
        float switcherwidth = switcher.frame.size.width;
        switcher.frame = CGRectMake(self.frame.size.width - switcherwidth - 15, 10, switcherwidth, 30);
        [switcher addTarget:self action:@selector(dataDidChanged) forControlEvents:UIControlEventValueChanged];
        switcher.onTintColor = [DZ_SystemSetting sharedInstance].navigationBarColor;
        [self addSubview:switcher];
//        float centerx= CGRectGetMinX(switcher.frame) + CGRectGetWidth(switcher.frame)/2;
//        switcher.center=CGPointMake(centerx, self.height/2);
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}


-(void)dataDidChanged
{
    [SettingModel sharedInstance].photoMode = (switcher.on==YES)?SettingModel.PHOTO_23G_NOTLOAD:SettingModel.PHOTO_23G_LOAD;
    [[SettingModel sharedInstance] saveCache];
} 

@end
