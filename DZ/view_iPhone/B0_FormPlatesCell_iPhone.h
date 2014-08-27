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
#import "forumlist.h"
#import "UIImage+Bundle.h"
#pragma mark -

/**
 * 搜索-列表项cell
 */
@protocol B0_FormPlatesCell_iPhoneDelegate <NSObject>
-(void)buttonPressedTap:(id)obj indexPath:(NSIndexPath *)indexPath mark:(BOOL)mark;
@end

@interface B0_FormPlatesCell_iPhone : UITableViewCell
@property(nonatomic,retain)UILabel *textlabel;
@property(nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic,retain)child * achild;
@property(nonatomic,retain)NSString *mark;
@property(nonatomic,retain)UIButton *accorybutton;
@property(nonatomic,assign) id <B0_FormPlatesCell_iPhoneDelegate> delegate;
@end
