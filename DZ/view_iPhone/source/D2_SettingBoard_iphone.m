//
//  D2_SettingBoard_iphone.m
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_SettingBoard_iphone.h"
#import "D0_Minetools_iphone.h"
#import "D2_Setting_FontSize_Cell.h"
#import "D2_Setting_2G3GNotLoadImgCell.h"
#import "D2_Setting_ClearCashCell.h"
#import "D2_Setting_VisionsCell.h"
#import "D2_Setting_AboutUsCell.h"
#import "D2_Setting_AboutUsCellViewController.h"
#import "AppBoard_iPhone.h"

@interface D2_SettingBoard_iphone ()
@property(nonatomic,assign)FONTSIZE_TYPE fontsize_type;

@end

@implementation D2_SettingBoard_iphone
-(void)viewDidLoad
{
        self.noFooterView = YES;
        self.noHeaderFreshView = YES;
        [super viewDidLoad];
        self.view.backgroundColor=[UIColor whiteColor];
        self.navigationBarTitle = @"设置";
        self.navigationBarShown = YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString * identify = @"cell";
        HBBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            if (indexPath.row == 0) {
                cell = [[D2_Setting_FontSize_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            else if(indexPath.row == 1)
            {
                cell = [[D2_Setting_2G3GNotLoadImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            else if(indexPath.row == 2)
            {
                cell = [[D2_Setting_ClearCashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            else if(indexPath.row == 3)
            {
                cell = [[D2_Setting_VisionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            else if(indexPath.row == 4)
            {
                cell = [[D2_Setting_AboutUsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
        }
        [cell dataDidChanged];
        return cell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}

ON_SIGNAL3(D2_Setting_ClearCashCell, WILLCLEARCASH, signal)
{
    [self presentLoadingTips:@"大扫除中..."];
}

ON_SIGNAL3(D2_Setting_ClearCashCell, DIDCLEARCASH, signal)
{
    BeeLog(@"清除缓存成功");
    [self dismissTips];
    [self presentSuccessTips:@"清理完成"];
}

ON_SIGNAL3(D2_Setting_VisionsCell, CHECKING, signal)
{
    [self presentLoadingTips:@"正在检查新版本"];
}

ON_SIGNAL3(D2_Setting_VisionsCell, CHECKEDSUCCESS, signal)
{
    [self dismissTips];
}

ON_SIGNAL3(D2_Setting_VisionsCell, CHECKEDFAILED, signal)
{
    [self dismissTips];
    [self presentSuccessTips:@"亲，目前没有新版本哦"];
}

ON_SIGNAL3(D2_Setting_AboutUsCell, aboutUs, signal)
{
    D2_Setting_AboutUsCellViewController *aboutUs = [[D2_Setting_AboutUsCellViewController alloc] init];
    [self.navigationController pushViewController:aboutUs animated:YES];
}

@end
