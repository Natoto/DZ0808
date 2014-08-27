//
//  C0_ZhuTi_SelectPlates.h
//  DZ
//
//  Created by Nonato on 14-7-25.
//
//

#import <UIKit/UIKit.h>
#import "forumlist.h"
#import "UIImage+Bundle.h"
@interface THTPS_SELECT : NSObject
//@property(nonatomic,strong) threadtypes *athreadtypes;
@property(nonatomic,strong) NSString  * threadtypesitem;
@property(nonatomic,assign) NSNumber  * typedid;
@end

@interface C0_ZhuTi_SelectPlates : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic)  UILabel               * titlelabel;
@property (strong, nonatomic)  UIPickerView          * locatePicker;
//@property (strong, nonatomic)  threadtypes          * athreadtypes;
@property (strong, nonatomic)  NSArray              * array;
@property (strong, nonatomic)  THTPS_SELECT         * locate;
//@property (nonatomic,assign)   BOOL                   show;
//@property (strong,nonatomic)   NSString             * basefid;
- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;
- (IBAction)cancel:(id)sender;
-(void)resignFirstResponder;

@end
