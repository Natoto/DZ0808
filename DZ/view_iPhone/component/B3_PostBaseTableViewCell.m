//
//  B3_PostBaseTableViewCell.m
//  DZ
//
//  Created by Nonato on 14-6-27.
//
//
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#define QDSTARTMARK @"<font color='dimgray'>我今天最想说:「"
#import "B3_PostBaseTableViewCell.h"
#import "RCLabel.h"
#import "FaceBoard.h"
#import "B3_PostViewController.h"

static float cellHeight = 0;

@interface RepeatTXTClass : NSObject
@property(nonatomic,retain)NSString  * string;
@property(nonatomic,assign)NSUInteger index;
@end
@implementation RepeatTXTClass
@end

@implementation B3_PostBaseTableViewCell

DEF_NOTIFICATION(SUPPORT)
DEF_SINGLETON(SUPPORT)


@synthesize webcontentview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cntSubViewsAry=[[NSMutableArray alloc] initWithCapacity:1];
        self.fontsize =[SettingModel sharedInstance].fontsize;
        self.delegate = delegate;
        [self loadheaderviews];
        self.backgroundColor = [UIColor whiteColor];
        
        faceMap =  [FaceBoard facailDictionary]; 
    }
    return self;
}
#pragma mark - 网页加载完成
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
    
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'";
//    [webView stringByEvaluatingJavaScriptFromString:str];
    
    [self didreloadWebview:webView];
    //tableView reloadData
}
-(float)heightofWebview:(NSArray *)contents
{
    CGRect frame = self.webcontentview.frame;
    CGSize fittingSize = [self.webcontentview sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    return frame.size.height;
}

-(void)didreloadWebview:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeMake(320, 30)];
//    float webViewHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] floatValue];
//    fittingSize.height = webViewHeight;
    frame.size = fittingSize;
    webView.frame = frame;
    _belowcontentView.size=frame.size;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCellDidFinishLoad:frame:)]) {
        _btnreply.frame = FRAME_REPLYBTN(CGRectGetMaxY(_belowcontentView.frame)); //CGRectMake(self.frame.size.width - 45, CGRectGetMaxY(_belowcontentView.frame) , 30, 30);
        self.blowcontentRect = CGRectMake(0, 0,320,CGRectGetMaxY(_belowcontentView.frame)+30);
   
        self.frame =self.blowcontentRect;
        [self.delegate B3_PostBaseTableViewCellDidFinishLoad:self frame:self.blowcontentRect];
    }
} 

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self didreloadWebview:webcontentview];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self didreloadWebview:webcontentview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] >= 1) {
        //判断是不是图片点击
        if ([(NSString *)[components objectAtIndex:0] isEqualToString:@"imageclick"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:ShowBigImgview:imageView:)]) {
                if (components.count>=3) {
                    NSString *imgurl= [NSString stringWithFormat:@"%@:%@",components[1],components[2]];
                    BeeUIImageView *imageview=[[BeeUIImageView alloc] init];
                    imageview.data=imgurl;
                    [self.delegate B3_PostBaseTableViewCell:self ShowBigImgview:imgurl imageView:imageview];
                }
            }
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark - 用网页加载
-(void)loadwebcontents:(NSArray *)contents senddelegate:(BOOL)send
{
    if (!_belowcontentView) {
        _belowcontentView=[[UIView alloc] init];
        _belowcontentView.backgroundColor = [UIColor clearColor];
        webcontentview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        webcontentview.delegate=self;
        webcontentview.opaque = NO;
        webcontentview.scrollView.delegate=self;
        webcontentview.backgroundColor = [UIColor clearColor];
        [(UIScrollView *)[[webcontentview subviews] objectAtIndex:0] setBounces:NO];
        //设置UIWebView是按 WebView自适应大小显示,还是按正文内容的大小来显示,YES:表示WebView自适应大小,NO:表示按正文内容的大小来显示
        [webcontentview setScalesPageToFit:NO];
        [_belowcontentView addSubview:webcontentview];
        _belowcontentView.frame = CGRectMake(0, CGRectGetMaxY(headerFrame), 320, 60);
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
            NSString *message =[NSString stringWithFormat:@"<font size=\"%d\">%@</font>",self.fontsize,acont.msg];
            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@",message];
        }
        else if (acont.type.intValue == 3)
        {
             acont.msg=[acont.msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             NSString *message =[NSString stringWithFormat:@"<font size=\"%d\">%@</font>",self.fontsize,acont.msg];
             webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@",message];
        }
        else if (acont.type.intValue == 2) {//如果内容是表情
            
            NSString *faceimg= [faceMap objectForKey:acont.msg];
            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"<img alt=\"\" src=\"%@\" style=\"border: none;\" align=\"middle\" width=\"30\" height=\"30\" />",[NSString stringWithFormat:@"image.bundle/expressions/%@.png",faceimg]];
            
        }
        else if (acont.type.intValue==1) {//如果内容是图片
            if ( ![BeeReachability isReachableViaWIFI] )//是否加载图片
            {
                if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_23G_NOTLOAD)
                {
                    break;
                }
            }
            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"<p><img alt=\"\" src=\"%@\" style=\"border: none;\" align=\"middle\" width=\"200\" height=\"50\" /></p>",acont.msg];
        }
        else if (acont.type.intValue == 5 ) {//如果无权限的图
            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"<img alt=\"\" src=\"%@\" style=\"border: none;\" align=\"middle\" width=\"200\" height=\"50\" /></p>",[NSString stringWithFormat:@"tishihuamian@2x.png"]];
        }
    }
    webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@",tailHtml];
    NSString *filepath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:filepath];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [webcontentview loadHTMLString:webcontent baseURL:baseURL];
        _belowcontentView.size=CGSizeMake(320, OriginY);
        _belowcontentView.frame=CGRectMake(0, CGRectGetMaxY(headerFrame), 320, OriginY);
        sendDelegate = send;
    });
}

/*
 0  文本
 1：本地图片
 2：表情
 4：投票
 5: 没登录看不见图片
 3:
 */
-(BOOL)nextis:(CONTENTTYPE)contenttype contents:(NSArray *)contents currentindex:(int)index
{
    if ((index +1) >= contents.count) {
        return NO;
    }
    content *acont=[self.contentsAry objectAtIndex:index + 1];
    if (acont.type.integerValue == contenttype ) {
        return YES;
    }
    return NO;
}
/*
 整合contentary 数组
 将txt和表情
 */
-(NSString *)loadVoteElement:(content *)acont index:(int)index OriginY:(float )OriginY subContentAry:(NSMutableArray *)subContentAry contents:(NSArray *)contents
{
    
    float VOTE_MARGIN_LEFT = 10;
    float VOTE_MARGIN_RIGHT = 10;
    if (self.delegate && [self.delegate respondsToSelector:@selector(typeOfcell:)]) {
        CELL_TYPE type = [self.delegate typeOfcell:self];
        if (type == CELL_MAINTOPIC) {
            VOTE_MARGIN_LEFT = DEF_HEAD_MARGIN_LEFT;
        }
        else if(type == CELL_REPLYTOPIC)
        {
            VOTE_MARGIN_LEFT = DEF_CELL_MARGIN_LEFT;
        }
    }

    
    float tempOriginY = OriginY;
    RCLabel *rtLabel =(RCLabel *)[_belowcontentView viewWithTag:HEADCONTENTVIEWSTARTTAG+index];
    rtLabel.backgroundColor = VOTECOLOR;
    int  currentIndex = index;
    int tempfontsize = self.fontsize;
    tempfontsize = tempfontsize * 2 + FONT_MIDDLEBASE;
    
    if (rtLabel && ![[rtLabel class] isSubclassOfClass:[RCLabel class]]) {
        //切换时候
        [rtLabel removeFromSuperview];
        rtLabel=nil;
    }
    if (!rtLabel) {
        rtLabel=[[RCLabel alloc] initWithFrame:CGRectMake(VOTE_MARGIN_LEFT, OriginY, 320 - VOTE_MARGIN_LEFT -VOTE_MARGIN_RIGHT, 50)];
        [rtLabel setFont:[UIFont systemFontOfSize:tempfontsize]];
        rtLabel.tag=currentIndex + HEADCONTENTVIEWSTARTTAG;
        [_belowcontentView addSubview:rtLabel];
    }
    
    [subContentAry addObject:rtLabel];
    NSString *rtlabelText=[[NSString alloc] initWithFormat:@""];
    if (acont.type.intValue == CONTENTTYPE_QUOTEREPLY)
    {
        rtLabel.backgroundColor = VOTECOLOR;
        rtlabelText=[rtlabelText stringByAppendingString:acont.msg];
        if (acont.signmod.length) {
            NSString *htmlcode=[NSString stringWithFormat:@"<img src='images.bundle/%@.gif'></img>",acont.signmod];
            rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
        }        
    }
    rtlabelText=[B3_PostBaseTableViewCell newText:rtlabelText];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
    rtLabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [rtLabel optimumSize];
    rtLabel.frame=CGRectMake(VOTE_MARGIN_LEFT, OriginY, 320 - VOTE_MARGIN_LEFT -VOTE_MARGIN_RIGHT, optimumSize.height);
    OriginY = OriginY + optimumSize.height;
    tempOriginY = OriginY;
    return [NSString stringWithFormat:@"%f:%d",tempOriginY,index];
}
//签到标签中去掉空格
+(NSString *)removeVotebrMark:(NSString *)acontmsg
{
    NSRegularExpression *regular1;
    //<font size='3'><font color='dimgray'>我今天最想说:「<font color='red'>.*</font><br />」.</font><br /></font>
    
    regular1 = [[NSRegularExpression alloc] initWithPattern:@"</font><br />」.</font><br /></font>"
                                                    options:NSRegularExpressionCaseInsensitive
                                                      error:nil];

    acontmsg = [regular1 stringByReplacingMatchesInString:acontmsg
                                                  options:NSMatchingReportCompletion
                                                    range:NSMakeRange(0, [acontmsg length])
                                             withTemplate:@"</font>」.</font></font>"];
    return acontmsg;
    
}
+ (NSString *)newText:(NSString *)acontmsg
{
//    NSString *message=[acontmsg stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
//    message=[message stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
   
    NSRegularExpression *regular;
    NSRegularExpression *regular1;
    NSRegularExpression *regular2;
   
    acontmsg = [B3_PostBaseTableViewCell removeVotebrMark:acontmsg];
    regular1 = [[NSRegularExpression alloc] initWithPattern:@"<(?!a|font|br|strong|img|/a|/font|/strong|/img).*?>"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
    
    acontmsg = [regular1 stringByReplacingMatchesInString:acontmsg
                                                options:NSMatchingReportCompletion
                                                  range:NSMakeRange(0, [acontmsg length])
                                           withTemplate:@""];
    /* <(?!a|br|strong|/a|/strong).*?> 只保留一下标签&quot;*/
    regular2 = [[NSRegularExpression alloc] initWithPattern:@"<br />(\\s*|\\w{1})<br />"
                                                    options:NSRegularExpressionCaseInsensitive
                                                      error:nil];
    
    acontmsg = [regular2 stringByReplacingMatchesInString:acontmsg
                                                  options:NSMatchingReportCompletion
                                                    range:NSMakeRange(0, [acontmsg length])
                                             withTemplate:@"<br /><br />"];
    
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"&lt;" withString:@""];
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"&gt;" withString:@""];
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
//    acontmsg = [acontmsg trim];    
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
    NSString *message = acontmsg;
    //将多个换行变为1个换行
    regular = [[NSRegularExpression alloc] initWithPattern:@"\n{2,}"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
    
    message = [regular stringByReplacingMatchesInString:message
                                            options:NSMatchingReportCompletion
                                              range:NSMakeRange(0, [message length])
                                       withTemplate:@"\n\n"];
    
    return message;
}

- (NSString *)loadTextOrFacial:(content *)acont index:(int)index OriginY:(float )OriginY subContentAry:(NSMutableArray *)subContentAry contents:(NSArray *)contents
{
    float TXT_MARGIN_LEFT = 10;
    float TXT_MARGIN_RIGHT = 10;
    if (self.delegate && [self.delegate respondsToSelector:@selector(typeOfcell:)]) {
        CELL_TYPE type = [self.delegate typeOfcell:self];
        if (type == CELL_MAINTOPIC) {
            TXT_MARGIN_LEFT = DEF_HEAD_MARGIN_LEFT;
        }
        else if(type == CELL_REPLYTOPIC)
        {
            TXT_MARGIN_LEFT = DEF_CELL_MARGIN_LEFT;
        }
    }

    float tempOriginY = OriginY;
    RCLabel *rtLabel =(RCLabel *)[_belowcontentView viewWithTag:HEADCONTENTVIEWSTARTTAG+index];
    if (rtLabel && ![[rtLabel class] isSubclassOfClass:[RCLabel class]]) {
        //切换时候
        [subContentAry removeObject:rtLabel];
        [rtLabel removeFromSuperview];
        rtLabel=nil;
    }
    int  currentIndex = index;
    int tempfontsize = self.fontsize;
    tempfontsize = tempfontsize * 2 + FONT_MIDDLEBASE;
    if (!rtLabel) {
        rtLabel=[[RCLabel alloc] initWithFrame:CGRectMake(TXT_MARGIN_LEFT, OriginY, 320- TXT_MARGIN_LEFT - TXT_MARGIN_RIGHT, 50)];
        [rtLabel setFont:[UIFont systemFontOfSize:tempfontsize]];
        rtLabel.tag=currentIndex + HEADCONTENTVIEWSTARTTAG;
        rtLabel.backgroundColor = [UIColor clearColor];
        rtLabel.delegate = self;
        [_belowcontentView addSubview:rtLabel];
    }
    rtLabel.backgroundColor = [UIColor clearColor];
    NSString *rtlabelText=[[NSString alloc] initWithFormat:@""];
    if (acont.type.intValue == CONTENTTYPE_TEXT) {
        rtlabelText=[rtlabelText stringByAppendingString:acont.msg];
        [subContentAry addObject:rtLabel];
    }
    else if (acont.type.intValue == CONTENTTYPE_FACIAL)
    {
        NSString *faceimg= [faceMap objectForKey:acont.msg];
        NSString *htmlcode=[NSString stringWithFormat:@"<img src='image.bundle/expressions/%@.png'></img>",faceimg];
        rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
    }
    while (index<contents.count-1) {
        content *imgcontent=[contents objectAtIndex:++index];
        if (imgcontent.type.intValue == CONTENTTYPE_FACIAL) {
            NSString *faceimg= [faceMap objectForKey:imgcontent.msg];
            NSString *htmlcode=[NSString stringWithFormat:@"<img src='image.bundle/expressions/%@.png'></img>",faceimg];
            rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
        }
        else if (imgcontent.type.intValue == CONTENTTYPE_TEXT) {
            NSString *htmlcode=[NSString stringWithFormat:@"%@",imgcontent.msg];
            rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
            RepeatTXTClass *rptcls = [B3_PostBaseTableViewCell RepeatTXT:index contents:contents rtlabelText:rtlabelText];
            rtlabelText = rptcls.string;
            index = rptcls.index;
        }
        else
        {
            index--;
            break;
        }
    }
    
    rtlabelText=[B3_PostBaseTableViewCell newText:rtlabelText];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
    rtLabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [rtLabel optimumSize];
    rtLabel.frame=CGRectMake(TXT_MARGIN_LEFT, OriginY, 320-TXT_MARGIN_LEFT -TXT_MARGIN_RIGHT, optimumSize.height);
    OriginY = OriginY + optimumSize.height;
    [subContentAry addObject:rtLabel];

    tempOriginY = OriginY;
    return [NSString stringWithFormat:@"%f:%d",tempOriginY,index];
}

- (float)loadImages:(content *)acont index:(int)index OriginY:(float )OriginY subContentAry:(NSMutableArray *)subContentAry contents:(NSArray *)contents
{

    float IMG_MARGIN_LEFT = 10;
    float IMG_MARGIN_RIGHT = 10;
    if (self.delegate && [self.delegate respondsToSelector:@selector(typeOfcell:)]) {
        CELL_TYPE type = [self.delegate typeOfcell:self];
        if (type == CELL_MAINTOPIC) {
            IMG_MARGIN_LEFT = DEF_HEAD_MARGIN_LEFT;
        }
        else if(type == CELL_REPLYTOPIC)
        {
            IMG_MARGIN_LEFT = DEF_CELL_MARGIN_LEFT;
        }
    }
    float tempOriginY = OriginY;
    BeeUIImageView *imgview = (BeeUIImageView *)[_belowcontentView viewWithTag:HEADCONTENTVIEWSTARTTAG + index];
    if ((imgview && ![[imgview class] isSubclassOfClass:[BeeUIImageView class]]) || (imgview && ![acont.msg isEqualToString:imgview.loadedURL])) {//当图片的权限切换时
        [imgview removeFromSuperview];
        [subContentAry removeObject:imgview];
        imgview=nil;
    }
    if (!imgview)
    {
        imgview = [[BeeUIImageView alloc] initWithFrame:DEFAULIMAGERECT(IMG_MARGIN_LEFT,OriginY,IMG_MARGIN_RIGHT)];
        imgview.defaultImage = [UIImage bundleImageNamed:@"morenwututubiao"];
        imgview.tag = index + HEADCONTENTVIEWSTARTTAG;
        imgview.backgroundColor = [UIColor clearColor];//调试的时候讲此赋值
        imgview.indicator = [imgview indicator];
        imgview.contentMode = UIViewContentModeScaleAspectFit;// UIViewContentModeScaleAspectFit;
        imgview.backupurl = acont.msg;
        imgview.userInteractionEnabled = YES;
        imgview.enableAllEvents = YES;

        [_belowcontentView addSubview:imgview];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgviewTaped:)];

        [tap setNumberOfTapsRequired:1];
        [imgview addGestureRecognizer:tap];
        [subContentAry addObject:imgview];

        if (acont.type.integerValue == CONTENTTYPE_NOLOGNOSEE) {
            imgview.image = [UIImage bundleImageNamed:@"tishihuamian"];
        }
        else  if (acont.type.integerValue == CONTENTTYPE_IMG)
        {
            [imgview setData:acont.msg baseNetwork:YES];
        }
    }
    else
    {
        [subContentAry addObject:imgview];
    }

    float width = imgview.image.size.width;
    float height = imgview.image.size.height;
    float imgwith = MIN(imgview.image.size.width, 320 - IMG_MARGIN_LEFT - IMG_MARGIN_RIGHT);
    if (imgwith) {
        imgwith = 320 - IMG_MARGIN_LEFT - IMG_MARGIN_RIGHT;  //
        float scale =  height / width ;
        float imgheight = imgwith * scale;  //imgview.image.size.height ;
        imgview.size = CGSizeMake(imgwith, imgheight);
        CGRect frame = CGRectMake(IMG_MARGIN_LEFT, OriginY, imgwith, imgheight);
        imgview.frame = frame;
        OriginY = OriginY  + imgheight + DEFAULINTERVAL;
    }
    else
    {
        OriginY = OriginY  + DEFAULTHEIGHT + DEFAULINTERVAL;
    }
    tempOriginY = OriginY;
    return tempOriginY;
}

#pragma mark - 用label加载文字

-(void)loadselfdefinecontents:(NSArray *)contents senddelegate:(BOOL)send
{
    self.contentsAry = contents;
    if (!_belowcontentView) {
        _belowcontentView=[[UIView alloc] init];
        CGRect frame =CGRectZero;
        if (!self.delegate || ![self.delegate respondsToSelector:@selector(frameOfCellHeader:)]) {
            return;
        }
        frame =[self.delegate frameOfCellHeader:self];
        _belowcontentView.frame = CGRectMake(0, CGRectGetMaxY(frame), 320, 60);
        _belowcontentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_belowcontentView];
        _btnreply.frame = FRAME_REPLYBTN(CGRectGetMaxY(_belowcontentView.frame));
        _btnsupport.frame = CGRectMake(_btnreply.frame.origin.x - 60, _btnreply.frame.origin.y - 8, _btnreply.frame.size.width, _btnreply.frame.size.height);
        _lblsupport.frame = CGRectMake(_btnsupport.frame.origin.x + 30, _btnreply.frame.origin.y - 3, _btnreply.frame.size.width, _btnreply.frame.size.height);
        //CGRectMake(self.frame.size.width - 30, 0, 30, 30);
    }
    NSMutableArray *subContentAry=[[NSMutableArray alloc] initWithCapacity:0];
    float OriginY=0.0;
    for (int index=0; index<contents.count; index++)
    {
        content *acont=[contents objectAtIndex:index];
        if (acont.type.intValue == CONTENTTYPE_TEXT ||acont.type.intValue == CONTENTTYPE_FACIAL) {//如果内容是网页文字
            NSString *resstring = [self loadTextOrFacial:acont index:index OriginY:OriginY subContentAry:subContentAry contents:contents];
            NSArray *compants = [resstring componentsSeparatedByString:@":"];
            if (compants.count == 2) {
                NSString *compon1 = [compants objectAtIndex:0];
                NSString *compon2 = [compants objectAtIndex:1];
                OriginY = compon1.floatValue;
                index = compon2.intValue;
            }
        }
        else if (acont.type.intValue == CONTENTTYPE_IMG || acont.type.intValue== CONTENTTYPE_NOLOGNOSEE) {//如果内容是图片
            OriginY = [self loadImages:acont index:index OriginY:OriginY subContentAry:subContentAry contents:contents];
        }
        else  if (acont.type.intValue == CONTENTTYPE_QUOTEREPLY)
        {
            NSString *resstring = [self loadVoteElement:acont index:index OriginY:OriginY subContentAry:subContentAry contents:contents];
            NSArray *compants = [resstring componentsSeparatedByString:@":"];
            if (compants.count == 2) {
                NSString *compon1 = [compants objectAtIndex:0];
                NSString *compon2 = [compants objectAtIndex:1];
                OriginY = compon1.floatValue;
                index = compon2.intValue;
            }
        }
    }
    //如果有更新的情况下去掉缓存里面的
    for(UIView *view in _belowcontentView.subviews)
    {
        int index = 0;
        for (index = 0 ;index < subContentAry.count; index ++) {
            UIView *view2  = [subContentAry objectAtIndex:index];
            if (view.tag >= HEADCONTENTVIEWSTARTTAG && view.tag  == view2.tag) {
                break;
            }
        }
        if (view.tag >= HEADCONTENTVIEWSTARTTAG && index >= subContentAry.count) {
            [view removeFromSuperview];
        }
    }
    
    OriginY = OriginY  + 10;
    _belowcontentView.size = CGSizeMake(320, OriginY);
    _belowcontentView.frame = CGRectMake(0, CGRectGetMaxY(headerFrame), 320, OriginY);
    
    CGRect frame=_belowcontentView.frame;
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 50);
    _btnreply.frame =  FRAME_REPLYBTN(CGRectGetMaxY(_belowcontentView.frame)); //CGRectMake(self.frame.size.width - 45, CGRectGetMaxY(_belowcontentView.frame), 30, 30);
    _btnsupport.frame = CGRectMake(_btnreply.frame.origin.x - 60, _btnreply.frame.origin.y - 8, _btnreply.frame.size.width, _btnreply.frame.size.height);
    _lblsupport.frame = CGRectMake(_btnsupport.frame.origin.x + 30, _btnreply.frame.origin.y - 3, _btnreply.frame.size.width, _btnreply.frame.size.height);
    
    CGRect rect = CGRectMake(0, 0, 320, CGRectGetMaxY(_belowcontentView.frame) + 30);
    self.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    if (self.delegate && [self.delegate isTopicArtile:self]) {
        BOOL topicarticle = [self.delegate isTopicArtile:self];
        if (topicarticle) {
            rect = CGRectMake(0, 0, 320, CGRectGetMaxY(_belowcontentView.frame) + 50);
            self.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        }
    }
    _cellheight = rect.size.height;
    if (send) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCellDidFinishLoad:frame:)])
            {
              [self.delegate B3_PostBaseTableViewCellDidFinishLoad:self frame:rect];
            }
        }
}

-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:rtLabel:didSelectLinkWithURL:)]) {
        [self.delegate B3_PostBaseTableViewCell:self rtLabel:rtLabel didSelectLinkWithURL:url];
    }
}

+(RepeatTXTClass *)RepeatTXT:(int)index contents:(NSArray *)contents rtlabelText:(NSString *)rtlabelText
{
    while (index<contents.count-1) {
        content *txt=[contents objectAtIndex:++index];
        if (txt.type.intValue == CONTENTTYPE_TEXT) {
            if ([txt.msg isallHtmlMark]) {
                NSString *htmlcode=[NSString stringWithFormat:@"%@",txt.msg];
                rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
            }
            else
            {
                if (txt.msg.trim.length) {
                    NSString *htmlcode=[NSString stringWithFormat:@"%@<br />",txt.msg];
                    rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
                }
            }
        }
        else
        {
            index--;
            break;
        }
    }
    RepeatTXTClass *rptcls =[[RepeatTXTClass alloc] init];
    rptcls.string = rtlabelText;
    rptcls.index = index;
    return rptcls;
}
//cell的高度
+ (float)heightOfSelfdefinecontents:(NSArray *)contents celltype:(CELL_TYPE)celltype
{
    
    float OriginY=0.0;
    NSDictionary *faceMap = [FaceBoard facailDictionary];
    int  tempfontsize =[SettingModel sharedInstance].fontsize;
    tempfontsize = tempfontsize * 2 + FONT_MIDDLEBASE;
    
    float MARGIN_LEFT = 10;
    float MARGIN_RIGHT = 10;
    if (celltype == CELL_MAINTOPIC) {
        MARGIN_LEFT = 10;
    }
    else
    {
        MARGIN_LEFT = 20;
    }
    
    for (int index=0; index<contents.count; index++)
    {
        content *acont=[contents objectAtIndex:index];
        if (acont.type.intValue == CONTENTTYPE_TEXT || acont.type.intValue == CONTENTTYPE_FACIAL) {//如果内容是网页文字
            
            RCLabel *rtLabel = [[RCLabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, OriginY, 320 - MARGIN_RIGHT - MARGIN_LEFT, 30)];
            [rtLabel setFont:[UIFont systemFontOfSize:tempfontsize]];
            NSString *rtlabelText=[[NSString alloc] initWithFormat:@""];
            if (acont.type.intValue == CONTENTTYPE_TEXT) {
                rtlabelText=[rtlabelText stringByAppendingString:acont.msg];
            }
            else  if (acont.type.intValue == CONTENTTYPE_FACIAL)
            {
                NSString *faceimg= [faceMap objectForKey:acont.msg];
                NSString *htmlcode=[NSString stringWithFormat:@"<img src='image.bundle/expressions/%@.png'></img>",faceimg];
                rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
            }
            while (index<contents.count-1) {
                content *imgcontent=[contents objectAtIndex:++index];
                if (imgcontent.type.intValue == CONTENTTYPE_FACIAL) {
                   
                    NSString *faceimg= [faceMap objectForKey:imgcontent.msg];
                    NSString *htmlcode=[NSString stringWithFormat:@"<img src='image.bundle/expressions/%@.png'></img>",faceimg];
                    rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
                }
                else if (imgcontent.type.intValue == CONTENTTYPE_TEXT) {
                    NSString *htmlcode=[NSString stringWithFormat:@"%@",imgcontent.msg];
                    rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
                    RepeatTXTClass *rptcls = [B3_PostBaseTableViewCell RepeatTXT:index contents:contents rtlabelText:rtlabelText];
                    rtlabelText = rptcls.string;
                    index = rptcls.index;
                }
                else
                {
                    index--;
                    break;
                }
            }
            rtlabelText = [B3_PostBaseTableViewCell newText:rtlabelText];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
            rtLabel.componentsAndPlainText = componentsDS;
            CGSize optimumSize = [rtLabel optimumSize];
            rtLabel.frame=CGRectMake(MARGIN_LEFT, OriginY, 320 - MARGIN_LEFT - MARGIN_RIGHT, optimumSize.height);
            OriginY = OriginY + optimumSize.height;
        }
        else if (acont.type.intValue == CONTENTTYPE_QUOTEREPLY)//计算引用文本大小
        {
            RCLabel *rtLabel = [[RCLabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, OriginY, 320 - MARGIN_LEFT - MARGIN_RIGHT , 30)];
            [rtLabel setFont:[UIFont systemFontOfSize:tempfontsize]];
            NSString *rtlabelText=[[NSString alloc] initWithFormat:@""];
            NSString *message=[acont.msg stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            message=[message stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
            rtlabelText=[rtlabelText stringByAppendingString:message];
             if (acont.signmod.length) {
                NSString *htmlcode=[NSString stringWithFormat:@"<img src='images.bundle/%@.gif'></img>",acont.signmod];
                rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
             }
            rtlabelText=[B3_PostBaseTableViewCell newText:rtlabelText];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
            rtLabel.componentsAndPlainText = componentsDS;
            CGSize optimumSize = [rtLabel optimumSize];
            rtLabel.frame=CGRectMake(MARGIN_LEFT, OriginY, 320 - MARGIN_LEFT - MARGIN_RIGHT, optimumSize.height);
            OriginY = OriginY + optimumSize.height;
          
        }
        else if (acont.type.intValue == CONTENTTYPE_IMG || acont.type.intValue== CONTENTTYPE_NOLOGNOSEE)
        {
            //如果内容是图片
//            float DEFAULTHEIGHT = 50;
            BeeUIImageView *imgview = [[BeeUIImageView alloc] initWithFrame:DEFAULIMAGERECT(MARGIN_LEFT,OriginY,MARGIN_RIGHT)];
            imgview.defaultImage = [UIImage bundleImageNamed:@"morenwututubiao"];
            imgview.contentMode= UIViewContentModeScaleAspectFit;
            imgview.enableAllEvents=YES;
            
            if (acont.type.integerValue == CONTENTTYPE_NOLOGNOSEE) {
                imgview.image=[UIImage bundleImageNamed:@"tishihuamian"];
            }
            else  if (acont.type.integerValue == CONTENTTYPE_IMG)
            {
//                 [imgview setData:acont.msg baseNetwork:YES];
                [imgview loadonlyCache:acont.msg];//仅仅获取缓存
            }
            float width=imgview.image.size.width;
            float height=imgview.image.size.height;
            float imgwith= MIN(imgview.image.size.width, 320 - MARGIN_RIGHT - MARGIN_LEFT);
            if (imgwith) {
                imgwith = 320 - MARGIN_RIGHT - MARGIN_LEFT; //
                float scale =  height / width ;
                float imgheight = imgwith * scale;  //imgview.image.size.height;
                imgview.size=CGSizeMake(imgwith, imgheight);
                CGRect frame=CGRectMake(MARGIN_LEFT, OriginY, imgwith, imgheight);
                imgview.frame=frame;
                OriginY = OriginY  + imgheight + DEFAULINTERVAL;
            }
            else
            {
                OriginY = OriginY  + DEFAULTHEIGHT + DEFAULINTERVAL;
            }
        }
    }
    OriginY = OriginY  + 10 ;
    CGRect rect = CGRectMake(0, 0, 320, OriginY + 30);

    [B3_PostBaseTableViewCell setCellHeight:OriginY];

    return rect.size.height;
}

+ (void)setCellHeight:(float)height
{
    cellHeight = height;
}

+ (float)height
{
    return cellHeight;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

ON_SIGNAL3(BeeUIImageView, LOAD_CACHE, signal)
{
//    SuppressPerformSelectorLeakWarning(
//                                       [self performSelector:loadcontentselector withObject:self.contentsAry withObject:[NSNumber numberWithBool:YES]]);
}

ON_SIGNAL3(BeeUIImageView, LOAD_COMPLETED, signal)
{
    SuppressPerformSelectorLeakWarning(
    [self performSelector:loadcontentselector withObject:self.contentsAry withObject:[NSNumber numberWithBool:YES]]);
}

- (void)imgviewTaped:(UITapGestureRecognizer *)gesture
{
    BeeUIImageView *imgview=(BeeUIImageView *) gesture.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:ShowBigImgview:imageView:)]) {
        
        if ([imgview.loadedURL rangeOfString:@"null"].location == NSNotFound) {
            NSString *imgurl= [NSString stringWithFormat:@"%@",imgview.loadedURL];
            [self.delegate B3_PostBaseTableViewCell:self ShowBigImgview:imgurl imageView:imgview];
        }
        else
        {
            [self.delegate B3_PostBaseTableViewCell:self ShowBigImgview:imgview.backupurl imageView:imgview];
        }
    }
}

- (void)reloadsubviews
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(cellpost:)]) {
         return;
    }
    
    if (self.delegate && [self.delegate typeOfcell:self]) {
        cell_type = [self.delegate typeOfcell:self];
        switch (cell_type) {
            case CELL_MAINTOPIC:
                _btnreply.hidden = YES;
                break;
            case CELL_REPLYTOPIC:
                _btnreply.hidden = NO;
                break;
            default:
                break;
        }
    }
    self.cellpost =[self.delegate cellpost:self];
    if (self.cellpost) {
        self.cellpost.title = [self.cellpost.title stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
        if ([NSString unicodeLengthOfString:self.cellpost.title] > 70) {//显示不下的用省略号
            self.cellpost.title = [NSString stringWithFormat:@"%@...",[NSString subStringByUnicodeIndex:self.cellpost.title asciiLength:70]];
        }
        self.lblTitle.text=self.cellpost.title;
        
        self.lbllandlord.text=self.cellpost.authorname;
        [self.imgprofile GET:self.cellpost.usericon useCache:NO];
        
        if ([self.delegate respondsToSelector:@selector(lblfloorText:)]) {
            self.lblfloor.text =[self.delegate lblfloorText:self];
        }
        
        NSString *timestr=@"";
        KT_DATEFROMSTRING(self.cellpost.postsdate, timestr);
        self.lbltime.text= [ToolsFunc datefromstring:self.cellpost.postsdate];
//#warning textColor
        self.lbltime.textColor = [UIColor lightGrayColor];
        if (self.delegate && [self.delegate respondsToSelector:@selector(typeToshowContent:)]) {
             TYPETOSHOWCONTENT type=[self.delegate typeToshowContent:self];
            if (type == FORMWEB) {
                 [self loadwebcontents:self.cellpost.content senddelegate:YES];
                 loadcontentselector = @selector(loadwebcontents:senddelegate:);
            }
            else if (type == FORMSELFDEFINE)
            {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadselfdefinecontents:self.cellpost.content senddelegate:NO];
                    loadcontentselector = @selector(loadselfdefinecontents:senddelegate:);
//                });
            }
        }
    }
}

#pragma mark - 加载头部
- (void)loadheaderviews
{
    if (_headerView) {
        for (UIView *view in _headerView.subviews) {
            [view removeFromSuperview];
        }
        [_headerView removeFromSuperview];
        _headerView=nil;
    }
    // Initialization code
    if (!self.delegate ||![self.delegate respondsToSelector:@selector(frameOfCellHeader:)]) {
        return;
    }
    headerFrame = [self.delegate frameOfCellHeader:self];
    _headerView=[[UIView alloc] initWithFrame:headerFrame];
    _headerView.backgroundColor=[UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(headerviewTap)];
    [_headerView addGestureRecognizer:tap];
    
    float originY = 5.0;
    if (self.delegate && [self.delegate isTopicArtile:self]) {
        BOOL topicarticle = [self.delegate isTopicArtile:self];
        self.lblTitle=[[UILabel alloc] init];
        KT_LABELEWIFRAM(self.lblTitle, CGRectMake(10, originY, 300, 40), @"", 16, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentLeft, YES);
        self.lblTitle.numberOfLines=2;
        [_headerView  addSubview:self.lblTitle];
        self.lbllandlord.hidden = !topicarticle;
        originY = originY + 40;
    }
    
    UILabel *louzhu=[[UILabel alloc] init];
    KT_LABELEWIFRAM(louzhu, CGRectMake(45, originY + 15, 40, 20), @"", 12, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentRight, NO);
    [_headerView addSubview:louzhu];
    louzhu.font = [UIFont systemFontOfSize:13];
    self.lblfloor = louzhu;
    
    self.lbllandlord=[[UILabel alloc] init];
    KT_LABELEWIFRAM(self.lbllandlord, CGRectMake(85, originY + 15, 70, 20), @"", 12, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentLeft, NO);
    self.lbllandlord.font = [UIFont systemFontOfSize:13];
    [_headerView addSubview:self.lbllandlord];
    
    /*
    UILabel *huifu=[[UILabel alloc] init];
    KT_LABELEWIFRAM(huifu, CGRectMake(55, originY + 20, 30, 20), @"回复:", 10, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentRight, NO);
    [_headerView addSubview:huifu];
    
    self.lblreply=[[UILabel alloc] init];
    KT_LABELEWIFRAM(self.lblreply, CGRectMake(85, originY + 20, 70, 20), @"0", 10, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentLeft, NO);
    [_headerView addSubview:self.lblreply];
    */
    
    BeeUIImageView *imgview1=[[BeeUIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    KT_IMGVIEW_CIRCLE(imgview1, 1);
    imgview1.backgroundColor=[UIColor grayColor];
    self.imgprofile=imgview1;
    
    UIButton *profileBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame=CGRectMake(10, originY + 5, 40, 40);
    [profileBtn addSubview:imgview1];
    [profileBtn addTarget:self action:@selector(profileBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:profileBtn];
    
    self.lbltime=[[UILabel alloc] init];
    KT_LABELEWIFRAM(self.lbltime, CGRectMake(200, originY + 15, 100, 20), @"", 12, [UIColor clearColor], [UIColor blackColor], NSTextAlignmentRight, NO);
    self.lbltime.font = [UIFont systemFontOfSize:13];
    [_headerView addSubview:self.lbltime];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(isTopicArtile:)]) {
        BOOL topicart = [self.delegate isTopicArtile:self];
        if (topicart) {
            UIImageView *splitimg =[[UIImageView alloc] initWithFrame:CGRectMake(10, 5 + CGRectGetMaxY(profileBtn.frame), self.frame.size.width - 20, 0.6)];
            splitimg.image=[UIImage bundleImageNamed:@"fengexian02"];
            [_headerView addSubview:splitimg];
        }
    }
    [self addSubview:_headerView];
    _btnreply = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnreply setImage:[UIImage bundleImageNamed:@"bianji"] forState:UIControlStateNormal];
    [_btnreply addTarget:self action:@selector(replyBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    UIEdgeInsets edg = UIEdgeInsetsMake(-15, -15, 0, 0);
    _btnreply.imageEdgeInsets =edg;
//    _btnreply.frame = CGRectMake(self.width - 35, headerFrame.size.height - 30, aframe.size.width, aframe.size.height);
    _btnreply.frame = FRAME_REPLYBTN(CGRectGetMaxY(headerFrame)-30);
     [self addSubview:_btnreply];
 
    //点赞按钮
    _btnsupport = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnsupport addTarget:self action:@selector(supportBtnTapped:) forControlEvents:UIControlEventTouchUpInside];

    _lblsupport = [[UILabel alloc] init];
    _lblsupport.font = [UIFont systemFontOfSize:12];
    _lblsupport.backgroundColor=[UIColor clearColor];
}

-(void)headerviewTap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:tappedheaderview:)]) {        
        if (headerviewSelected) {
            headerviewSelected = NO;
        }
        else
        {
            headerviewSelected = YES;
        }
        [self.delegate B3_PostBaseTableViewCell:self tappedheaderview:headerviewSelected];
    }
//    [self performSelector:@selector(loadselfdefinecontents:senddelegate:) withObject:self.cellpost.content withObject:[NSNumber numberWithBool:YES]];
}

-(IBAction)replyBtnTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:ReplyButtonTap:)]) {
        [self.delegate B3_PostBaseTableViewCell:self ReplyButtonTap:sender];
    }
}

-(IBAction)profileBtnTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:ProfileBtnTapped:)]) {
        [self.delegate B3_PostBaseTableViewCell:self ProfileBtnTapped:sender];
    }
}

- (void)supportBtnTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:supportBtnTapped:)]) {
        [self.delegate B3_PostBaseTableViewCell:self supportBtnTapped:sender];
    }
    [B3_PostBaseTableViewCell sharedInstance].btnsupport = sender;
    [B3_PostBaseTableViewCell sharedInstance].lblsupport = _lblsupport;
//    isHeader = _isHeader;
    support = [_support integerValue];
    
//    [self postNotification:self.SUPPORT];
}

- (void)setIsHeader:(BOOL)isHeader
{
    _isHeader = isHeader;
    if (isHeader) {
        _btnsupport.frame = CGRectMake(self.centerX - 17.5, _btnreply.frame.origin.y - 10, _btnreply.frame.size.width, _btnreply.frame.size.height);
        _lblsupport.frame = CGRectMake(self.centerX - 3, _btnreply.frame.origin.y + 15, _btnreply.frame.size.width, _btnreply.frame.size.height);
    }
}

- (void)setSupport:(NSNumber *)support
{
    _support = support;
    if (support != nil) {
        [self addSubview:_btnsupport];
        [self addSubview:_lblsupport];
        _lblsupport.text = [NSString stringWithFormat:@"%@", support];
    }
}

- (void)setStatus:(NSNumber *)status
{
    _status = status;
    if (status != nil) {
        if (status.integerValue == 1) {
            self.isHeader ? [_btnsupport setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/weidingtie(01)@2x" ofType:@"png"]] forState:UIControlStateNormal] : [_btnsupport setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/weidingtie@2x" ofType:@"png"]] forState:UIControlStateNormal];
        } else {
            self.isHeader ? [_btnsupport setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/weidingtie(02)@2x" ofType:@"png"]] forState:UIControlStateNormal] : [_btnsupport setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/dingtie@2x" ofType:@"png"]] forState:UIControlStateNormal];
        }
    }
}

- (void)B3_PostBaseTableViewCell:(void (^)(id sender))obj;
{
    if (obj) obj(_btnsupport);
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
