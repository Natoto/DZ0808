//
//  B0_PlatesCommentCell_iphone.m
//  DZ
//
//  Created by Nonato on 14-4-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B0_PlatesCommentCell_iphone.h"

@implementation B0_PlatesCommentCell_iphone
SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )


- (void)load
{
    
}

- (void)unload
{
}

- (void)dataDidChanged
{
    $(@"avatar").DATA(@"profile");
    $(@"name").DATA(@"Nonato");
    $(@"text").DATA(@"hello world");
    $(@"time").DATA( [[NSData  asNSDate] stringWithDateFormat:@"MM.dd.yyyy"] );
}

@end
