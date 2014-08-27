//
//  B3_PostTableView_HeadCell.m
//  DZ
//
//  Created by Nonato on 14-4-23.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B3_PostTableView_HeadCell.h"
#import "Constants.h"
#import "postlist.h"
#import "ToolsFunc.h"
#define SURPORTHEIGHT 15.0f
@implementation B3_PostTableView_HeadCell
@synthesize delegate;
@synthesize headerpostcell;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        cntSubViewsAry=[[NSMutableArray alloc] initWithCapacity:1];
//        fontsize =[SettingModel sharedInstance].fontsize;
//        [self loadheaderviews];
        headerpostcell = [[B3_PostBaseTableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier target:self];
        headerpostcell.delegate = self;
        headerpostcell.frame = CGRectMake(0, 0, 320, 200);
        [self addSubview:headerpostcell];
    }
    return self;
}
#pragma mark -  B3_PostBaseTableViewCell delegate
- (BOOL)isTopicArtile:(B3_PostBaseTableViewCell *)cell
{
    return YES;
}


- (NSString *)lblfloorText:(B3_PostBaseTableViewCell *)cell
{
    return self.lblfloortext;
}

- (CELL_TYPE)typeOfcell:(B3_PostBaseTableViewCell *)cell
{
    return CELL_MAINTOPIC;
}

- (CGRect)frameOfCellHeader:(B3_PostBaseTableViewCell *)cell
{
//    return CGRectMake(0, 0, 320, 100);
    self.cellHeaderFrame = CGRectMake(0, 0, 320, 100);
    return self.cellHeaderFrame;
}

- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ProfileBtnTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_HeadCellProfileBtnTapped:)]) {
        [self.delegate B3_HeadCellProfileBtnTapped:self];
    }
}
- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ShowBigImgview:(NSString *)imgurl imageView:(BeeUIImageView *)imageview
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_HeadCellShowBigImgview:imageView:)]) {
        [self.delegate B3_HeadCellShowBigImgview:imgurl imageView:imageview];
    }
}

- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ReplyButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_HeadCellReplyButtonTap:)]) {
        [self.delegate B3_HeadCellReplyButtonTap:self];
    }
}

- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell supportBtnTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_HeadCellSupportButtonTap:)]) {
        [self.delegate B3_HeadCellSupportButtonTap:self];
    }
}

- (TYPETOSHOWCONTENT)typeToshowContent:(B3_PostBaseTableViewCell *)cell
{
    return  FORMSELFDEFINE;
}

- (void)B3_PostBaseTableViewCellDidFinishLoad:(B3_PostBaseTableViewCell *)cell frame:(CGRect)frame
{
    if (frame.size.height < 120) {
        frame.size.height = 120;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_HeadCellDidFinishLoad:)]) {
        frame.size.height = frame.size.height + SURPORTHEIGHT;
        self.frame =CGRectMake(0, 0, frame.size.width, frame.size.height);
        headerpostcell.frame = frame;
        [self.delegate B3_HeadCellDidFinishLoad:frame];
    }
}

+ (float)heightOfCell:(NSArray *)contents
{
    return  SURPORTHEIGHT + [B3_PostBaseTableViewCell heightOfSelfdefinecontents:contents celltype:CELL_MAINTOPIC];
}

- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell tappedheaderview:(BOOL)selected
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_HeadCellHeaderViewTapped:)]) {
        [self.delegate B3_HeadCellHeaderViewTapped:self];
    }
}

- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_HeadCell:rtLabel:didSelectLinkWithURL:)]) {
        [self.delegate B3_HeadCell:self rtLabel:rtLabel didSelectLinkWithURL:url];
    }
}

- (post *)cellpost:(B3_PostBaseTableViewCell *)cell
{
    post *apost = (post *)self.celltopic;
    return apost;
}

- (void)reloadsubviews
{
    [headerpostcell reloadsubviews];
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setIsHeader:(BOOL)isHeader
{
    _isHeader = isHeader;
    headerpostcell.isHeader = isHeader;
}

- (void)setSupport:(NSNumber *)support
{
    _support = support;
    headerpostcell.support = support;
}

- (void)setStatus:(NSNumber *)status
{
    _status = status;
    self.headerpostcell.status = status;
}

- (void)B3_PostTableView_HeadCell:(void(^)(id sender))obj
{
    [self.headerpostcell B3_PostBaseTableViewCell:obj];
}

/*
- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
    
    NSString *javascript=@"\
    function setImage(){\
        var imgs = document.getElementsByTagName(\"img\");\
        for (var i=0;i<imgs.length;i++){\
            var src = imgs[i].src;\
            imgs[i].setAttribute(\"onClick\",\"imageClick(src)\");\
        }\
        document.location = imageurls;\
    }\
    function imageClick(imagesrc){\
        var url=\"imageClick:\"+imagesrc;\
        document.location = url;\
    }";
    [webView stringByEvaluatingJavaScriptFromString:javascript];
    [webView stringByEvaluatingJavaScriptFromString:@"setImage();"];
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
//    frame.size.height=frame.size.height;
    _belowcontentView.size=frame.size;
    if (delegate) {
         splitimg.frame = CGRectMake(15, CGRectGetMaxY(_belowcontentView.frame)-1, self.frame.size.width -30, 1);
         _btnreply.frame =CGRectMake(self.frame.size.width - 45, CGRectGetMaxY(_belowcontentView.frame)-30, 30, 30);
        [delegate B3_HeadCellDidFinishLoad:frame];
    }
    //tableView reloadData
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [webcontentview reload];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
 */

@end
