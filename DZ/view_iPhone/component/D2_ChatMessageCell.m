//
//  MessageCell.m
//  15-QQ聊天布局
//
//  Created by Nonato on 13-12-3.
//  Copyright (c) 2013年 Nonato. All rights reserved.
//

#import "D2_ChatMessageCell.h"
#import "D2_ChatMessage.h"
#import "D2_ChatMessageFrame.h"
#import "bee.h"
#import "FaceBoard.h"
@interface D2_ChatMessageCell ()
{
    UIButton     *_timeBtn;
    BeeUIImageView *_iconView;
    UIButton    *_contentBtn;
    UIView      *_contentsView;
    NSDictionary *faceMap ;
}

@end

@implementation D2_ChatMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
#warning 必须先设置为clearColor，否则tableView的背景会被遮住
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        [_timeBtn setBackgroundImage:[UIImage bundleImageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[BeeUIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
//        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _contentBtn.titleLabel.font = kContentFont;
//        _contentBtn.titleLabel.numberOfLines = 0;
        _contentBtn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_contentBtn];
        
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [self addGestureRecognizer:longPressGesture];
        
         faceMap = [FaceBoard facailDictionary]; 
       
    }
    return self;
}


-(void)cellLongPress:(UIGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidLongPress:recoginzer:)]) {
        [self.delegate cellDidLongPress:self recoginzer:recognizer];
    }
}

//为了让菜单显示，目标视图必须在responder链中，很多UIKit视图默认并无法成为一个responder，因此你需要使这些视图重载 canBecomeFirstResponder方法，并返回YES
- (BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canResignFirstResponder
{
    return YES;
}
- (void)setMessageFrame:(D2_ChatMessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    D2_ChatMessage *message = _messageFrame.message;
    
    // 1、设置时间
    [_timeBtn setTitle:message.time forState:UIControlStateNormal];
    _timeBtn.frame = _messageFrame.timeF;
    
    // 2、设置头像
    _iconView.data =message.icon; //[UIImage bundleImageNamed:message.icon];
    _iconView.frame = _messageFrame.iconF;
    
    // 3、设置内容
//    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    [_contentBtn removeFromSuperview];
     [_contentsView removeFromSuperview];
      _contentsView = _messageFrame.contentView; //[self assembleMessageAtIndex:message.content from:message.type];
    [_contentBtn addSubview:_contentsView];
    [self.contentView addSubview:_contentBtn];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = _messageFrame.contentF;
    
    if (message.type == MessageTypeMe) {
       _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    } else {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }

    UIImage *normal, *focused;
    if (message.type == MessageTypeMe) {
        normal = [UIImage bundleImageNamed:@"chatto_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:floorf(normal.size.width * 0.5) topCapHeight:floorf(normal.size.height * 0.7)];
        focused = [UIImage bundleImageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        normal = [UIImage bundleImageNamed:@"chatfrom_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:floorf(normal.size.width * 0.5) topCapHeight:floorf(normal.size.height * 0.7)];
        focused = [UIImage bundleImageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, _contentBtn.frame.size.width, _contentBtn.frame.size.height);
//    [button setImage:normal forState:UIControlStateNormal];
//    [_contentBtn addSubview:button];
//    [_contentBtn sendSubviewToBack:button];
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
}

@end
