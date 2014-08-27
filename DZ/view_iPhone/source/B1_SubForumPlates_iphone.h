//
//  B0_SonForumPlates_iphone.h
//  DZ
//
//  Created by Nonato on 14-4-9.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_UIBoard.h"
#import "Bee.h"
#import "rmbdz.h"
#import "SubForumsModel.h"
#import "TopiclistModel.h"
#import "PostlistModel.h"
#import "BaseBoard_iPhone.h"
@interface B1_SubForumPlates_iphone : BaseBoard_iPhone<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) FORUMS *forums;
@property(nonatomic,retain) FORUMS *subforums;

AS_MODEL(SubForumsModel, subfmModel);
AS_MODEL(TopiclistModel, topicModel);
AS_MODEL(PostlistModel, postmodel);
@end
