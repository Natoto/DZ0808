//
//  D1_FriendsTableViewCell.m
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D1_FriendsTableViewCell.h"
#import "Bee.h"
#import "friends.h"
@implementation D1_FriendsTableViewCell
@synthesize message;
@dynamic havenewmessage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addbackgroundView:nil];
        avatar=[[BeeUIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        KT_IMGVIEW_CIRCLE(avatar, 1);
        avatar.backgroundColor=[UIColor grayColor];
        avatar.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(avatarTap:)];
        [avatar addGestureRecognizer:tap];
        
        [self addSubview:avatar];
        
        name=[[UILabel alloc] init];
        KT_LABELEWIFRAM(name, CGRectMake(70, 5, 200, 40), @"", 18, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentLeft, NO);
        [self addSubview:name];
        
        message=[[UILabel alloc] init];
        KT_LABELEWIFRAM(message, CGRectMake(70, 40, 100, 40), @"", 14, [UIColor clearColor], [UIColor grayColor], NSTextAlignmentLeft, NO);
        [self addSubview:message];
        
        time=[[UILabel alloc] init];
        KT_LABELEWIFRAM(time, CGRectMake(200, 20, 100, 40), @"", 15, [UIColor clearColor], [UIColor grayColor], NSTextAlignmentRight, NO);
        [self addSubview:time];
        
        redpt = [[RedPoint alloc] initWithFrame:CGRectMake(290,10, 10, 10)];
        redpt.alpha = 0.7;
        [self addSubview:redpt];
    }
    return self;
}

-(BOOL)havenewmessage
{
    return !redpt.hidden;
}

-(void)setHavenewmessage:(BOOL)havenewmessage
{
    redpt.hidden = !havenewmessage;
}

+(float)heightOfFriendsCell
{
    return 90;
}

-(void)avatarTap:(UIGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_FriendsTableViewCell:avator:)]) {
        [self.delegate D1_FriendsTableViewCell:self avator:gesture.view];
    }
}
-(void)setcellData:(friends *)myfriends
{
    self.thisfriend=myfriends;
//    avatar.data=myfriends.avatar;
    [avatar GET:myfriends.avatar useCache:YES];
    name.text=myfriends.username;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
