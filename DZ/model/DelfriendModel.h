//
//  DelfriendModel.h
//  DZ
//
//  Created by Nonato on 14-6-18.
//
//

#import "Bee_StreamViewModel.h"
#import "delfriend.h"
@interface DelfriendModel : BeeStreamViewModel
@property (nonatomic, retain) NSString          *    uid;
@property (nonatomic, retain) NSString          *    fid;
@property (nonatomic,retain)  DELFRIEND         *    shots;
@end
