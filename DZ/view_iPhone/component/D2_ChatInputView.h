//
//  D2_ChatInputView.h
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "FaceBoard.h"
@protocol D2_ChatInputViewDelegate <NSObject>
- (BOOL)D2_ChatInputdShouldSendMessage:(UITextView *)textField;

@optional
-(BOOL)D2_ChatInputdresignFirstResponder:(UITextView *)textField;
@end
@class FaceBoard;
@interface D2_ChatInputView : UIView<UITextViewDelegate,FaceBoardDelegate>
{
    UIButton    * sendbtn;
    UITextView  * replayField;
    FaceBoard   * facialView;
}
@property(nonatomic,assign)NSObject<D2_ChatInputViewDelegate> *delegate;
@property(nonatomic,retain)UITextView *replayField;
 -(void)resignFirstReponder;
@end
