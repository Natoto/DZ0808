//
//  DZ_UIDevice_IOKit_Extensions.h
//  DZ
//
//  Created by Nonato on 14-7-28.
//
//

#import <UIKit/UIKit.h>
/*
 获得设备sim卡等信息
 */
@interface UIDevice (IOKit_Extensions)
- (NSString *) imei;
- (NSString *) mei; 
- (NSString *) serialnumber;
- (NSString *) backlightlevel;
@end
