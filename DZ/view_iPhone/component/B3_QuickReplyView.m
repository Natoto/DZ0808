//
//  B3_QuickReplyView.m
//  DZ
//
//  Created by Nonato on 14-7-14.
//
//
#import "Bee.h"
#import "B3_QuickReplyView.h"
#import "FaceBoard.h"
#define REPLYAREAHEIGHT 40
@interface B3_QuickReplyView()<FaceBoardDelegate>
{
   FaceBoard       * facialView;
}
@end

@implementation B3_QuickReplyView
@synthesize sendbtn,replayField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIView *replayArea=[[UIView alloc] initWithFrame:frame];
        self.backgroundColor=[UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1];
        
        sendbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [sendbtn setTitle:@"回复" forState:UIControlStateNormal];
        sendbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        sendbtn.frame=CGRectMake(frame.size.width-55, 5, 60, frame.size.height-10);
        [sendbtn addTarget:self action:@selector(replybtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendbtn];
        
        UIButton *_btnFacial=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFacial setImage:[UIImage bundleImageNamed:@"biaoqing"] forState:UIControlStateNormal];
        _btnFacial.frame=CGRectMake(5, 5, 30, 30);
        _btnFacial.tag = 1414;
        [self addSubview:_btnFacial];
        [_btnFacial addTarget:self action:@selector(facailBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        BeeUITextView *txtfld=[[BeeUITextView alloc] initWithFrame:CGRectMake(36, 5, 235, frame.size.height-10)];
        txtfld.placeholder=self.placeholder?self.placeholder:@"这是快捷回复，只能发表情和文字！";
        //    txtfld.placeHolderLabel.font = [UIFont systemFontOfSize:20];
        //    [txtfld.placeHolderLabel updateConstraints];
        txtfld.backgroundColor=[UIColor whiteColor];
        txtfld.NONEEDUSERETURN = YES;
        KT_CORNER_RADIUS(txtfld, 4);
        [self addSubview:txtfld];
        replayField=txtfld;
        
        facialView=[[FaceBoard alloc] init];
        facialView.delegate = self;
        facialView.inputTextView=replayField;
        
    }
    return self;
}

ON_SIGNAL3(BeeUITextView, DID_ACTIVED, signal)
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_QuickReplyView:TextView:active:)]) {
        [self.delegate B3_QuickReplyView:self TextView:signal.sourceView active:YES];
    }
}

ON_SIGNAL3(BeeUITextView, DID_DEACTIVED, signal)
{
    [sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_QuickReplyView:TextView:active:)]) {
        [self.delegate B3_QuickReplyView:self TextView:signal.sourceView active:NO];
    }
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(IBAction)replybtnTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_QuickReplyView:replybtnTap:)]) {
        [self.delegate B3_QuickReplyView:self replybtnTap:sender];
    }
}

-(IBAction)facailBtnTap:(id)sender
{
    UIButton *button=(UIButton *)sender;
    if (button.tag == 1414) {
        button.tag = 1415;
        [button setImage:[UIImage bundleImageNamed:@"jianpan"] forState:UIControlStateNormal];
        replayField.inputView =facialView;
    }
    else
    {
        button.tag = 1414;
        [button setImage:[UIImage bundleImageNamed:@"biaoqing"] forState:UIControlStateNormal];
        replayField.inputView = nil;
    }
    [replayField reloadInputViews];
    [replayField becomeFirstResponder];
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_QuickReplyView:facailBtnTap:)]) {
//        [self.delegate B3_QuickReplyView:self facailBtnTap:sender];
//    }
}


-(void)faceboardBackface
{
    if (replayField.text.length) {
        NSString *edittext = replayField.text;
        float length=edittext.length;
        edittext=[edittext substringToIndex:length-1];
        replayField.text = edittext;
    }
}

-(void)facebuttonTap:(id)sender andName:(NSString *)name
{
    UIButton *button = sender;
    UIImage *stampImage = [button imageForState:UIControlStateNormal];
    if (stampImage) {
        replayField.text = [replayField.text stringByAppendingString:[NSString stringWithFormat:@"%@ ",name]];
    }
}

//-(NSMutableArray *)spliteFacialandText:(NSString *)text
//{
//    NSArray *compants=[text componentsSeparatedByString:@" "];
//    NSMutableArray *contentTextAry=[[NSMutableArray alloc] initWithCapacity:0];
//    
//    if (compants.count==0) {
//        replyContent *acont1=[[replyContent alloc] init];
//        acont1.msg=text;
//        acont1.type=[NSNumber numberWithInt:0];
//        [contentTextAry addObject:acont1];
//    }
//    for (int index = 0; index < compants.count; index ++) {
//        NSString *key=[compants objectAtIndex:index];
//        NSString *isfacion=[FaceBoard isExistFacail:key];
//        if (!isfacion) {//不是表情
//            replyContent *acont1=[[replyContent alloc] init];
//            acont1.msg=key;
//            acont1.type=[NSNumber numberWithInt:0];
//            [contentTextAry addObject:acont1];
//        }
//        else//是表情
//        {
//            replyContent *acont1=[[replyContent alloc] init];
//            acont1.msg=isfacion;
//            acont1.type=[NSNumber numberWithInt:0];
//            [contentTextAry addObject:acont1];
//        }
//    }
//    return contentTextAry;
//}



-(void)showInView:(CGRect)frame
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.frame=frame;
                     }];
}

-(void)Hide
{
    [UIView animateWithDuration:0.25
                     animations:^{
//                         toTopbtn.hidden=NO;
                         self.frame=CGRectMake(0, self.superview.bounds.size.height, self.superview.bounds.size.width, REPLYAREAHEIGHT);
                     }];
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
