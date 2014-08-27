//
//  UIMenuItem+Object.m
//  DZ
//
//  Created by Nonato on 14-7-9.
//
//

#import "UIMenuItem+Object.h"

@implementation UIMenuController_Object

+ (UIMenuController_Object *)sharedMenuController
{
    return (UIMenuController_Object *)[UIMenuController sharedMenuController];
}
@end
