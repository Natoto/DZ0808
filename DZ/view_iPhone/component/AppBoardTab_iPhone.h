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

#import "Bee.h"

AS_UI(AppBoardTab_iPhone, tabbar)

#pragma mark -
@class TabItem;
@interface AppBoardTab_iPhone : UIView
{
    NSArray *titleAry;
    NSArray *iconNameAry;
    NSArray *tabbarSelectorAry;
}
AS_SINGLETON( AppBoardTab_iPhone )
AS_SIGNAL(homepage)
AS_SIGNAL(forum)
AS_SIGNAL(sendhtm)
AS_SIGNAL(mine)
AS_SIGNAL(album)
@property(nonatomic,retain)TabItem * blumbtn;
@property(nonatomic,retain)TabItem * homepagebtn;
@property(nonatomic,retain)TabItem * forumbtn;
@property(nonatomic,retain)TabItem * sendhtmbtn;
@property(nonatomic,retain)TabItem * minebtn;
- (void)selectHomepage;
- (void)selectForum;
- (void)selectSendhtm;
-(void)selectMine;
@end
