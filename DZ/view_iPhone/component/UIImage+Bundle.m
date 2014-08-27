//
//  UImage+Bundle.m
//  DZ
//
//  Created by Nonato on 14-7-29.
//
//

#import "UIImage+Bundle.h"

@implementation UIImage(Bundle)

+ (UIImage *)bundleImageNamed:(NSString *)name
{
    if ([name rangeOfString:@"jpg" options:NSCaseInsensitiveSearch].location == NSNotFound && [name rangeOfString:@"png" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        name =[name stringByAppendingFormat:@".png"];
    }
    /*
     NSString *resource=@"images";
     NSString *bundle=@"bundle";
     */
    NSString *bundlePath = @"images.bundle";
    /*
     [[ NSBundle mainBundle] pathForResource: resource ofType :bundle];
     */
    //images
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:name];
    UIImage *image_1= [UIImage imageNamed:imagePath];
    /* 用imagenamed的方式是把图片放在内存中 更加流畅
     [UIImage imageWithContentsOfFile:imagePath];
     */
    return image_1;
}

+ (UIImage *)bundleFacailImageNamed:(NSString *)name
{
    if ([name rangeOfString:@"jpg" options:NSCaseInsensitiveSearch].location == NSNotFound && [name rangeOfString:@"png" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        name =[name stringByAppendingFormat:@".png"];
    }
//    NSString *resource=@"image";
//    NSString *bundle=@"bundle";
    NSString * bundlePath =@"image.bundle"; //[[ NSBundle mainBundle] pathForResource: resource ofType :bundle];
    //images
    bundlePath = [bundlePath stringByAppendingPathComponent:@"expressions"];
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:name];
    UIImage *image_1=[UIImage imageNamed:imagePath]; //[UIImage imageWithContentsOfFile:imagePath];
    return image_1;
}

@end

