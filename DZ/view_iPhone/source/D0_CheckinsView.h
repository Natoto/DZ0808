//
//  D0_CheckinsView.h
//  DZ
//
//  Created by Nonato on 14-7-24.
//
//

#import <UIKit/UIKit.h>
 
@class D0_CheckinsView;
@protocol D0_CheckinsViewDelegate <NSObject>
- (void)D0_CheckinsView:(D0_CheckinsView *)view MaskViewDidTaped:(id)object;
- (void)D0_CheckinsView:(D0_CheckinsView *)view signsuccess:(BOOL)success message:(NSString *)message;
@end

@interface D0_CheckinsView : UIView
{

}

@property(nonatomic,assign)NSObject <D0_CheckinsViewDelegate> *delegate;
@property(nonatomic,retain) UIView * contentView;
@property(nonatomic,retain) UIView * contentBGView;
@property(nonatomic,retain) NSArray *biaoqings;
- (void)show;
-(void)hide;
@end
