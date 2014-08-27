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

#import "HomePageModel.h"

#pragma mark -

@implementation HomePageModel

DEF_SINGLETON( HomePageModel )
DEF_NOTIFICATION(HOMEPAGE)
@synthesize homepage=_homepage;

- (void)load
{
    self.homepage=[[HOMEPAGE alloc] init];
	[self loadCache];
}

- (void)unload
{
	[self saveCache];
    self.homepage=nil;
}

#pragma mark -

- (void)loadCache
{
	self.homepage=nil;
    self.homepage=[HOMEPAGE readFromUserDefaults:@"HomePageModel.homepage"];
}

- (void)saveCache
{
//	[BANNER userDefaultsWrite:[self.banners objectToString] forKey:@"BannerModel.banners"];
	[HOMEPAGE userDefaultsWrite:[self.homepage objectToString] forKey:@"HomePageModel.homepage"];
}

- (void)clearCache
{
	[HOMEPAGE removeFromUserDefaults:@"HomePageModel.homepage"];
    self.homepage =nil;
	self.loaded = NO;
}

-(void)clearArrangedPosition
{
//    HOMETOPICSPOSITIONITEM.DB.EMPTY();
//    if (self.ArrangedPositionAry.count) {
//        [self.ArrangedPositionAry removeAllObjects];
//        self.ArrangedPositionAry=nil;
//    }

}
- (void)saveArrangedPosition:(NSArray *)topicsAry
{
//    HOMETOPICSPOSITIONITEM.DB.EMPTY();
//    NSArray *array =HOMETOPICSPOSITIONITEM.DB.GET_RECORDS();
//    self.ArrangedPositionAry=(NSMutableArray *)topicsAry;
//    for (HOMETOPICSPOSITIONITEM *item in topicsAry) {
//        item.SAVE();
//    }
    
}
-(NSArray *)loadArrangedPosition
{
//    NSArray *array=HOMETOPICSPOSITIONITEM.DB.GET_RECORDS();
//    self.ArrangedPositionAry=(NSMutableArray *)array;
//    return array;
    return nil;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.home );
	self.MSG( API.home);
}

#pragma mark -

ON_MESSAGE3( API, home, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT(@"status" );
		if ( 0 != status.ecode.integerValue )
		{
			msg.failed = YES;
			return;
		}
        self.homepage=nil;
        self.homepage=msg.GET_OUTPUT(@"homedata");
		self.loaded = YES;
		[self saveCache];
        [self postNotification:self.HOMEPAGE];
	}
    else if (msg.failed)
    {
        BeeLog(@"failed------%@",msg.description);
    }
    
}

@end
