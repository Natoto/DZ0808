//
//  UITextField_Board.m
//  DZ
//
//  Created by Nonato on 14-7-3.
//
//

#import "UITextField_Board.h"
#import "Bee.h"
@implementation UITextField_Board

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        self.layer.backgroundColor = [[UIColor lightTextColor] CGColor];
        self.layer.borderColor =[[UIColor grayColor] CGColor]; //[[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius =2.0f;
#endif
        self.textAlignment=NSTextAlignmentCenter;
        self.clearButtonMode=UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
