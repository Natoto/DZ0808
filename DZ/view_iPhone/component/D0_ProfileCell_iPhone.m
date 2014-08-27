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

#import "D0_ProfileCell_iPhone.h"
#import "UserModel.h"
#pragma mark -

@implementation D0_ProfileCell_iPhone

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
    if ( self.data )
    {
        UserModel * userModel = self.data;
        
		if ( [UserModel online] )
		{
			$(@"#name").TEXT(userModel.login.account);
		}
		else
		{
			$(@"#name").TEXT(__TEXT(@"click_to_login"));
		}
        
		
		if ( [UserModel online] )
		{
//			if ( [UserModel sharedInstance].avatar )
//			{
////				$(@"#header-avatar").IMAGE( [UserModel sharedInstance].avatar );
//			}
//			else
			{
				$(@"#header-avatar").IMAGE( [UIImage imageNamed:@"profile_no_avatar_icon.png"] );
			}
			
			$(@"#header-carema").SHOW();
			$(@"#carema").SHOW();
			$(@"#signin").HIDE();
            
//            if ( userModel.user.rank_level.integerValue == RANK_LEVEL_NORMAL )
//            {
//                $(@"#header-level-icon").HIDE();
//            }
//            else
//            {
                $(@"#header-level-icon").SHOW();
                $(@"#header-level-icon").DATA( @"profile_vip_icon.png" );
//            }
            
//            $(@"#header-level-name").SHOW();
//            $(@"#header-level-name").DATA( userModel.user.rank_name );
		}
		else
		{
			$(@"#header-avatar").IMAGE( [UIImage imageNamed:@"profile_no_avatar_icon.png"] );
			$(@"#header-carema").HIDE();
			$(@"#carema").HIDE();
			$(@"#signin").SHOW();
            $(@"#header-level-icon").HIDE();
            $(@"#header-level-name").HIDE();
		}
    }
}

@end
