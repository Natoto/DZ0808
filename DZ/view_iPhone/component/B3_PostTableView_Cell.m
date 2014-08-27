//
//  B3_PostTableView_Cell.m
//  DZ
//
//  Created by Nonato on 14-4-24.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B3_PostTableView_Cell.h"
#import "Constants.h"
#import "RCLabel.h"
@implementation B3_PostTableView_Cell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        cntSubViewsAry=[[NSMutableArray alloc] initWithCapacity:1];
        //        fontsize =[SettingModel sharedInstance].fontsize;
        //        [self loadheaderviews];
        headerpostcell = [[B3_PostBaseTableViewCell alloc] initWithStyle:style reuseIdentifier:@"postbaseTabel.cell" target:self];
        headerpostcell.delegate = self;
        headerpostcell.frame = CGRectMake(0, 0, 320, 200);

        [self.contentView addSubview:headerpostcell];
    }
    return self;
}

+ (float)heightOfCell:(NSArray *)contents
{
       return  [B3_PostBaseTableViewCell heightOfSelfdefinecontents:contents celltype:CELL_REPLYTOPIC];
}

-(CELL_TYPE)typeOfcell:(B3_PostBaseTableViewCell *)cell
{
    return CELL_REPLYTOPIC;
}

-(void)setCellIndex:(NSString *)cellIndex
{
    _cellIndex = cellIndex;
    headerpostcell.cellIndex = cellIndex;
}

-(BOOL)isTopicArtile:(B3_PostBaseTableViewCell *)cell
{
    return NO;
}

-(float)cellheight
{
    return  headerpostcell.cellheight;
}

-(CGRect)frameOfCellHeader:(B3_PostBaseTableViewCell *)cell
{
//    return CGRectMake(0, 0, 320, 60);
    self.cellHeaderFrame = CGRectMake(0, 0, 320, 60);
    return self.cellHeaderFrame;
}

-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ProfileBtnTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellProfileBtnTapped:)]) {
        [self.delegate B3_CellProfileBtnTapped:self];
    }
}
-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ShowBigImgview:(NSString *)imgurl imageView:(BeeUIImageView *)imageview
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellShowBigImgview:cell:imageview:)])
    {
        [self.delegate B3_CellShowBigImgview:imgurl cell:self imageview:imageview];
    }
}

- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ReplyButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellReplyBtnTapped:)]) {
        [self.delegate B3_CellReplyBtnTapped:self];
    }
}

- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell supportBtnTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellSupportBtnTapped:)]) {
//        [self.delegate performSelector:@selector(B3_CellSupportBtnTapped:) withObject:self];
        [self.delegate B3_CellSupportBtnTapped:self];
    }
}

-(TYPETOSHOWCONTENT)typeToshowContent:(B3_PostBaseTableViewCell *)cell
{
    self.typetoshow = FORMSELFDEFINE;
    return  self.typetoshow;//FORMWEB;
}

-(void)B3_PostBaseTableViewCellDidFinishLoad:(B3_PostBaseTableViewCell *)cell frame:(CGRect)frame
{
    if (![cell.cellIndex isEqualToString:self.cellIndex]) {
        return ;
    }
    CGRect myframe =frame;//frame 继续走下去就被释放了？？？
       if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellDidFinishLoad:andheight:)]) {
           if (myframe.size.height < 80) {
               myframe.size.height = 80;
           }
        self.frame =CGRectMake(0, 0, frame.size.width, frame.size.height);
        BeeLog(@"cell.frame.size.height =%d",myframe.size.height);
//        headerpostcell.frame = frame;
        [self.delegate B3_CellDidFinishLoad:self andheight:myframe.size.height];
    }
}
-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:rtLabel:didSelectLinkWithURL:)]) {
        [self.delegate  B3_Cell:self rtLabel:rtLabel didSelectLinkWithURL:url];
    }
}
-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell tappedheaderview:(BOOL)selected
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellHeaderViewTapped:)]) {
        [self.delegate B3_CellHeaderViewTapped:self];
    }
}


-(post *)cellpost:(B3_PostBaseTableViewCell *)cell
{
    return self.cellpost;
}

-(void)reloadsubviews
{
    [headerpostcell reloadsubviews];
}

-(NSString *)lblfloorText:(B3_PostBaseTableViewCell *)cell
{
    return self.lblfloortext;
}


- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//- (void)setIsHeader:(BOOL)isHeader
//{
//    _isHeader = isHeader;
//    headerpostcell.isHeader = isHeader;
//}

- (void)setSupport:(NSNumber *)support
{
    _support = support;
    headerpostcell.support = support;
}

- (void)setStatus:(NSNumber *)status
{
    _status = status;
    headerpostcell.status = status;
}

- (void)B3_PostTableView_Cell:(void (^)(id sender))obj
{
    [headerpostcell B3_PostBaseTableViewCell:obj];
}

@end
/*
-(float)splitLableView:(NSString *)msg andOrgin:(float)OriginY andTag:(int)tag
{
    int lines=(int)msg.length/5000;//超五千字就切分防止卡顿
    
    for (int i=0; i<lines+1; i++) {
       RCLabel *rtLabel =(RCLabel *)[_belowcontentView viewWithTag:tag+5000*i];
       if (!rtLabel) {
            rtLabel=[[RCLabel alloc] initWithFrame:CGRectMake(10, OriginY, 300, 50)];
            [_belowcontentView addSubview:rtLabel];
            NSString *msg1=@"";
           if (i==lines) {
               msg1=[msg substringFromIndex:i*5000];
           }
           else
           {
               msg1=[msg substringWithRange:NSMakeRange(5000*i, 5000)];
           }
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:msg1];
            rtLabel.componentsAndPlainText = componentsDS;
            CGSize optimumSize = [rtLabel optimumSize];
            rtLabel.frame=CGRectMake(10, OriginY, 300, optimumSize.height);
            rtLabel.tag=tag + 5000*i;
            OriginY = OriginY + optimumSize.height;
           splitLableViewTotalHeight=splitLableViewTotalHeight + optimumSize.height;
            rtLabel.enableTouch=NO;
        }
    }
    return OriginY;
}

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
    [webcontentview stringByEvaluatingJavaScriptFromString:javascript];
    [webcontentview stringByEvaluatingJavaScriptFromString:@"setImage();"];
    
    CGSize fittingSize = [webcontentview sizeThatFits:CGSizeZero];
    CGRect frame = webcontentview.frame;
    frame.size = fittingSize;
    webcontentview.frame = frame;
    _belowcontentView.size=frame.size;
    
    _belowcontentView.frame = CGRectMake(0, 60, frame.size.width, frame.size.height);
    _btnreply.frame =CGRectMake(self.frame.size.width - 45, CGRectGetMaxY(_belowcontentView.frame), 45, 30);
    
    if (_delegate) {
        [_delegate B3_CellDidFinishLoad:self andheight:CGRectGetMaxY(_belowcontentView.frame)+30];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] >= 1) {
        //判断是不是图片点击
        if ([(NSString *)[components objectAtIndex:0] isEqualToString:@"imageclick"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellShowBigImgview:cell:)]) {
                if (components.count>=3) {
                    NSString *imgurl= [NSString stringWithFormat:@"%@:%@",components[1],components[2]];
                    [self.delegate B3_CellShowBigImgview:imgurl cell:self];
                }
            }
            return NO;
        }
        return YES;
    }
    return YES;
}


//用网页加载
-(void)loadcontents:(NSArray *)contents
{
    if (!_belowcontentView) {
        _belowcontentView=[[UIView alloc] init];
        webcontentview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        webcontentview.delegate=self;
        webcontentview.opaque = NO;
        webcontentview.backgroundColor = [UIColor clearColor];
        [(UIScrollView *)[[webcontentview subviews] objectAtIndex:0] setBounces:NO];
        //设置UIWebView是按 WebView自适应大小显示,还是按正文内容的大小来显示,YES:表示WebView自适应大小,NO:表示按正文内容的大小来显示
        [webcontentview setScalesPageToFit:NO];
        [_belowcontentView addSubview:webcontentview];
        
        _btnreply = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnreply setImage:[UIImage imageNamed:@"huitei"] forState:UIControlStateNormal];
        _btnreply.frame =CGRectMake(self.frame.size.width - 50, CGRectGetMaxY(_belowcontentView.frame)-50, 50, 50);
        [self addSubview:_btnreply];
        [_btnreply addTarget:self action:@selector(replyBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        _belowcontentView.frame = CGRectMake(0, 60, 320, 60);
        [self addSubview:_belowcontentView];
    }
    float OriginY=0.0;
    NSMutableString *webcontent=[NSMutableString string];
    NSString * headHtml=@"<html>";
    NSString * tailHtml=@"</body></html>";
    NSString *header=@"\
    <head>\
    <meta charset=\"UTF-8\">\
    <title></title>\
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
    <style>\
    img {\
    max-width: 100%;\
    height: auto;\
    }\
    </style>\
    </head><body>";
    
    webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@%@",headHtml,header];
    for (int index=0; index<contents.count; index++) {
        content *acont=[contents objectAtIndex:index];
//        if (!acont.msg.length) {
//            continue;
//        }
        if (acont.type.intValue==0) {//如果内容是网页文字
           acont.msg=[acont.msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *message =[NSString stringWithFormat:@"<font size=\"%d\">%@</font>",fontsize,acont.msg];
            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@",message];
        }
        else if (acont.type.intValue == 2) {//如果内容是表情
            NSDictionary *faceMap =[NSDictionary dictionaryWithContentsOfFile:
                                    [[NSBundle mainBundle] pathForResource:@"_expression_en"
                                                                    ofType:@"plist"]];
            NSString *faceimg= [faceMap objectForKey:acont.msg];
            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"<img alt=\"\" src=\"%@\" style=\"border: none;\" align=\"middle\" width=\"30\" height=\"30\" />",[NSString stringWithFormat:@"%@.png",faceimg]];
            
        }
        else if (acont.type.intValue==1) {//如果内容是图片
            
            if ( ![BeeReachability isReachableViaWIFI] )//是否加载图片
            {
                if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_23G_NOTLOAD)
                {
                    break;
                }
            }
            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"<p><img alt=\"\" src=\"%@\" style=\"border: none;\" align=\"middle\" width=\"310\" height=\"200\" /></p>",acont.msg];
        }
        else if (acont.type.intValue == 5 ) {//如果无权限的图
            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"<img alt=\"\" src=\"%@\" style=\"border: none;\" align=\"middle\" width=\"200\" height=\"50\" /></p>",[NSString stringWithFormat:@"tishihuamian@2x.png"]];
        }
    }
    webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@",tailHtml];
    NSString *filepath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:filepath];
    [webcontentview loadHTMLString:webcontent baseURL:baseURL];
//    _belowcontentView.size=CGSizeMake(320, OriginY);
//    _belowcontentView.frame=CGRectMake(0, 60, 320, OriginY);
}

//-(NSArray *)formattingContentsAry:(NSArray *)contents
//{
//    NSMutableArray *array=[[NSMutableArray alloc] initWithCapacity:0];
//    for (int index = 0; index < contents.count; index ++  ) {
//        content *acont=[contents objectAtIndex:index];
//        content *newcont =[[content alloc] init];
//        
//        while (acont.type.intValue==0 || acont.type.intValue==2) { ////如果内容是网页文字
//            
//        }
//    }
//    return array;
//}


#pragma mark - 用label加载文字
-(void)loadcontents2:(NSArray *)contents
{
    if (!_belowcontentView) {
        _belowcontentView=[[UIView alloc] init];
        _btnreply = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnreply setImage:[UIImage imageNamed:@"huitei"] forState:UIControlStateNormal];
        _btnreply.frame =CGRectMake(self.frame.size.width - 30, 0, 30, 30);
        [self  addSubview:_btnreply];
        [_btnreply addTarget:self action:@selector(replyBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        _belowcontentView.frame = CGRectMake(0, 60, 320, 60);
        [self addSubview:_belowcontentView];
    }
    float OriginY=0.0;
    NSDictionary *faceMap =[NSDictionary dictionaryWithContentsOfFile:
                            [[NSBundle mainBundle] pathForResource:@"_expression_en"
                                                            ofType:@"plist"]];
    
    for (int index=0; index<contents.count; index++) {
        content *acont=[contents objectAtIndex:index];
        if (acont.type.intValue==0 ||acont.type.intValue==2) {//如果内容是网页文字
            RCLabel *rtLabel =(RCLabel *)[_belowcontentView viewWithTag:CONTENTVIEWSTARTTAG +index];
            int  currentIndex = index;
            if (!rtLabel) {
                rtLabel=[[RCLabel alloc] initWithFrame:CGRectMake(15, OriginY, 290, 50)];
                rtLabel.tag=currentIndex + CONTENTVIEWSTARTTAG;
                [_belowcontentView addSubview:rtLabel]; 
                NSString *rtlabelText=[[NSString alloc] initWithFormat:@""];
                if (acont.type.intValue==0) {
                    NSString *message=[acont.msg stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
                    rtlabelText=[rtlabelText stringByAppendingString:message];
                }
                else
                {
                    NSString *faceimg= [faceMap objectForKey:acont.msg];
                    NSString *htmlcode=[NSString stringWithFormat:@"<img src='%@.png'>",faceimg];
                    rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
                }
                while (index<contents.count-1) {
                    index ++;
                    content *imgcontent=[contents objectAtIndex:index];
                    if (imgcontent.type.intValue==2) {
                        NSString *faceimg= [faceMap objectForKey:imgcontent.msg];
                        NSString *htmlcode=[NSString stringWithFormat:@"<img src='%@.png'>",faceimg];
                        rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
                    }
                    else
                    {
                        index --;
                        break;
                    }
                }
                RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
                rtLabel.componentsAndPlainText = componentsDS;
                CGSize optimumSize = [rtLabel optimumSize];
                rtLabel.frame=CGRectMake(10, OriginY, 300, optimumSize.height);
                OriginY = OriginY + optimumSize.height;
            }
            else
            {
                //遇到后面还是表情的则继续走下去
                while (index<contents.count-1) {
                    index++;
                    content *imgcontent=[contents objectAtIndex:index];
                    if (imgcontent.type.intValue==2) {
                        
                    }
                    else
                    {
                        index--;
                        break;
                    }
                }
                CGRect frame=CGRectMake(10, OriginY, 300, rtLabel.frame.size.height);
                rtLabel.frame=frame;
                OriginY=OriginY + rtLabel.frame.size.height;
            }
        }
        else if (acont.type.intValue==1 || acont.type.intValue==5) {//如果内容是图片
            
            if ( ![BeeReachability isReachableViaWIFI] )//是否加载图片
            {
                if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_23G_NOTLOAD)
                {
                    return;
                }
            }
            BeeUIImageView *imgview=(BeeUIImageView *)[_belowcontentView viewWithTag:CONTENTVIEWSTARTTAG + index];
            float DEFAULTHEIGHT = 50;
            if (imgview && ![acont.msg isEqualToString:imgview.loadedURL]) {//当图片的权限切换时
                [imgview removeFromSuperview];
                imgview=nil;
            }
            if (!imgview)
            {
                imgview=[[BeeUIImageView alloc] initWithFrame:CGRectMake(10, OriginY, DEFAULTHEIGHT*4, DEFAULTHEIGHT)];
                imgview.tag = index + CONTENTVIEWSTARTTAG;
                imgview.backgroundColor=[UIColor grayColor];
                imgview.indicator=[imgview indicator];
                imgview.contentMode= UIViewContentModeScaleAspectFit;// UIViewContentModeScaleAspectFit;
                
                imgview.userInteractionEnabled=YES;
                imgview.enableAllEvents=YES;
                //                imgview.data=acont.msg;
                if (acont.type.integerValue == 5) {
                    imgview.image=[UIImage imageNamed:@"tishihuamian"];
                }
                else  if (acont.type.integerValue == 1)
                {
                    [imgview GET:acont.msg useCache:YES];
                }
                [_belowcontentView addSubview:imgview];
                
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgviewTaped:)];
                [tap setNumberOfTapsRequired:1];
                [imgview addGestureRecognizer:tap];
                
            }
            float width=imgview.image.size.width;
            float height=imgview.image.size.height;
            float imgwith=MIN(imgview.image.size.width, 300);
            if (imgwith) {
                float scale =  height / width ;
                float imgheight = imgwith * scale;  //imgview.image.size.height ;
                imgview.size=CGSizeMake(imgwith, imgheight);
                CGRect frame=CGRectMake(10, OriginY, imgwith, imgheight);
                imgview.frame=frame;
                OriginY = OriginY  + imgheight;
            }
            else
            {
                OriginY = OriginY  + DEFAULTHEIGHT;
            }
        }
    }
    OriginY = OriginY  + 10;
    _belowcontentView.size = CGSizeMake(320, OriginY);
    CGRect frame=_belowcontentView.frame;
    _btnreply.frame =CGRectMake(self.frame.size.width - 40, CGRectGetMaxY(_belowcontentView.frame), 30, 30);
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 30);
    splitimg.frame = CGRectMake(15, CGRectGetMaxY(self.frame)-1, self.frame.size.width -30, 1);
    
    if (self.delegate) {
        [self.delegate B3_CellDidFinishLoad:self andheight:CGRectGetMaxY(frame) +30];
    }
}

ON_SIGNAL3(BeeUIImageView, LOAD_COMPLETED, signal)
{
    [self loadcontents:self.cellpost.content];
    //    [self relayoutSubviews];
}

ON_SIGNAL3(BeeUIImageView, LOAD_CACHE, signal)
{
    //    if (delegate) {
    //        [delegate B3_HeadCellDidFinishLoad:frame];
    //    }
    [self loadcontents:self.cellpost.content];
    //    [self relayoutSubviews];
}


-(void)reloadsubviews
{
    if (self.cellpost) {
        self.lblTitle.text=self.cellpost.title;
        self.lbllandlord.text=self.cellpost.authorname;
        self.imgprofile.data=self.cellpost.usericon;
//        NSString *timestr=@"";
//        KT_DATEFROMSTRING(self.cellpost.postsdate, timestr);
        self.lbltime.text=[ToolsFunc datefromstring:self.cellpost.postsdate]; //timestr;
       [self loadcontents:self.cellpost.content];
    }
}

-(void)loadheaderviews
{
    if (_headerView) {
        for (UIView *view in _headerView.subviews) {
            [view removeFromSuperview];
        }
        [_headerView removeFromSuperview];
        _headerView=nil;
    }
    // Initialization code
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    _headerView.backgroundColor=[UIColor whiteColor];
    float orginY=-40;
    self.lblTitle=[[UILabel alloc] init];
    KT_LABELEWIFRAM(self.lblTitle, CGRectMake(10,orginY + 5, 300, 40), @"标题：周杰伦的自传周杰伦的自传周杰伦的自传周杰伦的自传周杰伦的自传周杰伦的自传周杰伦的自传周杰伦的自传", 16, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentLeft, YES);
    self.lblTitle.numberOfLines=2;
    [_headerView  addSubview:self.lblTitle];
    self.lblTitle.hidden=YES;
    
    UILabel *louzhu=[[UILabel alloc] init];
    KT_LABELEWIFRAM(louzhu, CGRectMake(55, orginY + 50, 30, 20), @"楼主:", 10, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentRight, NO);
    [_headerView addSubview:louzhu];
    self.lblfloor = louzhu;
    
    self.lbllandlord=[[UILabel alloc] init];
    KT_LABELEWIFRAM(self.lbllandlord, CGRectMake(85, orginY + 50, 70, 20), @"BOB", 10, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentLeft, NO);
    [_headerView addSubview:self.lbllandlord];
    
    
    UILabel *huifu=[[UILabel alloc] init];
    KT_LABELEWIFRAM(huifu, CGRectMake(55, orginY + 70, 30, 20), @"回复:", 10, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentRight, NO);
    [_headerView addSubview:huifu];
    
    self.lblreply=[[UILabel alloc] init];
    KT_LABELEWIFRAM(self.lblreply, CGRectMake(85, orginY + 70, 70, 20), @"0", 10, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentLeft, NO);
    [_headerView addSubview:self.lblreply];
    
    BeeUIImageView *imgview1=[[BeeUIImageView alloc] initWithFrame:CGRectMake(0,0, 50, 50)];
    KT_IMGVIEW_CIRCLE(imgview1, 1);
    imgview1.backgroundColor=[UIColor grayColor];
    self.imgprofile=imgview1;
    
    UIButton *profileBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame=CGRectMake(5, orginY +  45, 50, 50);
    [profileBtn addSubview:imgview1];
    [profileBtn addTarget:self action:@selector(profileBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:profileBtn];
    
    self.lbltime=[[UILabel alloc] init];
    KT_LABELEWIFRAM(self.lbltime, CGRectMake(200, orginY + 50, 100, 30), @"2014-4-24 17:00:45", 10, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentRight, NO);
    [_headerView addSubview:self.lbltime];
    [self addSubview:_headerView];
  
 
}

-(void)imgviewTaped:(UITapGestureRecognizer *)gesture
{
    BeeUIImageView *imgview=(BeeUIImageView *) gesture.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellShowBigImgview:cell:)]) {
        if ([imgview.loadedURL rangeOfString:@"null"].location == NSNotFound) {
            NSString *imgurl= [NSString stringWithFormat:@"%@",imgview.loadedURL];
            [self.delegate B3_CellShowBigImgview:imgurl cell:self];
        }
        else
        {
            [self.delegate B3_CellShowBigImgview:nil cell:self];
        }
    }
}

-(IBAction)replyBtnTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellReplyBtnTapped:)]) {
        [self.delegate B3_CellReplyBtnTapped:self];
    }
}
-(IBAction)profileBtnTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellProfileBtnTapped:)]) {
        [self.delegate B3_CellProfileBtnTapped:self];
    }
    
}
- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
*/
