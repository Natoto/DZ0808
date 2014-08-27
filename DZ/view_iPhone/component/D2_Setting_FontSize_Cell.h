//
//  D2_Setting_Nightmode_Cell.h
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "HBBaseCell.h"
#import "Bee.h"
#import "SettingModel.h"

@interface D2_Setting_FontSize_Cell : HBBaseCell
{
    UILabel *label;
    UISegmentedControl *segmentctr;
}
@property(nonatomic,assign) FONTSIZE_TYPE fontsize;
@end
