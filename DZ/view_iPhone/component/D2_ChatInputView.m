//
//  D2_ChatInputView.m
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_ChatInputView.h"
#import "FaceBoard.h"
@implementation D2_ChatInputView
@synthesize replayField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIView *replayArea=[[UIView alloc] initWithFrame:frame];
        self.backgroundColor=[UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1];        
       
        UIButton *_btnFacial=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFacial setImage:[UIImage bundleImageNamed:@"biaoqing"] forState:UIControlStateNormal];
        _btnFacial.frame=CGRectMake(5, 5, 30, 30);
        _btnFacial.tag = 1414;
        [self addSubview:_btnFacial];
        [_btnFacial addTarget:self action:@selector(facailBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
        
        sendbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [sendbtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        sendbtn.frame=CGRectMake(frame.size.width-65, 5, 60, frame.size.height-10);
        [sendbtn addTarget:self action:@selector(replybtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendbtn];
        
        UITextView *txtfld=[[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnFacial.frame), 5,CGRectGetMinX(sendbtn.frame)- CGRectGetMaxX(_btnFacial.frame), frame.size.height-10)];
//        txtfld.placeholder=@"说点什么吧...";
        txtfld.delegate=self;
        txtfld.font = [UIFont systemFontOfSize:16];
        txtfld.backgroundColor=[UIColor whiteColor];
        KT_CORNER_RADIUS(txtfld, 4);
        [self addSubview:txtfld];
        replayField=txtfld;
        
        facialView=[[FaceBoard alloc] init];
        facialView.delegate = self;
        facialView.inputTextView=replayField;
    }
    return self;
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
//    UIButton *button = sender;
//    UIImage *stampImage = [button imageForState:UIControlStateNormal];
//    if (stampImage) {
      replayField.text = [replayField.text stringByAppendingString:[NSString stringWithFormat:@"%@",name]];
//    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [sendbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

-(void)resignFirstReponder
{
    [replayField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(D2_ChatInputdresignFirstResponder:)]) {
        [self.delegate D2_ChatInputdresignFirstResponder:replayField];
    }
}

-(IBAction)replybtnTap:(id)sender
{
//    [self resignFirstReponder]; 
    if (self.delegate && [ self.delegate respondsToSelector:@selector(D2_ChatInputdShouldSendMessage:) ]) {
        [self.delegate D2_ChatInputdShouldSendMessage:replayField];
    }
}
@end
