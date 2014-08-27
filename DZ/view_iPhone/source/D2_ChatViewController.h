//
//  D2_ChatViewController.h
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#define DegreesToRadians(x) ((x) * M_PI / 180.0)

#import <UIKit/UIKit.h>
#import "Base_TableviewController.h"
#import "AllpmModel.h"
#import "friends.h"

typedef enum : NSUInteger {
    CHATTYPE_FRIEND,
    CHATTYPE_STRANGER,
} CHATTYPE;

@class D2_ChatViewController;
@protocol D2_ChatViewControllerDelegate <NSObject>
-(void)messageSendSuccess:(D2_ChatViewController *)viewController;
@end

@interface D2_ChatViewController : Base_TableviewController
//@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (nonatomic,retain) friends   * afriend;
@property (nonatomic, assign)NSObject <D2_ChatViewControllerDelegate> *delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSString * selectString;
@property (nonatomic,assign) CHATTYPE  chattype;

@end
