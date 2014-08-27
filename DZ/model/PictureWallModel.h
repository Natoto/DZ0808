//
//  PictureWallModel.h
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//

#import "Bee_StreamViewModel.h"
#import "picturewall.h"
@interface PictureWallModel : BeeStreamViewModel
@property (nonatomic, retain) NSString       *  last_tid;
@property (nonatomic, retain) NSMutableArray *	shots; 
@end
