//
//  CreateComponent+NSObject.m
//  DZ
//
//  Created by Nonato on 14-8-5.
//
//

#import "CreateComponent.h"
#import "Bee.h"
@implementation CreateComponent

+(BeeUITextView *)CreateTextviewWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    BeeUITextView *label = [[BeeUITextView alloc] initWithFrame:frame];
    //    label.noboarder = YES;
    //    label.NONEEDUSERETURN = YES;
    label.placeholder = TXT;
    label.font = GB_FontHelveticaNeue(15);//[UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;;
    return label;
}

+(UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = TXT;
    label.font = GB_FontHelveticaNeue(15);//[UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}


+(UIButton *)CreateButtonWithFrame:(CGRect)frame andImage:(NSString *)image tag:(int)tag title:(NSString *)title titlecolor:(UIColor *)titlecolor target:(id)target sel:(SEL)selector bgcolor:(UIColor *)bgcolor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = frame;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:bgcolor];
    [button setTitleColor:titlecolor forState:UIControlStateNormal];
    return button;
}

+(UIButton *)CreateButtonWithFrame:(CGRect)frame andImage:(NSString *)image tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"images.bundle/%@",image]];
    [button setImage:img forState:UIControlStateNormal];
    button.frame = frame;
    button.tag = tag;
    //    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

#pragma mark - used in profilecell

+(BeeUIImageView *)CreateImageViewWithFrame:(CGRect)frame andImgName:(NSString *)imgname
{
    BeeUIImageView *imgView=[[BeeUIImageView alloc] initWithFrame:frame];
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    //    imgView.data=imgname;
    imgView.image=[UIImage bundleImageNamed:imgname];
    return imgView;
}
//
//+ (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:frame];
//    label.text = TXT;
//    label.font = GB_FontHelveticaNeue(15);//[UIFont systemFontOfSize:15];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    return label;
//}
//
+ (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT txtcolor:(UIColor *)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
    [button setTitle:TXT forState:UIControlStateNormal];
    button.frame = frame;
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}
//
+ (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [button setTitle:TXT forState:UIControlStateNormal];
    button.frame = frame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

@end
