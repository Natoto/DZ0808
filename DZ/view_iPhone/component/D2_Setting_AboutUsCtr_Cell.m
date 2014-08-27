//
//  D2_Setting_AboutUsCtr_Cell.m
//  DZ
//
//  Created by Nonato on 14-7-17.
//
//

#import "D2_Setting_AboutUsCtr_Cell.h"
#import "RCLabel.h"
#define MARGIN_X 15
@implementation D2_Setting_AboutUsCtr_Cell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addbackgroundView:nil];
        textlabel =[[RCLabel alloc] initWithFrame:CGRectMake(MARGIN_X, 5, 320 - 2*MARGIN_X,  10)];
        [self addSubview:textlabel];
    }
    return self;
}

-(void)datachange:(id)object
{
    [super datachange:object];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:(NSString *)self.classtype];
    textlabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [textlabel optimumSize];
    textlabel.frame=CGRectMake(MARGIN_X, 5, self.frame.size.width - 2*MARGIN_X,optimumSize.height);
}

+(float)heightOfcell:(NSString *)text
{
    RCLabel *label =[[RCLabel alloc] initWithFrame:CGRectMake(MARGIN_X, 5, 320 - 2*MARGIN_X,  10)];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:text];
    label.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [label optimumSize];
    return optimumSize.height + 10;
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
