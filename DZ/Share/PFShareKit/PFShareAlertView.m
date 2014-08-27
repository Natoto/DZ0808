//
//  PFShareAlertView.m
//  PFShareKit
//
//  Created by PFei_He on 14-6-6.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFShareAlertView.h"

@implementation PFShareAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)AlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)AlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
