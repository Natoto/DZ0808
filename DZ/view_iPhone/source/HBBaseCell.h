//
//  HBBaseCell.h
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_UICell.h"
#import "Bee.h"

@interface HBBaseCell : UITableViewCell
{
    UILabel *leftlabel;
    UILabel *rightlabel;
}
@property(nonatomic,strong) UILabel *leftlabel;
@property(nonatomic,strong) UILabel *rightlabel;

AS_SIGNAL(cellSelected)
AS_SIGNAL(ABOUTUS)
-(void)dataDidChanged;
@end
