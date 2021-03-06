//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceWizard_Window.h"
#import "ServiceWizard_Board.h"
#import "ServiceWizard.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceWizard_Window
{
	BOOL	_statusBarHidden;
}

DEF_SINGLETON( ServiceWizard_Window );

- (void)load
{
	self.hidden = YES;
	self.backgroundColor = [UIColor blackColor];
	self.windowLevel = UIWindowLevelStatusBar + 3.0f;
}

- (void)unload
{	
}

#pragma mark -

- (void)didOpen
{
}

- (void)open
{
	_statusBarHidden = [UIApplication sharedApplication].statusBarHidden;

/*	if ( NO == _statusBarHidden )
	{
		[UIApplication sharedApplication].statusBarHidden = YES;
	}*/

	self.rootViewController = [ServiceWizard_Board board];
	
    self.hidden = NO;
	self.alpha = 0.0f;

	CATransform3D transform;
	
	transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, 200 );
	self.layer.transform = transform;

	[BeeUIApplication sharedInstance].window.alpha = 1.0f;
	[BeeUIApplication sharedInstance].window.layer.transform = CATransform3DIdentity;

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDidStopSelector:@selector(didOpen)];
	
	self.layer.transform = CATransform3DIdentity;
	self.alpha = 1.0f;
	
	transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, -200.0f );
	
	[BeeUIApplication sharedInstance].window.alpha = 0.0f;
	[BeeUIApplication sharedInstance].window.layer.transform = transform;
	
	[UIView commitAnimations];
	
	[[ServiceWizard sharedInstance] notifyShown];
}

- (void)didClose
{
    self.hidden = YES;
	self.rootViewController = nil;

	[[ServiceWizard sharedInstance] notifySkipped];
	
	if ( NO == _statusBarHidden )
	{
		[UIApplication sharedApplication].statusBarHidden = NO;
	}
}

- (void)close
{
	self.layer.transform = CATransform3DIdentity;
	self.alpha = 1.0f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDidStopSelector:@selector(didClose)];
	
    self.hidden = NO;
	self.alpha = 0.0f;
	
	CATransform3D transform;
	
	transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, 200 );
	self.layer.transform = transform;

	[BeeUIApplication sharedInstance].window.alpha = 1.0f;
	[BeeUIApplication sharedInstance].window.layer.transform = CATransform3DIdentity;

	[UIView commitAnimations];
}

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
