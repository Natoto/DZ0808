//
//  D2_Setting_AboutUsCtr_Cell.h
//  DZ
//
//  Created by Nonato on 14-7-17.
//
//

#import "DZ_BASETableViewCell.h"
@class RCLabel;
@interface D2_Setting_AboutUsCtr_Cell : UITableViewCell
{
    RCLabel *textlabel;
}
@property(nonatomic,assign)id classtype;
+(float)heightOfcell:(NSString *)text;
@end
