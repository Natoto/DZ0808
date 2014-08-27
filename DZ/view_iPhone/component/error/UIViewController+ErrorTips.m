//
//  ErrorMsg.m
//  shop
//
//  Created by QFish on 6/28/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "UIViewController+ErrorTips.h"
#import "rmbdz.h"
@implementation UIViewController(ErrorTips)

- (void)showErrorTips:(BeeUISignal *)signal
{
    NSString *message = signal.object;
    if ([message rangeOfString:@"API_"].location !=NSNotFound) {
        message =@"请求页面出问题了额";
    }
//	[self presentFailureTips:__TEXT(@"error_network")];
}

//
//- (void)showErrorTips:(BeeMessage *)msg
//{
//    STATUS * status = msg.GET_OUTPUT( @"status" );
//	if ( status )
//	{
//		NSString * errorDesc = status.emsg;
//		if ( errorDesc )
//		{
//			[self presentFailureTips:errorDesc];
//			return;
//		}
//	}
//	
//	NSString * errorDesc2 = msg.errorDesc;
//    if ( errorDesc2 )
//    {
//        [self presentFailureTips:errorDesc2];
//		return;
//    }
//
//	if ( status.ecode )
//	{
//		NSString * multiLang = [NSString stringWithFormat:@"error_%@", status.ecode];
//		NSString * errorDesc3 = __TEXT( multiLang );
//		if ( errorDesc3 )
//		{
//			[self presentFailureTips:errorDesc3];
//			return;
//		}
//	}
//	[self presentFailureTips:__TEXT(@"error_network")];
//}

@end
