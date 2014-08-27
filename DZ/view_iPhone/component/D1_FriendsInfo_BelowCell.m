//
//  D1_FriendsInfo_BelowCell.m
//  DZ
//
//  Created by Nonato on 14-6-17.
//
//

#import "D1_FriendsInfo_BelowCell.h"
#import "UIImage+Tint.h"
@implementation D1_FriendsInfo_BelowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bottomBorder = [[UIImageView alloc] init];
        
        float height= [D1_FriendsInfo_BelowCell heightOfD1_FriendInfo_BelowCell] - LINE_LAYERBOARDWIDTH;
        float width=self.frame.size.width;
        bottomBorder.frame = CGRectMake(0, height, width, LINE_LAYERBOARDWIDTH);
        bottomBorder.backgroundColor =LINE_LAYERBOARD_NOTCGCOLOR;
        [self addSubview:bottomBorder];
    }
    return self;
}
+(float)heightOfD1_FriendInfo_BelowCell
{
    return 38.0f;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
