//
//  B3_ReplyPostViewController.h
//  DZ
//
//  Created by Nonato on 14-6-12.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#define TOP_VIEW_HEIGHT 33.0f
#define TOP_VIEW_WIDTH 48.0f
#import "Bee.h"
#import <UIKit/UIKit.h>
#import "SETextView.h"
#import "C0_HairPost_ToolsView.h"
#import "FaceBoard.h"
#import "BeeUIBoard+ViewController.h"
#import "postlist.h"
@interface B3_PostReplyViewController : BeeUIBoard_ViewController<UIAlertViewDelegate>
{
      FaceBoard *inputView;
}
AS_SIGNAL(didpostImage)
@property(nonatomic,strong) SETextView  * fastTextView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) C0_HairPost_ToolsView *toolsview;
@property(nonatomic,strong)NSString * fid;
@property(nonatomic,strong)NSString * tid;
@property(nonatomic,strong)NSString * pid;
@property(nonatomic,retain)post * friendpost;

@end
