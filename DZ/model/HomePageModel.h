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

#import "Bee.h"
#import "rmbdz.h"

#pragma mark -

@interface HomePageModel : BeeOnceViewModel

AS_SINGLETON( HomePageModel )
AS_NOTIFICATION(HOMEPAGE)
//@property (nonatomic, retain) NSMutableArray *	banners;
@property (nonatomic, retain) HOMEPAGE     * homepage;
@property(nonatomic,retain) NSMutableArray * ArrangedPositionAry;

-(NSArray *)loadArrangedPosition;
-(void)clearArrangedPosition;
- (void)saveArrangedPosition:(NSArray *)topicsAry;
@end

