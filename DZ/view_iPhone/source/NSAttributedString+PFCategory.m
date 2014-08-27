//
//  NSAttributedString+PFCategory.m
//  DZ
//
//  Created by PFei_He on 14-7-3.
//
//

#import "NSAttributedString+PFCategory.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (PFCategory)

+ (NSAttributedString *)getAttributedString:(NSString *)string
{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    //把this的字体颜色变为红色
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor redColor].CGColor
                        range:NSMakeRange(0, 4)];
    //把is变为黄色
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor yellowColor].CGColor
                        range:NSMakeRange(5, 2)];

    //改变this的字体，value必须是一个CTFontRef
//    [attriString addAttribute:(NSString *)kCTFontAttributeName
//                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:14].fontName, 14, NULL))range:NSMakeRange(0, 4)];

    //给this加上下划线，value可以在指定的枚举中选择
//    [attriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
//                        value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble]
//                        range:NSMakeRange(0, 4)];

    return attriString;
}

- (NSAttributedString *)getAttributedString
{
    return [NSAttributedString getAttributedString:self.attributedString];
}

@end

@implementation NSAttributedStringView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    NSAttributedString *attributedString;
    NSAttributedString *attriString = [attributedString getAttributedString];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
    //    CGContextTranslateCTM(ctx, 0, rect.size.height);
    //    CGContextScaleCTM(ctx, 1, -1);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attriString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frame, ctx);

    CFRelease(path);
    //    CFRelease(framesetter);
    //    CFRelease(frame);
}

@end
