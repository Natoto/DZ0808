//
//  A0_HomePage1_iphone.h
//  DZ
//
//  Created by Nonato on 14-4-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "A0_BaseHomeViewController.h" 
#import "B0_ForumPlates_iphone.h"
#import "A1_WebmasterRecommend_iphone.h"
#import "A1_Newest_iphone.h"
#import "A1_Hotest_iphone.h"
#import "A1_Digest_iphone.h"
#import "D1_MypostViewController_iphone.h"
#import "homeModel.h"
@interface A0_HomePage1_iphone : A0_BaseHomeViewController<UIScrollViewDelegate>
//AS_MODEL(HomeModel,	 homeModel);
AS_NOTIFICATION(homepageItemChanged)

@property(nonatomic,assign) BOOL reloading; 
@property(nonatomic,strong) homeModel *homeModel;
@property(nonatomic,retain) NSMutableArray *ModeleBlocks;
-(void)saveHomePageUserModel:(NSMutableArray *)array;
@end
