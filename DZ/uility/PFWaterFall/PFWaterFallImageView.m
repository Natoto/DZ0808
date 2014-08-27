//
//  PFWaterFallImageView.m
//  DZ
//
//  Created by PFei_He on 14-6-11.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "PFWaterFallImageView.h"
#import "PFWaterFall.h"
#import "Bee_UIImageView.h"

@implementation PFWaterFallImageView

@synthesize imageInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImageInfo:(PFWaterFallImageInfo *)_imageInfo y:(float)y numberOfImage:(int)numberOfImage
{
    //图片实际的宽度和高度
    float imageWidth = _imageInfo.width;
    float imageHeight = _imageInfo.height;

    //缩略图的宽度和高度
    float width = WIDTH - SPACE;
    float height = width * imageHeight / imageWidth;

    self = [super initWithFrame:CGRectMake(0, y, WIDTH, height + SPACE)];
    if (self) {
        //加载图片
        self.imageInfo = _imageInfo;
        BeeUIImageView *imageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(SPACE / 2, SPACE / 2, width, height)];
        imageView.backgroundColor = [UIColor clearColor];

        //添加请求图片的url
        [imageView setUrl:[NSURL URLWithString:imageInfo.url]];
        [self addSubview:imageView];
    }
    return self;
}

@end

@implementation PFWaterFallImageInfo

//初始化瀑布流的图片
- (id)initWithImage:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.url = [dictionary objectForKey:@"url"];
        self.width = [[dictionary objectForKey:@"width"] floatValue];
        self.height = [[dictionary objectForKey:@"height"] floatValue];
    }
    return self;
}

//初始化瀑布流的图片
- (id)initWithImage:(NSString *)url width:(float)width height:(float)height
{
    self = [super init];
    if (self) {
        self.url = url;
        self.width = width;
        self.height = height;
    }
    return self;
}

/*
 //此方法相当于Java的.toString()方法和C#的.ToString()方法
 - (NSString *)description
 {
 return [NSString stringWithFormat:@"url:%@ width:%f height:%f", self.url, self.width, self.height];
 }
 */

@end
