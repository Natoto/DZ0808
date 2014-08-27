//
//  B3_PostBaseTableViewCell.h
//  DZ
//
//  Created by Nonato on 14-6-27.
//
//
#import "ToolsFunc.h"
#import "postlist.h"
#import "SettingModel.h"
#import "bee.h"
#import <UIKit/UIKit.h>
#import "PHOTO+AutoSelection.h"
#import "RCLabel.h"
#import "UIImage+Bundle.h"
#define HEADCONTENTVIEWSTARTTAG 110043
#define  CONTENTVIEWSTARTTAG 153314
#define DEFAULTHEIGHT 50.0
#define DEFAULINTERVAL 5.0
#define DEFAULIMAGERECT(LEFT,OriginY,RIGHT) CGRectMake(LEFT, OriginY, DEFAULTHEIGHT*3 - LEFT - RIGHT, 3*DEFAULTHEIGHT)

#define DEF_CELL_MARGIN_LEFT 20
#define DEF_CELL_MARGIN_RIGHT 10

#define DEF_HEAD_MARGIN_LEFT 10
#define DEF_HEAD_MARGIN_RIGHT 10
#define FRAME_REPLYBTN(Y) CGRectMake(self.width - 35, Y, 35, 35)
#define FRAME_SUPPORTBTN(Y) CGRectMake(self.width - 35 - 20, Y, 100, 30)

typedef enum : NSUInteger {
    CELL_MAINTOPIC = 110,
    CELL_REPLYTOPIC = 111,
} CELL_TYPE;

typedef enum : NSUInteger {
    FORMWEB,
    FORMSELFDEFINE,
} TYPETOSHOWCONTENT;

@class B3_PostBaseTableViewCell;

@protocol B3_PostBaseTableViewCellDelegate <NSObject>

@required
-(TYPETOSHOWCONTENT)typeToshowContent:(B3_PostBaseTableViewCell *)cell;
-(CGRect)frameOfCellHeader:(B3_PostBaseTableViewCell *)cell;
-(BOOL)isTopicArtile:(B3_PostBaseTableViewCell *)cell;
-(post *)cellpost:(B3_PostBaseTableViewCell *)cell;

//-(void)reloadSubView:(B3_PostBaseTableViewCell *)cell;
//-(NSInteger)numberofSection:(B3_PostBaseTableViewCell *)cell;
//-(CGFloat)heightOfB3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell section:(int)section;
-(void)B3_PostBaseTableViewCellDidFinishLoad:(B3_PostBaseTableViewCell *) cell frame:(CGRect)frame;
@optional

-(CELL_TYPE)typeOfcell:(B3_PostBaseTableViewCell *)cell;
-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell  tappedheaderview:(BOOL)selected;
-(NSString *)lblfloorText:(B3_PostBaseTableViewCell *)cell;
//-(post *)cellpost:(B3_PostBaseTableViewCell *)cell;
-(UIView *)viewOfOfBasePostCell:(int)section;
- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ShowBigImgview:(NSString *)imgurl imageView:(BeeUIImageView *)imageview;
- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ReplyButtonTap:(id)sender;
- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ProfileBtnTapped:(id)sender;
- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url;
- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell supportBtnTapped:(id)sender;

@end

@interface B3_PostBaseTableViewCell : UITableViewCell<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,RTLabelDelegate>
{
    NSMutableArray * cntSubViewsAry;
    UIWebView      * webcontentview;
//    BeeUIImageView * splitimg;
    CGRect          headerFrame;
    SEL             loadcontentselector;
    BOOL            headerviewSelected;
    NSDictionary     * faceMap ;
//    NSMutableArray   * newcontentsAry;
     BOOL             sendDelegate;
    CELL_TYPE        cell_type;
}
@property(nonatomic,assign) float  cellheight;
@property(nonatomic,strong) NSArray  *contentsAry;
@property(nonatomic,strong) UIWebView   * webcontentview;
@property(nonatomic,strong) NSString * cellIndex;
@property(nonatomic,assign) NSObject <B3_PostBaseTableViewCellDelegate> *delegate;
@property(nonatomic,retain) UIButton * btnreply;
@property(nonatomic,strong) UILabel * lblTitle;
@property(nonatomic,strong) UILabel * lbllandlord;
@property(nonatomic,strong) UILabel * lblreply;
@property(nonatomic,strong) UILabel * lbltime;
@property(nonatomic,strong) UILabel * lblfloor;
@property(nonatomic,strong) BeeUIImageView *imgprofile;
@property(nonatomic,strong) UIView  * belowcontentView;
//@property(nonatomic,strong) NSArray * contentAry;
@property(nonatomic,strong) UIView  * headerView;
//@property(nonatomic,strong) post   *celltopic;
@property(nonatomic,strong) post    *cellpost;
@property(nonatomic,assign) FONTSIZE_TYPE  fontsize;
@property (nonatomic, strong) UIButton *btnsupport;
@property (nonatomic, strong) UILabel *lblsupport;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *support;
@property (nonatomic, assign) BOOL isHeader;
@property(nonatomic,assign)  CGRect blowcontentRect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)delegate;
- (void)reloadsubviews;
+ (float)heightOfSelfdefinecontents:(NSArray *)contents celltype:(CELL_TYPE)celltype;
- (float)heightofWebview:(NSArray *)contents;
- (void)B3_PostBaseTableViewCell:(void (^)(id sender))obj;

//- (void)toShare;

AS_SINGLETON(SUPPORT)
AS_NOTIFICATION(SUPPORT)

@end
