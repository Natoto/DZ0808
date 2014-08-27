//
//  D1_CitySelector.h
//  DZ
//
//  Created by Nonato on 14-5-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bee.h"
#import "DistrictsModel.h"
@interface LocationCity : NSObject
@property(nonatomic,strong) NSString    *  provice;
@property(nonatomic,strong) NSString    *  city;
@property(nonatomic,strong) dis_child   *  dis_childcls;
@end

@interface D1_CitySelector : UIActionSheet <UIPickerViewDelegate, UIPickerViewDataSource> {
 
}
AS_SIGNAL(DIDSHOW)
AS_SIGNAL(DIDHIDE)
@property (strong, nonatomic) UILabel               * titlelabel;
@property (strong, nonatomic) UIPickerView          * locatePicker;
@property (strong, nonatomic) NSMutableArray               * firstLevelAry;
@property (strong, nonatomic) NSMutableArray               * secondLevelAry;
@property (strong, nonatomic) LocationCity          * locate;
@property (strong, nonatomic) DistrictsModel        * distrctModel;
- (id)initWithTitle:(NSString *)title delegate:(id)delegate;
- (void)showInView:(UIView *)view;
- (IBAction)cancel:(id)sender; 
-(void)showInView:(UIView *)view Provicename:(NSString *)Provicename cityname:(NSString *)cityname;
@end
