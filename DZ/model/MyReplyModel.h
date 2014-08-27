//
//  MyReplyModel.h
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "Bee.h"
#import "myreply.h"
@interface MyReplyModel : BeeStreamViewModel
{
    NSString  *key;
}
@property (nonatomic, retain) NSString          *    uid;
@property (nonatomic,retain)  NSMutableArray    *    shots;
@end
