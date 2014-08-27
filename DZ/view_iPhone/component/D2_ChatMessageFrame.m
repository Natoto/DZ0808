//
//  MessageFrame.m
//  15-QQ聊天布局
//
//  Created by Nonato on 13-12-3.
//  Copyright (c) 2013年 Nonato. All rights reserved.
//



#import "D2_ChatMessageFrame.h"
#import "D2_ChatMessage.h"
#import "FaceBoard.h"
@implementation D2_ChatMessageFrame

-(id)init
{
    self = [super init];
    if (self) {
        faceMap  = [FaceBoard facailDictionary];
//        [NSDictionary dictionaryWithContentsOfFile:
//                  [[NSBundle mainBundle]                pathForResource:@"_expression_en"
//                                                                 ofType:@"plist"]];
        
    }
    return self;
}
- (void)setMessage:(D2_ChatMessage *)message{
    
    _message = message;
    
    // 0、获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    // 1、计算时间的位置
    if (_showTime){
        
        CGFloat timeY = kMargin;
//        CGSize timeSize = [_message.time sizeWithAttributes:@{UIFontDescriptorSizeAttribute: @"16"}];
        CGSize timeSize = [_message.time sizeWithFont:kTimeFont];
        NSLog(@"----%@", NSStringFromCGSize(timeSize));
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + kTimeMarginW, timeSize.height + kTimeMarginH);
    }
    // 2、计算头像位置
    CGFloat iconX = kMargin;
    // 2.1 如果是自己发得，头像在右边
    if (_message.type == MessageTypeMe) {
        iconX = screenW - kMargin - kIconWH;
    }

    CGFloat iconY = CGRectGetMaxY(_timeF) + kMargin;
    _iconF = CGRectMake(iconX, iconY, kIconWH, kIconWH);
    
    // 3、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF) + kMargin;
    CGFloat contentY = iconY;
    UIView *view = [self assembleMessageAtIndex:_message.content from:_message.type];
    self.contentView = view;
    CGSize contentSize =view.frame.size;  //[_message.content sizeWithFont:kContentFont constrainedToSize:CGSizeMake(kContentW, CGFLOAT_MAX)];
    
    if (_message.type == MessageTypeMe) {
        contentX = iconX - kMargin - contentSize.width - kContentLeft - kContentRight;
    }
    
    _contentF = CGRectMake(contentX, contentY, contentSize.width + kContentLeft + kContentRight, contentSize.height + kContentTop + kContentBottom);

    // 4、计算高度
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_iconF))  + kMargin;
}



#define BEGIN_FLAG @"["
#define END_FLAG @"]"

#define FACE_FLAG_1 @":"
#define FACE_FLAG_2 @";"

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 150
-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
//    [self getImageRange:message :array];
    [FaceBoard getImageTextRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 10;
    CGFloat X = 0;
    CGFloat Y = KFacialSizeHeight;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            NSLog(@"str--->%@",str);
            NSRange rang=[str rangeOfString:FACE_FLAG_1];
            NSRange rang1=[str rangeOfString:FACE_FLAG_2];
            if (rang.location != NSNotFound || rang1.location!=NSNotFound)
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 150;
                    Y = upY;
                }
                NSLog(@"str(image)---->%@",str);
//                NSString *imageName=[str substringWithRange:NSMakeRange(1, str.length - 2)];
                NSString *faceimg= [faceMap objectForKey:str];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage bundleFacailImageNamed:faceimg]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX=KFacialSizeWidth+upX;
                if (X<150) X = upX;
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = 150;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX=upX+size.width;
                    if (X<150) {
                        X = upX;
                    }
                }
            }
        }
    }

#warning 文字尺寸还需进一步修改……
    //文字的尺寸
    if (_message.type == MessageTypeMe)
        returnView.frame = CGRectMake(10.0f, 0.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    else
        returnView.frame = CGRectMake(20.0f, 0.0f, X, Y);
    NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}



@end
