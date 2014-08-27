//
//  C0_HairPost_SelectPlates.h
//  DZ
//
//  Created by Nonato on 14-5-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumlistModel.h"
#import "forumlist.h"

@interface LoacateChild : NSObject
@property(nonatomic,strong) forums  * parent;
@property(nonatomic,strong) forums   * child;
@property(nonatomic,strong) child   * subchild;
@end

@interface C0_HairPost_SelectPlates : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
//@private
//    NSArray *provinces;
//    NSArray	*cities; 
}
@property (strong, nonatomic) ForumlistModel        * fmModel;
@property (strong, nonatomic) UILabel               * titlelabel;
@property (strong, nonatomic) UIPickerView          * locatePicker;
@property (strong, nonatomic) NSArray               * forumAry;
@property (strong, nonatomic) NSArray               * childAry;
@property (strong, nonatomic) NSArray               * subchildAry;
@property (strong, nonatomic) LoacateChild                 * locate;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;
- (IBAction)cancel:(id)sender;
-(void)resignFirstResponder;
@end
