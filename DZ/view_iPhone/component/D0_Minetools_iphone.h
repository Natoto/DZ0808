//
//  E0_MINETOLLS_iphone.h
//  DZ
//
//  Created by Nonato on 14-4-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
/*
 <image id="avatar" class="avatar"/>
 <label id="name" class="list-title">版本升级</label>
 <!-- <image class="list-indictor"/>-->
 <button id="BUTTON" class="mask"/>
 */
#import "Bee_UICell.h"
#import "bee.h"
@interface D0_MineTools_iphone : UITableViewCell
AS_SIGNAL(BUTTONTAP)
@property(nonatomic,strong) BeeUIImageView * avatar;
@property(nonatomic,strong) BeeUILabel     * name; 
@property(nonatomic,strong) BeeUIButton * BUTTON;
@end
