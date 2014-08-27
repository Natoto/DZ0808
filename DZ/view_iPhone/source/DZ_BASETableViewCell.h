//
//  DZ_BASETableViewCell.h
//  DZ
//
//  Created by Nonato on 14-6-23.
//
//

#import <UIKit/UIKit.h>
#import "ToolsFunc.h"
#import "UIImage+Bundle.h"
@interface UITableViewCell(HBackground)
// : UITableViewCell
@property(nonatomic,retain)  CALayer   * bottomBorder;
//@property(nonatomic,assign) id classtype;
-(void)datachange:(id)object;
-(void)addbackgroundView:(UIImageView *)hbackgroundImageView;
@end
