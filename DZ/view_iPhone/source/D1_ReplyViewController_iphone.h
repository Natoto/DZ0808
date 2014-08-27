//
//  D1_ReplyViewController_iphone.h
//  DZ
//
//  Created by Nonato on 14-7-31.
//
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "D1_Reply_MyViewController.h"
#import "D1_Reply_OtherViewController.h"
@interface D1_ReplyViewController_iphone : UIViewController<QCSlideSwitchViewDelegate>
{
    QCSlideSwitchView *_slideSwitchView;
    D1_Reply_MyViewController       *_vc1;
    D1_Reply_OtherViewController    *_vc2;
}
@property (nonatomic, strong) QCSlideSwitchView    *slideSwitchView;
@property (nonatomic, strong) D1_Reply_MyViewController     * vc1;
@property (nonatomic, strong) D1_Reply_OtherViewController  * vc2;
@property (nonatomic, strong) NSString                      * uid;
@end
