//
//  D1_MyReplyViewController.h
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
typedef enum : NSUInteger {
    MYREPLY_MY,
    MYREPLY_OTHERS,
} MYREPLY_TYPE;
#import <UIKit/UIKit.h>
#import "Base_TableviewController.h"
@class D1_Reply_MyViewController;
@protocol D1_Reply_MyViewControllerDelegate <NSObject>
- (void)D1_Reply_MyViewController:(D1_Reply_MyViewController *)controller cellSelectedWithTid:(NSString *)tid;
@end

@interface D1_Reply_MyViewController : Base_TableviewController
@property (nonatomic, assign) NSObject <D1_Reply_MyViewControllerDelegate> *delegate;
@property (nonatomic, strong) NSString    * uid;
@property (nonatomic, strong) NSString    * username;
@property (nonatomic, strong) NSString    * newtitle;
@property (nonatomic, assign) MYREPLY_TYPE  replytype;
@end
