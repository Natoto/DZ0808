//
//  PostmineModel.h
//  DZ
//
//  Created by Nonato on 14-7-31.
//
//

#import "Bee_StreamViewModel.h"
#import "postmine.h"
@interface PostmineModel : BeeStreamViewModel
{
    NSString  *key;
}
@property (nonatomic, retain) NSString          *    uid;
@property (nonatomic,retain)  NSMutableArray    *    shots;
@end
