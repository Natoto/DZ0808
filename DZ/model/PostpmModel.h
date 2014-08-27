//
//  PostpmModel.h
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "Bee.h"


@class POSTPM;
@interface PostpmModel : BeeStreamViewModel
@property (nonatomic, retain) NSString          *    uid;
@property (nonatomic,retain)  NSString          *    touid;
@property(nonatomic,retain)   NSString          *    message;
@property(nonatomic,retain)   POSTPM            *   resp;
@end
