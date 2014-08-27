//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "DribbbleDetailBoard_iPhone.h"
//#import "DribbbleDetailBoardPlayer_iPhone.h"
//#import "DribbbleDetailBoardPhoto_iPhone.h"
//#import "DribbbleDetailBoardComment_iPhone.h"
//#import "DribbblePreviewBoard_iPhone.h"
//#import "DribbbleProfileBoard_iPhone.h"
//#import "DribbbleWebBoard_iPhone.h"
#import "PullLoader.h"
#import "FootLoader.h"
#import "AppBoard_iPhone.h"
#pragma mark -

@interface DribbbleDetailBoard_iPhone()

@end

#pragma mark -

@implementation DribbbleDetailBoard_iPhone
DEF_OUTLET(BeeUIScrollView, list);

//SUPPORT_RESOURCE_LOADING( YES )
//SUPPORT_AUTOMATIC_LAYOUT( YES )
- (void)load
{
    
}

- (void)unload
{
    
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.allowedSwipeToBack=YES;
    self.titleString = @"详情";//__TEXT(@"member_signin");
    self.navigationBarShown = YES;
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back"]];
    BeeLog(@"BeeUINavigationBar.LEFT=%@",BeeUINavigationBar.LEFT);
//    [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"cancel") image:[[UIImage imageNamed:@"navigation-back.png"] stretched]];
//    self.view.backgroundColor = SHORT_RGB(0x444);

}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self showNavigationBarAnimated:NO];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

@end
