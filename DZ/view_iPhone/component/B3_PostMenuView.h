//
//  B3_PostMenuView.h
//  DZ
//
//  Created by Nonato on 14-5-23.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "bee.h"
#import <UIKit/UIKit.h>

#define ANIMATE_DURATION                        0.25f
#define ITEMSSTARTTAG                           1447

@interface B3_PostMenuView : UIView
{
    NSArray *items;
}
AS_SINGLETON(B3_PostMenuView)
AS_NOTIFICATION(onlyReadBuildingOwner)
AS_NOTIFICATION(allRead)
AS_NOTIFICATION(reply)
AS_NOTIFICATION(share)
AS_NOTIFICATION(collect)
AS_NOTIFICATION(delcollection)

@property(nonatomic,strong)UIView * backGroundView;
@property(nonatomic,strong)NSArray * array;
@property (nonatomic, strong) NSNumber *isfavorite;

-(void)showInView:(UIView *)view;

@end
