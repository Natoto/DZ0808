//
//  D1_Msg_InstationTableViewCell.h
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
#import "remind.h"
@interface D1_Msg_InstationTableViewCell : UITableViewCell
{
    RCLabel * rtLabel;
}
@property(nonatomic,retain) NSString  * txtMessage;
@property(nonatomic,retain) automatic * amatic;
+(float)heightOfCell:(NSString *)txtMessage;

@end
