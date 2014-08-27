//
//  D2_Feedback.h
//  DZ
//
//  Created by user on 14-5-26.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseBoard_iPhone.h"
#import "FeedbackModel.h"
#import "BeeUIBoard+ViewController.h"
@interface D2_Feedback : BeeUIBoard_ViewController <UITextViewDelegate, UITextFieldDelegate>
{
    UITextView *feedbackText;
    UILabel *feedbackLabel;
}

@property (nonatomic, copy)     NSString                *appId;
@property (nonatomic, assign)   float                    appVersion;
@property (nonatomic, strong)   FeedbackModel           *feedbackModel;
@property (nonatomic, copy)     NSString                *content;
@property (nonatomic, copy)     NSString                *QQ;

@end
