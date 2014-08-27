//
//  DZ_PopupBox.h
//  DZ
//
//  Created by Nonato on 14-8-5.
//
//

#import <UIKit/UIKit.h>

@class DZ_PopupBox;
@protocol DZ_PopupBoxDelegate <NSObject>
- (void)DZ_PopupBox:(DZ_PopupBox *)view MaskViewDidTaped:(id)object;
@end

@interface DZ_PopupBox : UIView
{
    UILabel *titlelabel;
}

@property(nonatomic,assign) NSObject <DZ_PopupBoxDelegate> *ppboxdelegate;
@property(nonatomic,retain) UIView * contentView;
//@property(nonatomic,retain) UIView * contentBGView;
@property(nonatomic,retain) NSString *title;
-(void)show;
-(void)hide;

-(void)loadDatas:(NSMutableDictionary *)diction;
@end
