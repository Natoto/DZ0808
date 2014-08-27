//
//  D3_MSG_IgnoreView.h
//  DZ
//
//  Created by Nonato on 14-7-21.
//
//

#import <UIKit/UIKit.h>

@interface D3_MSG_IgnoreView : UIView
{
    CALayer * bottomBorder;
}
@property(nonatomic,strong)UIButton *ignoreButton;
@property(nonatomic,strong)UILabel  *ignoreLabel;
@property(nonatomic,assign)BOOL ignoreMessage;
@property(nonatomic,strong)NSString * recievemessage;
- (id)initWithFrame:(CGRect)frame sel:(SEL)ignoreMessages target:(id)target;
+(float)heightOfView;
@end

