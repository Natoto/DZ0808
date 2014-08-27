//
//  B3_QuickReplyView.h
//  DZ
//
//  Created by Nonato on 14-7-14.
//
//

#import <UIKit/UIKit.h>
@class B3_QuickReplyView;
@protocol B3_QuickReplyViewDelegate <NSObject>
-(void)B3_QuickReplyView:(B3_QuickReplyView *)QuickReplyView replybtnTap:(id)sender;
//-(void)B3_QuickReplyView:(B3_QuickReplyView *)QuickReplyView facailBtnTap:(id)sender;
-(void)B3_QuickReplyView:(B3_QuickReplyView *)QuickReplyView  TextView:(id)sender active:(BOOL)active;
@end

@interface B3_QuickReplyView : UIView
{
    UIButton * sendbtn;
    BeeUITextView   * replayField;
}
@property(nonatomic,retain)  UIButton * sendbtn;
@property(nonatomic,retain)  BeeUITextView   * replayField;
@property(nonatomic,assign)NSObject <B3_QuickReplyViewDelegate> *delegate;
@property(nonatomic,retain)NSString * placeholder;
@property(nonatomic,assign)BOOL       saveView;
-(void)showInView:(CGRect)frame;
-(void)Hide;
@end
