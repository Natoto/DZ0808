//
//  A1_WebmasterRecommend_HeaderCell.h
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_UICell.h"
#import "bee.h"
#import "DZ_BASETableViewCell.h"
@interface A1_WebmasterRecommend_HeaderCell : UITableViewCell
{
    UIButton *chakan;
    UIButton *reply;
    UILabel  *message;
}

@property(nonatomic,retain)BeeUIImageView * ImgeView;
@property(nonatomic,retain)UILabel *label;

@property(nonatomic,strong)UILabel * lbltitle;
@property(nonatomic,strong)UILabel * lbllandlord;
@property(nonatomic,strong)UILabel * lblreadl;
@property(nonatomic,strong)UILabel * lblreply;
@property(nonatomic,strong)UILabel * lbltime;

@end
