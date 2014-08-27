//
//  B2_AllViewController.m
//  DZ
//
//  Created by Nonato on 14-4-22.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B2_AllViewController.h"

@interface B2_AllViewController ()

@end

@implementation B2_AllViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

ON_SIGNAL3(ALL_TopiclistModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    BeeLog(@"self.tpclistModel.shots %@",self.tpclistModel.shots);
}

- (void)viewDidCurrentView
{
    if (!self.tpclistModel.loaded) {
        [self.tpclistModel firstPage];
    }
    NSLog(@"加载为当前视图hot = %@",self.title);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tpclistModel =[ALL_TopiclistModel modelWithObserver:self];
    self.tpclistModel.fid=self.forum_fid;
    self.tpclistModel.type=self.topic_type; 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
