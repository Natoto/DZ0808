//
//  TopicTableViewCell.h
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "bee.h"
@interface TopicTableViewCell : UITableViewCell

@property(nonatomic,strong)BeeUIImageView *cellicon;
@property(nonatomic,strong)UILabel * lbltitle;
@property(nonatomic,strong)UILabel * lbllandlord;
@property(nonatomic,strong)UILabel * lblreadl;
@property(nonatomic,strong)UILabel * lblreply;
@property(nonatomic,strong)UILabel * lbltime;
-(void)isOwner:(BOOL)owner;
@end
