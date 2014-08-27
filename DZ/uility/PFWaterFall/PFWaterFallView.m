//
//  PFWaterFallView.m
//  DZ
//
//  Created by PFei_He on 14-6-11.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "PFWaterFallView.h"
#import "PFWaterFall.h"

@interface PFWaterFallView ()
{
    UIView *firstList;      //第一列
    UIView *secondList;     //第二列

    int higher;             //最高的列
    int lower;              //最低的列
    int row;                //行数
    float highestValue;     //最高列高度
    int countImage;         //图片总数
}

@end

@implementation PFWaterFallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Init Water Fall Methods

//初始化瀑布流
- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = array;

        //初始化参数
        [self initParameter];
    }
    return self;
}

//初始化列表的参数
- (void)initParameter
{
    //初始化视图
    firstList = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    secondList = [[UIView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, 0)];

    //初始化列
    higher = 1;
    lower = 1;
    row = 1;
    highestValue = 1;
    countImage = 0;

    for (int i = 0; i < self.imageArray.count; i++) {
        if (i / 2 > 0 && i % 2 == 0) {
            row++;
        }
        PFWaterFallImageInfo *imageInfo = (PFWaterFallImageInfo *)[self.imageArray objectAtIndex:i];

        countImage++;

        //添加视图
        [self addView:imageInfo numberOfImage:countImage];

        //重新设置最高列和最低列
        [self higherAndLower];
    }
    [self setContentSize:CGSizeMake(WIDTH, highestValue)];
    [self addSubview:firstList];
    [self addSubview:secondList];
}

#pragma mark - View Management Methods

- (void)addView:(PFWaterFallImageInfo *)imageInfo numberOfImage:(int)numberOfImage
{
    //添加到列表上的图片对象
    PFWaterFallImageView *imageView;

    //图片的高度
    float imageHeight = 0;

    switch (lower) {
        case 1:
            imageView = [[PFWaterFallImageView alloc] initWithImageInfo:imageInfo y:firstList.frame.size.height numberOfImage:numberOfImage];
            imageHeight = imageView.frame.size.height;
            firstList.frame = CGRectMake(firstList.frame.origin.x, firstList.frame.origin.y, WIDTH, firstList.frame.size.height + imageHeight);
            [firstList addSubview:imageView];
            break;
        case 2:
            imageView = [[PFWaterFallImageView alloc] initWithImageInfo:imageInfo y:secondList.frame.size.height numberOfImage:numberOfImage];
            imageHeight = imageView.frame.size.height;
            secondList.frame = CGRectMake(secondList.frame.origin.x, secondList.frame.origin.y, WIDTH, secondList.frame.size.height + imageHeight);
            [secondList addSubview:imageView];
            break;
        default:
            break;
    }
}

//设置最高列和最低列
- (void)higherAndLower
{
    //获取最高列的高度
    float firstHeight = firstList.frame.size.height;

    //获取最低列的高度
    float secondHeight = secondList.frame.size.height;

    //设置最高列
    if (firstHeight > secondHeight) {

        //如果第一列最高，则赋值到最高的数上
        highestValue = firstHeight;

        //设置最高列为1
        higher = 1;
    } else {

        //如果第二列最高，则赋值到最高的数上
        highestValue = secondHeight;

        //设置最高列为2
        higher = 2;
    }

    //设置最低列
    if (firstHeight < secondHeight) {

        //设置最低列为1
        lower = 1;
    }
    else
    {
        //设置最低列为2
        lower = 2;
    }
}

#pragma mark - Event Methods

//系统的点击触发事件方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    PFWaterFallImageInfo *imageInfo = [[PFWaterFallImageInfo alloc] init];
    [self.delegate touchImage:imageInfo];
}

//下拉刷新
- (void)refresh:(NSArray *)array
{
    [firstList removeFromSuperview], firstList = nil;
    [secondList removeFromSuperview], secondList = nil;
    self.imageArray = array;
    [self initParameter];
}

//加载更多
- (void)loadMore:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        if (i / 2 > 0 && i % 2 == 0) {
            row++;
        }
        PFWaterFallImageInfo *imageInfo = (PFWaterFallImageInfo *)[array objectAtIndex:i];
        countImage++;

        //添加视图
        [self addView:imageInfo numberOfImage:countImage];

        //重新设置最高和最低的view
        [self higherAndLower];
    }
    [self setContentSize:CGSizeMake(WIDTH, highestValue)];
}

@end
