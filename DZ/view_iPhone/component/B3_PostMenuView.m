//
//  B3_PostMenuView.m
//  DZ
//
//  Created by Nonato on 14-5-23.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "UIImage+Tint.h"
#import "B3_PostMenuView.h"
//#import "bee.h"

@implementation B3_PostMenuView

DEF_SINGLETON(B3_PostMenuView)

DEF_NOTIFICATION(onlyReadBuildingOwner)
DEF_NOTIFICATION(allRead)
DEF_NOTIFICATION(reply)
DEF_NOTIFICATION(share)
DEF_NOTIFICATION(collect)
DEF_NOTIFICATION(delcollection)

#define BTNTXTCOLOR [UIColor whiteColor]
#define BACKGROUNDVIEWCOLOR HEX_RGBA(0x3f3f3f, 0.95)
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor =[UIColor clearColor]; //[UIColor colorWithRed:241./255 green:241/255. blue:241/255 alpha:1];//WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        UIImageView *triangle=[[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"jiantou"]];
        triangle.image = [triangle.image imageWithTintColor:BACKGROUNDVIEWCOLOR];
        triangle.frame = CGRectMake(200+102-20, 64.0f-15.0f, 20, 20);
        triangle.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:triangle];
        [self addSubview:self.backGroundView];
        
    }
    return self;
}

-(IBAction)BTNACTIONS:(id)sender
{
    UIButton *tapedBtn=(UIButton *)sender;
    for (int index=0; index<4; index++) {
        UIButton *button=(UIButton *)[_backGroundView viewWithTag:index + ITEMSSTARTTAG];
        if (button.tag==tapedBtn.tag) {
//            [button setTitleColor:[UIColor colorWithRed:16/255. green:150/255. blue:237./255. alpha:1] forState:UIControlStateNormal];
//            if (button.tag == 3 + ITEMSSTARTTAG)
//                [button setTitle:@"取消收藏" forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    [self sendSelfUISignal:tapedBtn];
    [self tappedCancel];
}

-(void)sendSelfUISignal:(UIButton *)button
{
    switch (button.tag) {
        case ITEMSSTARTTAG:
            if ([button.titleLabel.text isEqualToString:@"只看楼主"]) {
                [self postNotification:self.onlyReadBuildingOwner];
                [button setTitle:@"全部" forState:UIControlStateNormal];
            }
            else
            {
                [button setTitle:@"只看楼主" forState:UIControlStateNormal];
                [self postNotification:self.allRead];
            }
            break;
        case ITEMSSTARTTAG + 1:
            [self postNotification:self.reply];
            break;
        case ITEMSSTARTTAG + 2:
            [self postNotification:self.share];
            break;
        case ITEMSSTARTTAG + 3:
            if ([button.titleLabel.text isEqualToString:@"收藏"]) {
                [self postNotification:self.collect];
                [button setTitle:@"取消收藏" forState:UIControlStateNormal];
            } else {
                [button setTitle:@"收藏" forState:UIControlStateNormal];
                [self postNotification:self.delcollection];
            }
            break;
        default:
            break;
    }
}

-(UIView *)backGroundView
{ 
   if (!_backGroundView) {
       _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(200, 64.0f , 102, 150)];
       _backGroundView.backgroundColor= BACKGROUNDVIEWCOLOR;
       //[UIColor colorWithRed:241./255 green:241./255. blue:241./255. alpha:1];
        items= [[NSArray alloc] initWithObjects:@"只看楼主",@"回复",@"分享",@"收藏", @"取消收藏", nil];
        float HEIGHT=35;
        float WIDTH=_backGroundView.frame.size.width;
        for (int index=0; index<items.count - 1; index++) {
            UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT * index + 5, WIDTH , HEIGHT)];
            [button addTarget:self action:@selector(BTNACTIONS:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:BTNTXTCOLOR forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.tag=ITEMSSTARTTAG + index;
            [button setTitle:[items objectAtIndex:index] forState:UIControlStateNormal];
            [_backGroundView addSubview:button];
        }
    }
    return _backGroundView;
}

-(void)setIsfavorite:(NSNumber *)isfavorite
{
    _isfavorite = isfavorite;
    UIButton *button=(UIButton *)[_backGroundView viewWithTag: ITEMSSTARTTAG + 3];
    if (button.tag == ITEMSSTARTTAG + 3) {
        if (isfavorite.integerValue == 1) {//变为取消收藏
            [button setTitle:[items objectAtIndex:4] forState:UIControlStateNormal];
            NSLog(@"%@", [items objectAtIndex:4]);
        } else {//变为收藏
            [button setTitle:[items objectAtIndex:3] forState:UIControlStateNormal];
        }
    }
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}

-(void)showInView:(UIView *)view
{
    [self.backGroundView setFrame:CGRectMake(200, 64.0f - bee.ui.config.heightOfStatusBar, 102, 150)];
    self.alpha = 1;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(200, 64.0f - bee.ui.config.heightOfStatusBar, 102, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];

    if ([self.isfavorite isEqualToNumber:[NSNumber numberWithInt:0]]) {
        self.isfavorite = [NSNumber numberWithInt:1];
    } else {
        self.isfavorite = [NSNumber numberWithInt:0];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
