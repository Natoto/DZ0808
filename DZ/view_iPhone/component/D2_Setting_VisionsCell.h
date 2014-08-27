//
//  D2_Setting_Visions.h
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "HBBaseCell.h"

@interface D2_Setting_VisionsCell : HBBaseCell
AS_SIGNAL(versions)
@property (nonatomic,strong) UILabel *visionlbl;

AS_SIGNAL(CHECKING)
AS_SIGNAL(CHECKEDSUCCESS)
AS_SIGNAL(CHECKEDFAILED)

@end
