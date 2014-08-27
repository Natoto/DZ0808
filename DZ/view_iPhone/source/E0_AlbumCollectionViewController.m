//
//  WaterF.m
//  CollectionView
//
//  Created by d2space on 14-2-21.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import "E0_AlbumCollectionViewController.h"
//#import "WaterFLayout.h"
#import "E0_AblumWaterFCell.h"
//#import "WaterFallHeader.h"
//#import "WaterFallFooter.h"

@interface E0_AlbumCollectionViewController ()

@property (nonatomic, strong) E0_AblumWaterFCell* cell;
@end

@implementation E0_AlbumCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        [self.collectionView registerClass:[E0_AblumWaterFCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return self;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    CGFloat aFloat = 0;
    UIImage* image = self.imagesArr[indexPath.item];
    aFloat = self.imagewidth/image.size.width;
    self.cell.imageView.frame = CGRectMake(0, 0, self.imagewidth,  image.size.height*aFloat) ;
    self.cell.textView.frame = CGRectMake(0, image.size.height*aFloat+2, self.imagewidth, self.textViewHeight+10);
    self.cell.imageView.image = image;
    self.cell.textView.text = self.textsArr[indexPath.item];
    [self.cell.textView sizeToFit];
    return self.cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //select Item
//    NSLog(@"row= %i,section = %i",indexPath.item,indexPath.section);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aFloat = 0;
    UIImage* image = self.imagesArr[indexPath.item];
    aFloat = self.imagewidth/image.size.width;
    CGSize size = CGSizeMake(0,0);
    size = CGSizeMake(self.imagewidth, image.size.height*aFloat+self.textViewHeight);
 
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont systemFontOfSize:14.0];//[UIFont fontWithName:@"YOUR FONT's NAME" size:16];
    gettingSizeLabel.text = self.textsArr[indexPath.row]; // @"YOUR LABEL's TEXT";
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(size.width, 9999);
    CGSize expectSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
//    label.text = strTest;
    size.height = size.height + expectSize.height;
    
    return size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
