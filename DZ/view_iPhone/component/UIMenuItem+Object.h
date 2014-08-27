//
//  UIMenuItem+Object.h
//  DZ
//
//  Created by Nonato on 14-7-9.
//
//

#import <UIKit/UIKit.h>

@interface UIMenuController_Object : UIMenuController
+ (UIMenuController_Object *)sharedMenuController;
@property(nonatomic,retain)id object;
@end
