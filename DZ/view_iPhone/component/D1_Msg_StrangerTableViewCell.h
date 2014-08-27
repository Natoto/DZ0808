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
#import "DZ_BASETableViewCell.h"
@class strangerms;
@interface D1_Msg_StrangerTableViewCell : UITableViewCell
{
    BeeUIImageView * avatar;
    UILabel        * name;
    RCLabel        * message;
    UILabel        * time;
//    RCLabel         * rtLabel;
}
//@property(nonatomic,retain) NSString  * txtMessage;
//@property(nonatomic,retain) automatic * amatic;
+(float)heightOfCell:(NSString *)txtMessage;
-(void)dataChange:(strangerms *)astrangerms;
@end
