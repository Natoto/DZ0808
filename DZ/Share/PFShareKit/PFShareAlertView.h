//
//  PFShareAlertView.h
//  PFShareKit
//
//  Created by PFei_He on 14-6-6.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFShareAlertView : UIAlertView

- (void)AlertWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (void)AlertWithTitle:(NSString *)title andMessage:(NSString *)message;

@end
