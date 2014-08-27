//
//  UITextView_Boarder.m
//  DZ
//
//  Created by Nonato on 14-7-3.
//
//
#import "UITextView_Boarder.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITextView_Boarder
 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (!self.noboarder) {
            self.layer.borderColor = LINE_LAYERBOARDCOLOR; //[[UIColor colorWithWhite:0.8 alpha:1] CGColor];
            self.layer.borderWidth = LINE_LAYERBOARDWIDTH;
            self.layer.cornerRadius = 0.0f;
            self.font =[UIFont systemFontOfSize:14.0];
            [self.layer setMasksToBounds:YES];
        }
         self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self.showsVerticalScrollIndicator = NO;
        _placeHolderColor = [UIColor grayColor];
    }
    return self;
} 


- (void)drawRect:(CGRect)rect
{
//	[self updatePlaceHolder];
    [super drawRect:rect];
} 

- (void)updatePlaceHolder
{
    return;
	if ( [_placeholder length] > 0 )
    {
        if ( nil == _placeHolderLabel )
        {
			CGRect labelFrame = CGRectMake( 9.0f, 8.0f, self.frame.size.width, 0.0f );
            
			_placeHolderLabel = [[UILabel alloc] initWithFrame:labelFrame];
			_placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;// UILineBreakModeCharacterWrap;
			_placeHolderLabel.numberOfLines = 1;
			_placeHolderLabel.font =  self.font;
			_placeHolderLabel.backgroundColor = [UIColor clearColor];
			_placeHolderLabel.textColor = _placeHolderColor;
			_placeHolderLabel.alpha = 0.0f;
			_placeHolderLabel.opaque = NO;
            [self addSubview:_placeHolderLabel];
        }
		
		_placeHolderLabel.frame = CGRectMake(_placeHolderLabel.frame.origin.x, _placeHolderLabel.frame.origin.y, self.frame.size.width, 0);
		_placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;// LineBreakModeCharacterWrap;
		_placeHolderLabel.numberOfLines = 1;
		_placeHolderLabel.text = self.placeholder;
		[_placeHolderLabel sizeToFit];
		[self sendSubviewToBack:_placeHolderLabel];
    }
	
	if ( _placeHolderLabel )
	{
		_placeHolderLabel.text = _placeholder;
		[_placeHolderLabel sizeToFit];
        
		if ( [_placeholder length] > 0 )
		{
			if ( 0 == [self.text length] )
			{
				[_placeHolderLabel setAlpha:1.0f];
			}
			else
			{
				[_placeHolderLabel setAlpha:0.0f];
			}
		}
	}
}

- (void)contentSizeToFit {
    if([self.text length]>0) {
        CGSize contentSize = self.contentSize;
        //NSLog(@"w:%f h%f",contentSize.width,contentSize.height);
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        if(contentSize.height <= self.frame.size.height) {
            CGFloat offsetY = (self.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else {
            newSize = self.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 18;
            while (contentSize.height > self.frame.size.height) {
                [self setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize]];
                contentSize = self.contentSize;
            }
            newSize = contentSize;
        }
        [self setContentSize:newSize];
        [self setContentInset:offset];
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
