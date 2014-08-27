//
//  D0_CheckinsView.m
//  DZ
//
//  Created by Nonato on 14-7-24.
//
//

#import "D0_CheckinsView.h"
#import "UITextView_Boarder.h"
#import "SignModel.h"
#import "UserModel.h"
#import "DZ_SystemSetting.h"
#define BQ_START_TAG 171539

@interface D0_CheckinsView()
{
    BeeUITextView *textview;
    UIScrollView *scrollview;
    UIImageView * selectbgview;
    UIButton * closebtn;
}
@property(nonatomic,retain) SignModel *signmodel;
@end;
@implementation D0_CheckinsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.signmodel =[SignModel modelWithObserver:self];
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        self.alpha = 1;
        _biaoqings=@[@"ch.gif",@"fd.gif",@"kx.gif",@"ng.gif",\
                     @"nu.gif",@"shuai.gif",@"wl.gif",@"yl.gif",@"ym.gif"];
        

        
        CGRect rect =[UIScreen mainScreen].bounds;
        self.contentView = [self checkinView:CGRectMake(0, 0, 290, 230)];
        self.contentView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        [self addSubview:_contentView];
        
        selectbgview = [[UIImageView alloc] initWithFrame:CGRectZero];
        selectbgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"images.bundle/qdselect"]];
        selectbgview.hidden = YES;
        [_contentView addSubview:selectbgview];
        [_contentView sendSubviewToBack:selectbgview];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
        
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(UIView *)checkinView:(CGRect )frame
{
    if (!_contentView) {
        UIView *view=[[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithRed:236.0/255. green:237.0/255. blue:244./255 alpha:1];
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
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP, frame.size.width - MARGIN_LEFT -MARGIN_RIGHT, 40)];
        titlelabel.backgroundColor =[UIColor clearColor];
        titlelabel.text = @"您今天的心情";
        [view addSubview:titlelabel];
        
        UIView *line=[self line:CGRectMake(CGRectGetMinX(titlelabel.frame), CGRectGetMaxY(titlelabel.frame) - 1, CGRectGetWidth(titlelabel.frame), LINE_LAYERBOARDWIDTH)];
        [view addSubview:line];
        
        closebtn = [self CreateButtonWithFrame:CGRectMake(CGRectGetWidth(frame)- CLOSEWIDTH - MARGIN_RIGHT, CGRectGetMinY(titlelabel.frame), CLOSEWIDTH, CLOSEWIDTH) andImage:@"qdguanbi" tag:1844];
        [closebtn addTarget:self action:@selector(closebtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:closebtn];

        
        float BASE_Y = CGRectGetMaxY(titlelabel.frame);
        float BASE_X = CGRectGetMinX(titlelabel.frame);

        float MARGIN_H = 20.0;
        float MARGIN_V = 5;
        float BQ_WIDTH = 30.0;
        float BQ_HEIGHT = BQ_WIDTH;
        int H_COUNT =  (frame.size.width - MARGIN_LEFT - MARGIN_RIGHT) / (BQ_WIDTH + MARGIN_H);
        
        for (int index = 0; index < _biaoqings.count; index ++)
        {
            CGRect frame = CGRectMake(MARGIN_LEFT + (BQ_WIDTH)/2 + (BQ_WIDTH -MARGIN_LEFT ) * (index/H_COUNT) + (index % H_COUNT)*( BQ_WIDTH + MARGIN_H), BASE_Y + MARGIN_V + (index / H_COUNT) * (BQ_HEIGHT + MARGIN_V), BQ_WIDTH, BQ_HEIGHT);
            UIButton *button =[self CreateButtonWithFrame:frame andImage:[_biaoqings objectAtIndex:index] tag:(index + BQ_START_TAG)];
            [button addTarget:self action:@selector(xqbtnTap:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
        }
        
        float CHECKIN_WIDTH = 80;
        float CHECKIN_HEIGHT = 25;
        float TEXTVIEW_Y = BASE_Y + MARGIN_V + (_biaoqings.count / H_COUNT +1 ) * (BQ_HEIGHT + MARGIN_V);
        textview=[self CreateTextviewWithFrame:CGRectMake(MARGIN_LEFT, TEXTVIEW_Y, (frame.size.width - MARGIN_LEFT - MARGIN_RIGHT), frame.size.height - TEXTVIEW_Y - CHECKIN_HEIGHT- 2*MARGIN_V) andTxt:@"我今天最想说:"];
        [view addSubview:textview];
        
        
        CGRect rect =CGRectMake(CGRectGetMaxX(textview.frame) + 5 - CHECKIN_WIDTH, CGRectGetMaxY(textview.frame) + 5, CHECKIN_WIDTH, CHECKIN_HEIGHT);
        UIColor *COLOR = [DZ_SystemSetting sharedInstance].navigationBarColor;//[UIColor colorWithRed:20/255. green:154/255. blue:243/255. alpha:1];//CLR_BUTTON_TXT;
        UIButton *checkinBtn =[self CreateButtonWithFrame:rect andImage:nil tag:1020 title:@"开始签到" titlecolor:COLOR target:self sel:@selector(startCheckins:) bgcolor:[UIColor clearColor]];
        [view addSubview:checkinBtn];
        
        _contentView = view;
    }    
    return _contentView;
}
#pragma mark - 开始签到
-(void)startCheckins:(id)sender
{
    textview.text = textview.text.trim;
    if (!self.signmodel.qdxq) {
        [self presentMessageTips:@"请选择今天的心情"];
        return;
    }
    if (textview.text.length<3 || textview.text.length>50) {
        [self presentMessageTips:@"想说的话请控制在3~50字内(不能全空格)"];
        return;
    }
    self.signmodel.todaysay = textview.text;
    self.signmodel.uid = [UserModel sharedInstance].session.uid;
    [self.signmodel firstPage];
}

ON_SIGNAL3(SignModel, RELOADED, signal)
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D0_CheckinsView:signsuccess:message:)]) {
        [self.delegate D0_CheckinsView:self signsuccess:YES message:self.signmodel.shots.reward];
    }
}

ON_SIGNAL3(SignModel, FAILED, signal)
{
     [self presentMessageTips:[NSString stringWithFormat:@"%@",signal.object]];
}


-(void)xqbtnTap:(id)sender
{
    UIButton *button=(UIButton *)sender;
    NSInteger index = button.tag - BQ_START_TAG;
    NSString *bqstr = [_biaoqings objectAtIndex:index];
    NSLog(@"%@",bqstr);
    NSArray *bqstrcomponts=[bqstr componentsSeparatedByString:@"."];
    self.signmodel.qdxq =[NSString stringWithFormat:@"%@",[bqstrcomponts objectAtIndex:0]];
    [UIView animateWithDuration:0.2 animations:^{
        selectbgview.hidden = NO;
        selectbgview.frame = button.frame;
    } completion:^(BOOL finished) {
        selectbgview.hidden = NO;
        selectbgview.frame = button.frame;
    }];
}
-(void)closebtnTap:(id)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(D0_CheckinsView:MaskViewDidTaped:)])
    {
          [self.delegate D0_CheckinsView:self MaskViewDidTaped:self];
    }
}
-(IBAction)gestureTap:(id)sender
{
    [textview resignFirstResponder];

}

-(UIView *)line:(CGRect)frame
{
    UIView *view =[[UIView alloc] init];
    view.backgroundColor = LINE_LAYERBOARD_NOTCGCOLOR;
    view.frame = frame;
    return view;
}
- (BeeUITextView *)CreateTextviewWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    BeeUITextView *label = [[BeeUITextView alloc] initWithFrame:frame];
//    label.noboarder = YES;
//    label.NONEEDUSERETURN = YES;
    label.placeholder = TXT;
    label.font = GB_FontHelveticaNeue(15);//[UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;;
    return label;
}

- (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = TXT;
    label.font = GB_FontHelveticaNeue(15);//[UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
-(float)heightOftextviewTowView
{
    CGRect  frame = textview.frame;
    frame.origin.x = CGRectGetMinX(_contentView.frame) + frame.origin.x;
    frame.origin.y = CGRectGetMinY(_contentView.frame) + frame.origin.y;
    float height = CGRectGetHeight(self.frame) - CGRectGetMaxY(frame);
    return height;
}

- (UIButton *)CreateButtonWithFrame:(CGRect)frame andImage:(NSString *)image tag:(int)tag title:(NSString *)title titlecolor:(UIColor *)titlecolor target:(id)target sel:(SEL)selector bgcolor:(UIColor *)bgcolor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = frame;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:bgcolor];
    [button setTitleColor:titlecolor forState:UIControlStateNormal];
    return button;
}
- (UIButton *)CreateButtonWithFrame:(CGRect)frame andImage:(NSString *)image tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"images.bundle/%@",image]];
    [button setImage:img forState:UIControlStateNormal];
    button.frame = frame;
    button.tag = tag;
//    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

- (void)show
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

-(void)hide
{
    [textview resignFirstResponder];
    [self removeFromSuperview];
}


-(void)keybordWillAppear:(NSNotification *)notify
{
    NSDictionary* info  =  [notify userInfo];
    CGSize keyBoardSize =  [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    float textview2viewheight =[self heightOftextviewTowView];
    if (textview2viewheight < keyBoardSize.height) {
        self.contentView.center = CGPointMake(CGRectGetWidth(self.frame)/2 , CGRectGetHeight(self.frame)/2 - (keyBoardSize.height - textview2viewheight));
    }
    [UIView commitAnimations];
}
//-(void)resignAll:(UIGestureRecognizer *)gesture
//{ 
    //      bgtransparencyView.hidden=YES;
    //    bgtransparencyView=nil;
//}

-(void)keybordWillDisAppear:(NSNotification *)notify
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.contentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
