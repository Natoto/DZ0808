    //
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "B0_FormPlatesCell_iPhone.h"
#import "rmbdz.h"
#import "UIImage+Tint.h"
#import "homeModel.h"
#import "Constants.h"
#import "AppDelegate.h"
#pragma mark -

@implementation B0_FormPlatesCell_iPhone

@synthesize indexPath,achild,mark,delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *bgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        bgview.backgroundColor=[UIColor whiteColor];
        [self addSubview:bgview];
    
        _textlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 40)];
        _textlabel.text = [NSString stringWithFormat:@"%@", achild.name];
//        _textlabel.font = GB_FontHelveticaNeue(12);//[UIFont systemFontOfSize:12];
        _textlabel.backgroundColor = [UIColor clearColor];
        _textlabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_textlabel];

        UIImage *image=[UIImage bundleImageNamed:@"tianjia(xin)3"];
        if (mark.intValue) {
            UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
            image = [image imageWithTintColor:color];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect aframe = CGRectMake(0.0 , 0.0 , image.size.width * 4.00 ,image.size.height * 4.00);
        button.tag = achild.fid.intValue;
        button.frame = aframe;
        [button setImage:image forState:UIControlStateNormal];

        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonPressedAction:) forControlEvents:UIControlEventTouchUpInside];
        //        self. accessoryView = button;
        //        CGRect acframe=self.accessoryView.frame;
        self.accorybutton = button;
        button.frame=CGRectMake( self.frame.size.width -  aframe.size.width - 0, -15, aframe.size.width, aframe.size.height);
        [self addSubview:button];
    }
    return self;
}

-(void)setAchild:(child *)child
{
    achild = child;
    _textlabel.text = [NSString stringWithFormat:@"  %@", achild.name.trim];
    _textlabel.font = [UIFont systemFontOfSize:13];
    _textlabel.textColor = [UIColor darkGrayColor];
}

-(void)setMark:(NSString *)amark
{
    mark=amark;
   UIButton *button = (UIButton *)self.accorybutton;
   UIImage *image = [UIImage bundleImageNamed:@"tianjia(xin)3"];
    if (!mark.intValue) {
//        image = [image imageWithTintColor:FORUMCELLNOADDHOMECOLOR];
    }
    else 
    {
         image=[UIImage bundleImageNamed:@"tianjia(xin02)3"];
         UIColor *color =[DZ_SystemSetting sharedInstance].navigationBarColor;
         image = [image imageWithTintColor:color];
//        image = [image imageWithTintColor:FORUMCELLDIDADDHOMECOLOR];
    }
    [button setImage:image forState:UIControlStateNormal];
}

-(IBAction)buttonPressedAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"row == %d",button.tag);
    UIImage *image=[UIImage bundleImageNamed:@"tianjia(xin)3"];
    if (mark.intValue) {//删除一个位置
//          image = [image imageWithTintColor:FORUMCELLNOADDHOMECOLOR];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app presentMessageTips:@"移除版块成功"];
          mark = @"0";
    }
    else//添加一个版块到主页
    {
        mark = @"1";
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app presentMessageTips:@"添加版块成功"];
        image=[UIImage bundleImageNamed:@"tianjia(xin02)3"];
        UIColor *color =[DZ_SystemSetting sharedInstance].navigationBarColor;
        image = [image imageWithTintColor:color];
    }
    [button setImage:image forState:UIControlStateNormal];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(buttonPressedTap:indexPath:mark:)]) {
        [self.delegate buttonPressedTap:self indexPath:indexPath mark:mark.intValue];
    }
}
@end
