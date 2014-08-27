//
//  MRZoomScrollView.m
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import "MRZoomScrollView.h"

#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@interface MRZoomScrollView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation MRZoomScrollView

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight);
        
        [self initImageView];
    }
    return self;
}

- (void)initImageView
{
    self.backgroundColor=[UIColor clearColor];
    imageView = [[BeeUIImageView alloc]init];
    // The imageView can be zoomed largest size
    imageView.frame = CGRectMake(0, 0, MRScreenWidth * 3, MRScreenHeight * 3);
    imageView.userInteractionEnabled = YES;
    imageView.enableAllEvents=YES;
    imageView.backgroundColor=[UIColor clearColor];
    imageView.contentMode =  UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    
    // Add gesture,double tap zoom imageView.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGesture];
//    [doubleTapGesture release];
    
    UILongPressGestureRecognizer *longPressTap=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSingleViewTap:)];
    [imageView addGestureRecognizer:longPressTap];
    
    float minimumScale = self.frame.size.width / imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale/2];
    [self setMaximumZoomScale:minimumScale*3];
     [self setZoomScale:minimumScale];
//
}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
//    float newScale = MIN(self.zoomScale * 1.5,self.zoomScale*3);
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
//    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?
    (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    
    imageView.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,
                                 self.contentSize.height * 0.5 + offsetY);
}
//-(void)scrollViewdid

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
//{
////    self.imageView.center=CGPointMake(scrollView.width/2,scrollView.height/2);
//    [scrollView setZoomScale:scale animated:YES ];
//}

#pragma mark - View cycle
- (void)dealloc
{
//    [super dealloc];
}
#pragma mark - 加载图片事件

ON_SIGNAL3(BeeUIImageView, LOAD_START, signal)
{
    [self presentLoadingTips:@""];
}

ON_SIGNAL3(BeeUIImageView, LOAD_FAILED, signal)
{
    [self dismissTips];
}

ON_SIGNAL3(BeeUIImageView, LOAD_COMPLETED, signal)
{
    [self dismissTips];
    
    CGFloat capWidth = self.imageView.image.size.width ;
    CGFloat capHeight = self.imageView.image.size.height;
   
     [self.imageView setNeedsDisplay];
     self.imageView.frame=CGRectMake(0, 0, capWidth, capHeight);
   
     float minimumScale = self.frame.size.width / imageView.frame.size.width;
     [self setMinimumZoomScale:minimumScale/2];
     [self setMaximumZoomScale:minimumScale*3];
     [self setZoomScale:minimumScale];

}
ON_SIGNAL3(BeeUIImageView, LOAD_CACHE, signal)
{
    [self handleUISignal_BeeUIImageView_LOAD_COMPLETED:signal];
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
	NSString *msg = nil ;
	if(error != NULL){
		msg = @"保存图片失败" ;
	}else{
		msg = @"保存图片成功" ;
	}
    [self presentSuccessTips:msg];
}


-(void)longPressSingleViewTap:(UITapGestureRecognizer *)sender
{
    if (!sheet.isShown) {
        [sheet removeFromSuperview];
        sheet=nil;
        sheet = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"保存到相册"]];
        [sheet showInView:self];
    }
}
#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    NSLog(@"%d",(int)buttonIndex);
    if (buttonIndex==0) {
        [self saveImageToPhotos:imageView.image];
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
	UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)didClickOnDestructiveButton
{
    NSLog(@"destructuctive");
}

- (void)didClickOnCancelButton
{
    NSLog(@"cancelButton");
}
@end
