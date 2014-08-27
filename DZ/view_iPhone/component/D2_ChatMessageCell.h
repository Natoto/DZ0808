//
//  MessageCell.h
//  15-QQ聊天布局
//
//  Created by Nonato on 13-12-3.
//  Copyright (c) 2013年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Bundle.h"
@class D2_ChatMessageCell;
@protocol D2_ChatMessageCellDelegate <NSObject>
-(void)cellDidLongPress:(D2_ChatMessageCell *)cell recoginzer:(UIGestureRecognizer *)recognizer;
@end


@class D2_ChatMessageFrame;

@interface D2_ChatMessageCell : UITableViewCell
@property(nonatomic,assign) NSObject <D2_ChatMessageCellDelegate> *delegate;
@property (nonatomic, strong) D2_ChatMessageFrame *messageFrame;
@property(nonatomic,strong) NSIndexPath * indexPath;
@end
