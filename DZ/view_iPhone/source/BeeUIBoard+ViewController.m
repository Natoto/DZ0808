//
//  BeeUIBoard+ViewController.m
//  DZ
//
//  Created by Nonato on 14-6-30.
//
//

#import "BeeUIBoard+ViewController.h"
#import "Bee.h"
@interface BeeUIBoard_ViewController ()

@end

@implementation BeeUIBoard_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
        //	INFO( @"'%@' loadView", [[self class] description] );
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            if ( [BeeUIConfig sharedInstance].iOS6Mode )
            {
                self.edgesForExtendedLayout = UIRectEdgeNone;
                self.extendedLayoutIncludesOpaqueBars = NO;
                self.modalPresentationCapturesStatusBarAppearance = NO;
            }
            else
            {//如果改为 UIRectEdgeAll 则整个界面会上移 //;//
                self.edgesForExtendedLayout = UIRectEdgeNone;
                self.extendedLayoutIncludesOpaqueBars = YES;
                self.modalPresentationCapturesStatusBarAppearance = YES;
            }
        }
#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ( self.nibName )
        {
            [super loadView];
//            self.view.signalReceiver = self;
        }
        else
        {
            self.view = [[UIView alloc] initWithFrame:CGRectZero]; 
            self.view.backgroundColor = [UIColor clearColor];
            self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            CGRect frame = [UIScreen mainScreen].bounds;
            self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor = CLR_BACKGROUND;
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
