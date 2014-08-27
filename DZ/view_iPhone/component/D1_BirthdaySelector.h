//
//  D1_BirthdaySelector.h
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "bee.h"
#import <UIKit/UIKit.h>
@interface BirthYearMonth : NSObject

@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;

@end

@interface D1_BirthdaySelector : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
    //@private
    //    NSArray *provinces;
    //    NSArray	*cities;
}
AS_SIGNAL(DIDSHOW)
AS_SIGNAL(DIDHIDE)
@property (strong, nonatomic) UILabel               * titlelabel;
@property (strong, nonatomic) UIPickerView          * locatePicker;
@property (strong, nonatomic) NSArray               * firstLevelAry;
@property (strong, nonatomic) NSArray               * secondLevelAry;
@property (strong, nonatomic) NSArray               * thirdLevelAry;
@property (strong, nonatomic) BirthYearMonth        * locate;

- (id)initWithTitle:(NSString *)title delegate:(id)delegate;

- (void)showInView:(UIView *)view;
- (IBAction)cancel:(id)sender;
-(void)showInView:(UIView *)view YearMonth:(NSString *)Year_Month;
@end
