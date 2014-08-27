//
//  D1_Reply_OtherViewController.h
//  DZ
//
//  Created by Nonato on 14-7-31.
//
//

#import "Base_TableviewController.h"
@class D1_Reply_OtherViewController;
@protocol D1_Reply_OtherViewControllerDelegate <NSObject>
- (void)D1_Reply_OtherViewController:(D1_Reply_OtherViewController *)controller cellSelectedWithTid:(NSString *)tid;
@end

@interface D1_Reply_OtherViewController : Base_TableviewController
@property (nonatomic, assign) NSObject <D1_Reply_OtherViewControllerDelegate> *delegate;
@property (nonatomic, strong) NSString    * uid;
@property (nonatomic, strong) NSString    * username;
@property (nonatomic, strong) NSString    * newtitle;
@property (nonatomic, strong) NSArray     * array;
@end
