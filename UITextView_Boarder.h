//
//  UITextView_Boarder.h
//  DZ
//
//  Created by Nonato on 14-7-3.
//
//

#import <UIKit/UIKit.h> 
/*
@class UITextView_Boarder;
@interface UITextView_BoarderAgent : NSObject<UITextViewDelegate>
{
//	UITextView_Boarder *	_target;
}
@property (nonatomic, assign) UITextView_Boarder *	target;
@end*/

@interface UITextView_Boarder : UITextView  
@property(nonatomic,retain) UILabel  * placeHolderLabel;
@property(nonatomic,retain) NSString * placeholder;
@property(nonatomic,retain) UIColor  * placeHolderColor;
@property(nonatomic,assign) BOOL       noboarder;
- (void)updatePlaceHolder;
@end
