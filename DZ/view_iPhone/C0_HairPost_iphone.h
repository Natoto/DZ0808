//
//  C0_HairPost.h
//  DZ
//
//  Created by Nonato on 14-4-1.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#define TOP_VIEW_HEIGHT 33.0f
#define TOP_VIEW_WIDTH 48.0f
#import "Bee_UIBoard.h"
#import "Bee.h"
#import "BaseBoard_iPhone.h"
#import "postImageModel.h"
#import "SETextAttachment.h"
#import "UserModel.h"
  
#import "BeeUIBoard+ViewController.h"
#import "NSString+BeeExtension.h"
#define DRAFTSTRUCT @"draftstruct"
#define DRAFTSTITLE  @"draftstitle"
#define DRAFTSPLATESNAME @"selectforumbtnText"

#define TEXTTYPE 0
#define IMGTYPE  1
#define FACETYPE 0
//#import "C0_FacialInputView.h"
//#import "EmotionAttachmentCell.h"
#define TITLTTAG 7031051
#define CONTENTTAG 7031052
@class SETextView;
@interface DratfStruct : NSObject
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * plates;
@property(nonatomic,strong)NSString * selectfid;
@end
@class C0_HairPost_SelectPlates;

@interface C0_HairPost_iphone : BeeUIBoard_ViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{ 
    BOOL _reloading;
}
AS_SIGNAL(didpostImage)
AS_SINGLETON(C0_HairPost_iphone);
@property(nonatomic,strong)NSString *selectfid;
@property(nonatomic,strong)NSNumber * typedid;
-(NSMutableArray *)spliteContentWithattAry:(NSArray *)attAry atrributestr:(NSAttributedString *)AttributedString UploadedImageAry:(NSMutableArray *)UploadedImageAry;
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
-(void)saveDrafts;
-(BOOL)isFacialMark:(NSString *)mark seTextView:(SETextView *)textview;
@end
