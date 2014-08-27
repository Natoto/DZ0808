//
//  A0_Hot_iphone.m
//  DZ
//
//  Created by Nonato on 14-3-31.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Hot_iphone.h"

@interface Hot_iphone ()

@end

@implementation Hot_iphone


ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.view.backgroundColor=[UIColor whiteColor];
    }
}

@end
