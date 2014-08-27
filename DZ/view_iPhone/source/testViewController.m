//
//  testViewController.m
//  DZ
//
//  Created by Nonato on 14-6-30.
//
//

#import "testViewController.h"

@interface testViewController ()
{
    UILabel *label;
}
@end

@implementation testViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

ON_CREATE_VIEWS(signal)
{ 
    label=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 60)];
    label.text =@"text ~~~~~~";
    label.backgroundColor = [UIColor grayColor];
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
}

ON_DID_APPEAR(signal)
{
    label.frame = CGRectMake(0, 10, 300, 60);
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
