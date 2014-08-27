//
//  C0_HairPost_ToolsView.h
//  DZ
//
//  Created by Nonato on 14-4-28.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C0_HairPost_ToolsView : UIView

- (id)initWithFrame:(CGRect)frame withTarget:(id)delegate andFacialSel:(SEL)facialTap andpictureSel:(SEL)pictureTap andkeyboardSel:(SEL)keyboardTap;
-(void)showKeyboardBtn:(BOOL)show;
@end
