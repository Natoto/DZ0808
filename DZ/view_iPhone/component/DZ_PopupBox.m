//
//  DZ_PopupBox.m
//  DZ
//
//  Created by Nonato on 14-8-5.
//
//

#import "DZ_PopupBox.h"
#import "CreateComponent.h"

#define CELL_START_TAG 140805
@interface DZ_PopupBox()
{
    UIScrollView *scrollview;
    UIButton * closebtn;
}
@end

@implementation DZ_PopupBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        self.alpha = 1;
        
        
        CGRect rect =[UIScreen mainScreen].bounds;
        self.contentView = [self checkinView:CGRectMake(0, 0, 290, 230)];
        self.contentView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        [self addSubview:_contentView];
        
        
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(IBAction)gestureTap:(id)sender
{
    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(DZ_PopupBox:MaskViewDidTaped:)])
    {
        [self.ppboxdelegate DZ_PopupBox:self MaskViewDidTaped:self];
    }
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    titlelabel.text =title;
}

-(UIView *)checkinView:(CGRect )frame
{
    if (!_contentView) {
        UIView *view=[[UIView alloc] initWithFrame:frame];
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithRed:236.0/255. green:237.0/255. blue:244./255 alpha:1];
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 2.0;
        view.layer.borderColor =[UIColor clearColor].CGColor;
        view.layer.borderWidth = 1.0;
        view.layer.cornerRadius = 5.0f;
        
        float MARGIN_TOP = 5.0;
        float MARGIN_LEFT = 10.0;
        float MARGIN_RIGHT = 10.0;
        float CLOSEWIDTH = 30;
        
        titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP, frame.size.width - MARGIN_LEFT -MARGIN_RIGHT, 40)];
        titlelabel.backgroundColor =[UIColor clearColor];
        [view addSubview:titlelabel];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *line=[self line:CGRectMake(CGRectGetMinX(titlelabel.frame), CGRectGetMaxY(titlelabel.frame) - 1, CGRectGetWidth(titlelabel.frame), LINE_LAYERBOARDWIDTH)];
        [view addSubview:line];
        
        closebtn = [CreateComponent CreateButtonWithFrame:CGRectMake(CGRectGetWidth(frame)- CLOSEWIDTH - MARGIN_RIGHT, CGRectGetMinY(titlelabel.frame), CLOSEWIDTH, CLOSEWIDTH) andImage:@"qdguanbi" tag:1844];
        [closebtn addTarget:self action:@selector(closebtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:closebtn];
        
        _contentView = view;
    }
    return _contentView;
}


-(void)closebtnTap:(id)sender
{
    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(DZ_PopupBox:MaskViewDidTaped:)])
    {
        [self.ppboxdelegate DZ_PopupBox:self MaskViewDidTaped:self];
    }
}

-(UIView *)line:(CGRect)frame
{
    UIView *view =[[UIView alloc] init];
    view.backgroundColor = LINE_LAYERBOARD_NOTCGCOLOR;
    view.frame = frame;
    return view;
}

-(void)loadDatas:(NSMutableDictionary *)diction
{
    scrollview = [self scrollview];
    NSArray * allkeys = diction.allKeys;
    int  index =0;
    for ( NSString *key in allkeys) {
        NSString *value =[diction valueForKey:key];
        [self createCell:key value:value index:index];
        index ++;
    }
}

-(void)createCell:(NSString *)key value:(NSString *)value index:(int)index
{
    float HEIGHT =40;
    float WIDTH = _contentView.frame.size.width - 20;
    UILabel *label =(UILabel *)[scrollview viewWithTag: CELL_START_TAG + index];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, index *HEIGHT -1, WIDTH , HEIGHT)];
        label.tag = CELL_START_TAG + index;
        [scrollview addSubview:label];
        scrollview.contentSize = CGSizeMake(WIDTH, (index +1) * HEIGHT);
        UIView *line=[self line:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) - 1, CGRectGetWidth(label.frame), LINE_LAYERBOARDWIDTH)];
        [scrollview addSubview:line];
    }
    NSString *text=[NSString stringWithFormat:@"%@ : %@",key,value];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];
     UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
    int LENGTH= key.length + 2;
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor blackColor]
                        range:NSMakeRange(0, LENGTH)];
    //把后面的变为绿色
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:color
                        range:NSMakeRange(LENGTH, text.length - LENGTH)];
    
    label.attributedText = attriString;
}

-(UIScrollView *)scrollview
{
    if (!scrollview) {
        UIScrollView *scrview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelabel.frame), CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) - CGRectGetMaxY(titlelabel.frame))];
        scrollview = scrview;
        [_contentView addSubview:scrview];
    }
    return scrollview;
}
- (void)show
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

-(void)hide
{
    [self removeFromSuperview];
}

@end
