//
//  D2_Setting_Nightmode_Cell.m
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_Setting_FontSize_Cell.h"
#import "DZ_SystemSetting.h"
@implementation D2_Setting_FontSize_Cell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        label = leftlabel;
        label.backgroundColor=[UIColor clearColor];
        label.text=@"字体大小";
        label.textColor=[UIColor darkGrayColor];
        label.font=[UIFont systemFontOfSize:15];
    
        
        NSArray *array = @[@"小",@"中",@"大"];
        segmentctr = [[UISegmentedControl alloc] initWithItems:array];
        segmentctr.center=CGPointMake(250, 25);
        segmentctr.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentctr.multipleTouchEnabled = NO;
        segmentctr.frame = CGRectMake(self.frame.size.width - 80 - 15, 10, 80, 30);
        segmentctr.tintColor =[DZ_SystemSetting sharedInstance].navigationBarColor;
        
        self.fontsize = [SettingModel sharedInstance].fontsize;
        [self loaddata];
        [segmentctr addTarget:self action:@selector(dataDidChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:segmentctr];
         self.accessoryType = UITableViewCellAccessoryNone;
//        [self.containerCell setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [segmentctr setTranslatesAutoresizingMaskIntoConstraints:NO];
//        NSMutableArray *tmpConstraints = [[NSMutableArray alloc] init];
//        NSString *vfl = @"H:|-15-[label(>=230)]-[segmentctr]-30-|";
//        [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:NSDictionaryOfVariableBindings(label,segmentctr)]];
//        [self addConstraints:tmpConstraints];
//        self.accessoryType = UITableViewCellAccessoryNone;
        // #333 0.1;
    }
    return self;
}
-(void)loaddata
{
    switch (self.fontsize) {
        case FONTSIZE_SMALL:
            segmentctr.selectedSegmentIndex = 0;
            break;
        case FONTSIZE_MIDDLE:
            segmentctr.selectedSegmentIndex = 1;
            break;
        case FONTSIZE_BIG:
            segmentctr.selectedSegmentIndex = 2;
            break;
        default:
            break;
    }
}

-(void)dataDidChanged
{
    switch (segmentctr.selectedSegmentIndex) {
        case 0:
            self.fontsize = FONTSIZE_SMALL;
            break;
        case 1:
            self.fontsize = FONTSIZE_MIDDLE;
            break;
        case 2:
            self.fontsize = FONTSIZE_BIG;
            break;
        default:
            break;
    }
    [SettingModel sharedInstance].fontsize = self.fontsize;
    [[SettingModel sharedInstance] saveCache];
}


@end
