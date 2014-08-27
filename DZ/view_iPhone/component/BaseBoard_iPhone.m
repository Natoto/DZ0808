//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "BaseBoard_iPhone.h"
//#import "MobClick.h"

#pragma mark -

@implementation BaseBoard_iPhone

#pragma mark -

- (void)load
{
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        UIBarButtonItem *myBarButtonItem = [[UIBarButtonItem alloc] init];
        myBarButtonItem.title = self.title;
        self.navigationItem.backBarButtonItem = myBarButtonItem;
        
        self.view.backgroundColor = [UIImage bundleImageNamed:@"index_body_bg.png"].patternColor;
        NSLog(@"self.stack.boards.count= %d",self.stack.boards.count);
    }
    else if ([signal is:BeeUIBoard.WILL_APPEAR])
    {//	[MobClick beginLogPageView:[[self class] description]];
    }
    else if ([signal is:BeeUIBoard.WILL_DISAPPEAR])
    {//	[MobClick endLogPageView:[[self class] description]];
    }
}
  

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
//    if (self.stack.boards.count<1) {
//        [self.stack popBoardAnimated:YES];
//    }
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

@end
