//
//  DZ_BASETableViewCell.m
//  DZ
//
//  Created by Nonato on 14-6-23.
//
//

#import "DZ_BASETableViewCell.h"
#import "Bee.h"
#import "UIImage+Tint.h"
@implementation  UITableViewCell(HBackground)
//@dynamic  hbackgroundImageView ;
//@dynamic  classtype;
@dynamic bottomBorder;

-(void)addbackgroundView:(UIImageView *)hbackgroundImageView
{
    if (!hbackgroundImageView) {
        hbackgroundImageView = [[UIImageView alloc] init];
        UIImage *imagea = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(320, 30)];
        hbackgroundImageView.image = imagea;
    }
    [self setBackgroundView:hbackgroundImageView];
//    self.backgroundColor = [UIColor whiteColor];
}

-(CALayer *)bottomBorder
{
    if (!self.bottomBorder) {
        CALayer *btb =[CALayer layer];
        float left = bee.ui.config.separatorInset.left;
        float height=self.frame.size.height-1.0f;
        float width=self.frame.size.width - 2 * bee.ui.config.separatorInset.left ;
        btb.frame = CGRectMake(left, height, width  , LINE_LAYERBOARDWIDTH);
        btb.backgroundColor =LINE_LAYERBOARDCOLOR;
        if (IOS7_OR_LATER) {
            btb.hidden = YES;
        }
        else
        {
        }
        [self.contentView.layer addSublayer:btb];
        self.contentMode = UIViewContentModeRedraw;
    }
    float left = bee.ui.config.separatorInset.left;
    float height=self.frame.size.height-1.0f;
    float width=self.frame.size.width - 2 * bee.ui.config.separatorInset.left ;
    self.bottomBorder.frame = CGRectMake(left, height, width  , 1.0f);
    return self.bottomBorder;
}

/*
-(void)layoutSepertorLineSubviews:(CALayer *)bottomBorder
{
    if (bottomBorder) {
        float left = bee.ui.config.separatorInset.left;
        float height=self.frame.size.height-1.0f;
        float width=self.frame.size.width - 2 * bee.ui.config.separatorInset.left ;
        bottomBorder.frame = CGRectMake(left, height, width  , LINE_LAYERBOARDWIDTH);
        bottomBorder.backgroundColor =LINE_LAYERBOARDCOLOR;
        if (IOS7_OR_LATER) {
            bottomBorder.hidden = YES;
        }
        else
        {
        }
        [self.contentView.layer addSublayer:bottomBorder];
        self.contentMode = UIViewContentModeRedraw;
    }
    float left = bee.ui.config.separatorInset.left;
    float height=self.frame.size.height-1.0f;
    float width=self.frame.size.width - 2 * bee.ui.config.separatorInset.left ;
    bottomBorder.frame = CGRectMake(left, height, width  , 1.0f);
}*/
-(void)datachange:(id)object
{
}
@end
