//
//  D2_Setting_ClearCash.h
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "HBBaseCell.h"

@interface D2_Setting_ClearCashCell : HBBaseCell<UIAlertViewDelegate>
{
    UILabel *lblcashSize;
    float cashsize;
}

AS_SIGNAL(WILLCLEARCASH);
AS_SIGNAL(DIDCLEARCASH);

@end
