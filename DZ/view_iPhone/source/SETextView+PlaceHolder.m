//
//  SETextView+PlaceHolder.m
//  DZ
//
//  Created by Nonato on 14-7-12.
//
//

#import "SETextView+PlaceHolder.h"

@implementation SETextView(PlaceHolder)

- (void)updatePlaceHolder
{
//    if (self.placeholder.length) {
        return;
//    }
	if ( [self.placeholder length] > 0 )
    {
        if ( nil == self.placeHolderLabel )
        {
			CGRect labelFrame = CGRectMake( 9.0f, 8.0f, self.frame.size.width, 0.0f );
            
			self.placeHolderLabel = [[UILabel alloc] initWithFrame:labelFrame];
			self.placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;// UILineBreakModeCharacterWrap;
			self.placeHolderLabel.numberOfLines = 1;
			self.placeHolderLabel.font =  self.font;
			self.placeHolderLabel.backgroundColor = [UIColor clearColor];
			self.placeHolderLabel.textColor = [UIColor grayColor];
			self.placeHolderLabel.alpha = 0.0f;
			self.placeHolderLabel.opaque = NO;
            [self addSubview:self.placeHolderLabel];
        }
		
		self.placeHolderLabel.frame = CGRectMake(self.placeHolderLabel.frame.origin.x, self.placeHolderLabel.frame.origin.y, self.frame.size.width, 0);
		self.placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;// LineBreakModeCharacterWrap;
		self.placeHolderLabel.numberOfLines = 1;
		self.placeHolderLabel.text = self.placeholder;
		[self.placeHolderLabel sizeToFit];
		[self sendSubviewToBack:self.placeHolderLabel];
    }
	
	if ( self.placeHolderLabel )
	{
		self.placeHolderLabel.text = self.placeholder;
		[self.placeHolderLabel sizeToFit];
        
		if ( [self.placeholder length] > 0 )
		{
			if ( 0 == [self.text length] )
			{
				[self.placeHolderLabel setAlpha:1.0f];
			}
			else
			{
				[self.placeHolderLabel setAlpha:0.0f];
			}
		}
	}
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
